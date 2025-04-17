#These imports are for loading the enviroment with the ids from the spotify api
import os, bcrypt
from dotenv import load_dotenv

#The fastapi imports are for the app, Request is used to receive spotify authorization code
#HTTPException is for error handling
from fastapi import FastAPI, Request, HTTPException, Query
from models.Users import User, LoginModel, ProfileModel, create_session
from models.Sessions import Session
from fastapi.middleware.cors import CORSMiddleware
from SpotifyAPIClient import SpotifyAPIClient
from models.Users import token_post_to_user, uuid_to_access_token, uuid_to_user, find_user, check_access, follow_user, unfollow_user, delete_user, search_users, change_password
from models.Posts import PostModel, Post, InitPost, find_user_posts, like_post, unlike_post, add_comment, delete_comment, delete_post
from ResetToken import send_password_reset_email, confirm_password_reset, validate_password_reset
from models.Sessions import find_in_session, remove_session
from auth_procs import generate_random_string, sha256, base64encode
from datetime import datetime, timezone
from zoneinfo import ZoneInfo
from pydantic import BaseModel, EmailStr
from bson.objectid import ObjectId


load_dotenv()
SPOTIFY_CLIENT_ID = os.getenv("CLIENT_ID")
SPOTIFY_CLIENT_SECRET = os.getenv("CLIENT_SECRET")
SPOTIFY_REDIRECT_URI = os.getenv("REDIRECT_URI")
codeVerifier = generate_random_string(60)
print(codeVerifier + "  code verifier")
hashed = sha256(codeVerifier)
print(hashed)
codeChallenge = base64encode(hashed)
print(codeChallenge + " code challenge")

spotify_client  = SpotifyAPIClient(client_id=SPOTIFY_CLIENT_ID, client_secret= SPOTIFY_CLIENT_SECRET, redirect_uri= SPOTIFY_REDIRECT_URI, codeVerifier=codeVerifier, codeChallenge=codeChallenge)
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with your frontend's URL for more security
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
'''
This is how the models look in the models directory. 

class LoginModel(BaseModel):
    username: str
    email: str
    password: str
    bio: str
    access_token: str
    refresh_token: str

class ProfileModel(BaseModel):
    username: str
    email: str
    bio: str

    
class PostModel(BaseModel):
    username: str
    post_id: str
    content: str # Still need to refine this
    timestamp: datetime = datetime.utcnow() # Still need to refine this
    likes: list[dict] = []
    comments: list[dict] = []

'''

class FollowRequest(BaseModel):
    follower_user: str
    user_account: str

class LikeRequest(BaseModel):
    post_id: str
    username: str

class CommentRequest(BaseModel):
    post_id: str
    username: str
    comment_text: str

class DeleteCommentRequest(BaseModel):
    post_id: str
    username: str
    comment_id: str

class DeletePostRequest(BaseModel):
    post_id: str
    username: str 

class LogoutRequest(BaseModel):
    uuid: str

class DeleteAccountRequest(BaseModel):
    username: str
    requesting_user: str

class ChangePasswordRequest(BaseModel):
    username: str
    new_password: str

class ResetRequest(BaseModel):
    identifier: str #username or email

class ResetConfirm(BaseModel):
    token: str
    new_password: str

class ValidateResetRequest(BaseModel):
    token: str

#this is a post request to register users
@app.post("/register_user")
def register_user(user: LoginModel):
    new_user = User(username = user.username, email = user.email, password = user.password, bio = user.bio, access_token = user.access_token, refresh_token = user.refresh_token)
    return new_user.register_user()

@app.post("/login")
def login_user(user:LoginModel):
    print(user)
    session = create_session(user)
    return session

@app.post("/logout")
def logout_user(body: LogoutRequest):
    session = remove_session(body.uuid)
    return session

@app.post("/forgot_password")
def forgot_password(user:LoginModel):
    return find_user(user).password
    
@app.get("/get_user")   
def get_user(user: LoginModel):
    user = find_user(user).username
    return user

@app.get("/spotifyAuth")
def auth_spotify(uniqueID:str):
    uniqueID = uniqueID.replace('"', '')
    cur_user = uuid_to_user(uuid=uniqueID)
    existing_token = cur_user.access_token
    #if existing_token:
    #    return {"message": "Access token already exists, no need to re-authenticate."}
    redirect_query = spotify_client.access_code_query(uniqueID=uniqueID)
    print(redirect_query)
    return redirect_query

