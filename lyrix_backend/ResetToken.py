import secrets, bcrypt, smtplib, os, time, socket, re
from email.message import EmailMessage
from datetime import datetime, timedelta, timezone
from dotenv import load_dotenv
from models.Users import db, users_collection, bcrypt as users_bcrypt
from bson.objectid import ObjectId

load_dotenv()

tokens_collection = db["password_reset_tokens"] #Connect to the tokens collection
RESET_EXP_MINUTES = 60 #Expiration time for the reset token in minutes
EMAIL_REGEX = re.compile(r"^[^@]+@[^@]+\.[^@]+$")

def _make_aware(dt):
    # if it's already aware, force it into UTC; otherwise attach UTC
    if dt.tzinfo is None:
        return dt.replace(tzinfo=timezone.utc)
    else:
        return dt.astimezone(timezone.utc)


#token to reset password
def reset_token (user_id: ObjectId, token_hash: str, expiration: datetime):
   tokens_collection.insert_one({
       "user_id": user_id, 
       "token_hash": token_hash, 
       "expiration": expiration,
       "used": False
    })


def send_password_reset_email(username_or_email: str) -> dict:
    # 1) Look up the user:
    user = users_collection.find_one({"$or": [
        {"username": username_or_email},
        {"email":    username_or_email}
    ]})
    # security: always return the same shape
    if not user:
        return {"message": "If the account exists, a reset e‑mail has been sent."}

    # 2) Make a raw token & bcrypt‑hash it:
    raw_token = secrets.token_urlsafe(32).encode()
    bcrypt_hash = bcrypt.hashpw(raw_token, bcrypt.gensalt()).decode()

    expires = datetime.now(timezone.utc) + timedelta(minutes=RESET_EXP_MINUTES)
    tokens_collection.insert_one({
        "user_id": user["_id"],
        "token_hash": bcrypt_hash,
        "expiration": expires,
        "used": False
    })

    # 3) Build the reset link & e‑mail
    frontend = os.getenv("FRONTEND_URL", "http://localhost:5173")
    reset_link = f"{frontend}/reset?token={raw_token.decode()}"
    to_addr    = user["email"]
    if not EMAIL_REGEX.match(to_addr):
        return {"error": "Cannot send reset link: invalid email address on file."}

    msg = EmailMessage()
    msg["Subject"] = "Password Reset Request"
    msg["From"]    = os.getenv("SMTP_FROM")
    msg["To"]      = to_addr
    msg.set_content(
        f"Hi {user['username']},\n\n"
        "Click the link below to reset your password. "
        f"It expires in {RESET_EXP_MINUTES} minutes.\n\n"
        f"{reset_link}\n\n"
        "If you didn't request this, you can ignore this e‑mail."
    )

    # 4) If DEBUG, just return the raw token so your tests can pick it up:
    if os.getenv("DEBUG","false").lower()=="true":
        return {"message":"Reset e‑mail sent (dev)","token": raw_token}

    # 5) Otherwise actually SMTP it:
    try:
        with smtplib.SMTP_SSL(os.getenv("SMTP_HOST"), int(os.getenv("SMTP_PORT",465)), timeout=5) as smtp:
            smtp.login(os.getenv("SMTP_USER"), os.getenv("SMTP_PASS"))
            smtp.send_message(msg)
    except (socket.timeout, OSError) as e:
        print("SMTP error:", e)
        return {"error": "SMTP connection failed"}

    return {"message": "If the account exists, a reset e‑mail has been sent."}

def validate_password_reset(raw_token: str) -> dict:
    now_utc = datetime.now(timezone.utc)

    for doc in tokens_collection.find({"used": False}):
        exp = doc["expiration"]
        # if it ever comes back as a string, parse it:
        if not isinstance(exp, datetime):
            exp = datetime.fromisoformat(exp)
        exp = _make_aware(exp)

        stored_hash = doc["token_hash"].encode()
        if bcrypt.checkpw(raw_token.encode(), stored_hash):
            if exp < now_utc:
                return {"valid": False, "error": "Token expired"}
            return {"valid": True}

    return {"valid": False, "error": "Invalid token"}

def confirm_password_reset(raw_token: str, new_password: str) -> dict:
    now_utc = datetime.now(timezone.utc)

    for doc in tokens_collection.find({"used": False}):
        exp = doc["expiration"]
        if not isinstance(exp, datetime):
            exp = datetime.fromisoformat(exp)
        exp = _make_aware(exp)

        stored_hash = doc["token_hash"].encode()
        if bcrypt.checkpw(raw_token.encode(), stored_hash):
            if exp < now_utc:
                return {"error": "Token expired."}

            # update password
            new_hashed = bcrypt.hashpw(new_password.encode(), bcrypt.gensalt()).decode()
            users_collection.update_one(
                {"_id": doc["user_id"]},
                {"$set": {"password": new_hashed}}
            )
            # mark token used
            tokens_collection.update_one(
                {"_id": doc["_id"]},
                {"$set": {"used": True}}
            )
            return {"message": "Password reset successfully."}

    return {"error": "Invalid or already‑used token."}