@app.get("/callback")
def callback(request:Request):
    uuid = request.query_params.get("state")
    response = spotify_client.get_access_token(request)


    if response.status_code !=200:
        raise HTTPException(status_code=response.status_code, detail = response.json())
    
    token_data = response.json()
    access_token  = token_data["access_token"]
    refresh_token = token_data["refresh_token"]
    print(access_token)
    print(refresh_token)
    update_response = token_post_to_user(access_token = access_token, uuid = uuid, refresh_token = refresh_token)
    # Open the file in write mode
    return update_response

@app.get("/getRecentlyPlayed")
def getRecentlyPlayed(uuid):
    cur_user = uuid_to_user(uuid=uuid)
    if cur_user.access_token == "":
        return []
    isExpired = check_access(cur_user)
    print(isExpired)
    response = spotify_client.refresh_access(isExpired, cur_user.access_token, cur_user.refresh_token)
    if isExpired:
        response = token_post_to_user(access_token=response['access_token'], uuid=uuid, refresh_token=response['refresh_token'])
    access_token = uuid_to_access_token(uuid=uuid)
    list = spotify_client.getsongs(access_token=access_token)
    pacific_tz = ZoneInfo("America/Los_Angeles")
    todays_date = datetime.now(pacific_tz).date()
    filtered = []
    for track in list:
        track_time = track["played_at"].replace("Z", "+00:00")
        played_dt_utc = datetime.fromisoformat(track_time)
        played_dt_pacific = played_dt_utc.astimezone(pacific_tz)
        if played_dt_pacific.date() == todays_date:
            exists = any(d.get("track_name") == track['track_name'] and d.get('artist_name') == track['artist_name']  for d in filtered)
            if not exists:
                filtered.append(track)
    print(filtered)
    return filtered

@app.post("/post")
def createPost(post:InitPost):
    user = uuid_to_user(post.uniqueId)
    if user.username == post.username:
        newPost = Post(username=post.username, content=post.content, album_url=post.album_url, track_name=post.track_name, artist_name=post.artist_name)
        newPost.create_post()
        return newPost.post_id
    
    return "You are not who you say you are"

@app.post("/follow")
def follow_endpoint(body: FollowRequest):  
    result = follow_user(body.follower_user, body.user_account)
    return result

@app.post("/unfollow")
def unfollow_endpoint(body: FollowRequest):
    result = unfollow_user(body.follower_user, body.user_account)
    return result

@app.post("/like")
def like_endpoint(body: LikeRequest):
    result = like_post(body.post_id, body.username)
    return result

@app.post("/unlike")
def unlike_endpoint(body: LikeRequest):
    result = unlike_post(body.post_id, body.username)
    return result


@app.post("/add_comment")
def comment_endpoint(body: CommentRequest):
    result = add_comment(
        post_id=body.post_id, 
        username=body.username, 
        comment_text=body.comment_text
    )
    return result

@app.post("/delete_comment")
def comment_endpoint(body: DeleteCommentRequest):
    result = delete_comment(
        post_id=body.post_id,
        username=body.username,
        comment_id=body.comment_id
    )
    return result


@app.delete("/delete_post")
def delete_post_endpoint(body: DeletePostRequest):
    
    result = delete_post(
        post_id=body.post_id,
        username=body.username
    )
    return result

@app.delete("/delete_account")
def delete_account(body: DeleteAccountRequest):
   
    result = delete_user(
        username=body.username,
        requesting_user=body.requesting_user
    )
    return result

@app.get("/search_users")
def search_users_endpoint(query: str = Query(...)):
    results = search_users(query)
    return results

@app.post("/change_password")
def change_password_endpoint(body: ChangePasswordRequest):
    result = change_password(username=body.username, new_password=body.new_password)
    return result

@app.post("/password_reset/request")
def password_reset_request(body: ResetRequest):
    return send_password_reset_email(body.identifier)

@app.get("/password_reset/validate")
def password_reset_validate(token: str = Query(...)):
    result = validate_password_reset(token)
    if not result["valid"]:
        raise HTTPException(400, result["error"])
    return {"valid": True}


@app.post("/password_reset/confirm")
def password_reset_confirm(body: ResetConfirm):
    result = confirm_password_reset(body.token, body.new_password)
    if "error" in result:
        raise HTTPException(400, result["error"])
    return result