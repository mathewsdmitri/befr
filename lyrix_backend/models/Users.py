from bson.objectid import ObjectId
from datetime import datetime, timedelta
from pymongo import MongoClient
from pydantic import BaseModel, EmailStr, ValidationError
import bcrypt
from .Sessions import Session, SessionModel, find_in_session
from dotenv import load_dotenv
import os
load_dotenv()

client = MongoClient(os.getenv("DATABASE_CONNECTION_STRING")) #Connect to Mongodb locally (Change if connecting to Atlas)
db = client["Users"] # Connect to the Users database
users_collection = db["users"] #Connect to the users collection

tokens_collection = db["password_rest_tokens"] #Connect to the tokens collection

#This is how you would pass data to the database and to receive it from the frontend
class LoginModel(BaseModel):
     email: str
     username: str
     password: str
     bio: str
     access_token: str
     refresh_token: str


class UserModel(BaseModel):
    email: str
    username: str
    password: str
    bio: str
    access_token: str
    refresh_token: str
    access_time : datetime
    followers : list
    following : list

#This model is used when you need to make queries to access spotify api
class ProfileModel(BaseModel):
    email: str
    username: str
    bio: str


class User:
    """
    A class to represent a User.

    Attributes:
        objectid (str): The user's unique ID
        username (str): The user's username
        email (Emailstr): The user's email
        password (str): The user's password
        bio (str): The user's bio(Optional)
        profile picture (Optional[UploadFile]): The uploaded profile picture file (Haven't added yet)
        date created (str): The date the user created their account (Haven't added yet)

    """ 

    def __init__(self, username: str, email: str, password: str, bio="", access_token:str="" , refresh_token:str = "", followers = [], following = []):
        self.username = username
        self.email = email
        self.password = password #Add hashing for encryption
        self.bio = bio
        self.access_token = access_token
        self.refresh_token = refresh_token
        self.access_time = datetime.now()
        self.followers = followers
        self.following = following

        
    
    #Adds user to database and returns a string if the username is already in use or if the user registered succesfully
    def register_user(self):

        """Adds a user to the database if that user doesn't already exist."""

        #Check if the username and/or email already exists in the database
        existing_user = users_collection.find_one({"username": self.username})
        if existing_user:
            return {"Error": "Username already exists"}

        existing_email = users_collection.find_one({"email": self.email})
        if existing_email:
            return {"Error": "Email already in use"}
        

        #Encrypt password
        hashed_bytes = bcrypt.hashpw(self.password.encode("utf-8"), bcrypt.gensalt())

        hashed_str = hashed_bytes.decode("utf-8")

        #User data to be stored
        user_data = {
            "email": self.email,
            "username": self.username,
            "password": hashed_str, 
            "bio": self.bio,
            "access_token": self.access_token,
            "refresh_token": self.refresh_token,
            "access_time" : self.access_time,
            "followers": self.followers,
            "following": self.following

        }

        #Store user data into database
        users_collection.insert_one(user_data)

        #Automatically log in user after registration is complete
        #request.session["username"] = self.username

        return{"message": "Successfully Registered"}

        
    def login_user(username, password):
        
        user = users_collection.find_one({"username": username})
        if not user:
            return{"error": "User not found"}
            
        stored_hash_str = user["password"]
        stored_hash_bytes = stored_hash_str.encode("utf-8")

        if bcrypt.checkpw(password.encode("utf-8"), stored_hash_bytes):
            # Auth success!
            return {"message": "Login successful"}
        else:
            return {"error": "Invalid password."}

def delete_user(username: str, requesting_user: str):
    if username != requesting_user:
        return {"error": "You do not have permission to delete this account."}
    
    user_account = users_collection.find_one({"username": username})
    if not user_account:
        return {"error": "User not found."}
    
    users_collection.delete_one({"_id": user_account["_id"]})
        
    return {"message": "User account deleted successfully!"}
 
#Pass in a User object can be passed with ex. User(username="some name", email= "")
#This would find a user "some name" if they exist it will return all information that the user has in the database.

'''I am not sure if this function is needed'''

def find_user(user:User):

        """Finds and returns a user in the database if the user exists."""

        #Check if the username exists and return the username if it does exist

        existing_user = users_collection.find_one({"username": user.username})

        if existing_user:
            auth_user = UserModel(**existing_user)
            return auth_user

        existing_user = users_collection.find_one({"email": user.email})

        if user:
            return UserModel(**existing_user)
        

        return {"error": "User not found!"}

def follow_user(follower_user: str, user_account: str):
    """
    Make 'follower_user' follow 'user_account' by:
      1) Pushing 'follower_user' into user_account's "followers"
      2) Pushing 'user_account' into follower_user's "following"
    """
    # 1. Grab each document
    useraccount_doc = users_collection.find_one({"username": user_account})
    follower_doc = users_collection.find_one({"username": follower_user})

    if not follower_doc or not useraccount_doc:
        return {"error": "One or both users not found."}

    # 2. Check if already following
    # If the user_account has 'follower_user' in 'followers' array,
    # or if 'follower_user' doc has 'user_account' in 'following'.
    if follower_user in useraccount_doc.get("followers", []) \
       or user_account in follower_doc.get("following", []):
        return {"message": f"{follower_user} already follows {user_account}."}

    # 3. Add 'follower_user' to user_account's "followers"
    users_collection.update_one(
        {"username": user_account},
        {"$push": {"followers": follower_user}}
    )
    # 4. Add 'user_account' to follower_user's "following"
    users_collection.update_one(
        {"username": follower_user},
        {"$push": {"following": user_account}}
    )

    return {"message": f"{follower_user} is now following {user_account}."}


def unfollow_user(follower_user: str, user_account: str):
    """
    Make 'follower_user' unfollow 'user_account' by:
      1) Pulling 'follower_user' from user_account's "followers"
      2) Pulling 'user_account' from follower_user's "following"
    """
    # 1. Grab each document
    useraccount_doc = users_collection.find_one({"username": user_account})
    follower_doc = users_collection.find_one({"username": follower_user})

    if not follower_doc or not useraccount_doc:
        return {"error": "One or both users not found."}

    # 2. Check if follower_user is actually following user_account
    if follower_user not in useraccount_doc.get("followers", []) \
       or user_account not in follower_doc.get("following", []):
        return {"message": f"{follower_user} is not following {user_account}."}

    # 3. Remove 'follower_user' from user_account's "followers"
    users_collection.update_one(
        {"username": user_account},
        {"$pull": {"followers": follower_user}}
    )
    # 4. Remove 'user_account' from follower_user's "following"
    users_collection.update_one(
        {"username": follower_user},
        {"$pull": {"following": user_account}}
    )

    return {"message": f"{follower_user} has unfollowed {user_account}."}


#Finds user with username and authorizes account with their password. If the account is found it returns the whole user from database
def auth_user(user:User):
    auth_user = find_user(user)
    
    stored_hash_str = auth_user.password

    stored_hash_bytes = stored_hash_str.encode("utf-8")

    if bcrypt.checkpw(user.password.encode("utf-8"), stored_hash_bytes):
         return User(auth_user.username, auth_user.email, auth_user.password, auth_user.bio)
        
    else:
         return {"error": "Invalid password."}

#Create session authorizes user that logs in. They are passed the unique id so that they can access app
def create_session(user:User):
    session_user = auth_user(user)
    new_session = Session()
    new_session.generate_session(session_user.username, session_user.email)
    return new_session


def uuid_to_user(uuid:str):
    session = find_in_session(uuid)
    print (session)
    user = find_user(User(username=session.username, email=session.email, password=""))
    return user
    
# Update the user's access token in the database
def token_post_to_user(access_token: str, uuid: str, refresh_token: str):
    
    # Finds a user in the database by their uuid and updates the access token
    user  = uuid_to_user(uuid)
    result = users_collection.update_one(
        filter=users_collection.find_one({"username": user.username}),
        update={"$set": {"access_token": access_token, "refresh_token": refresh_token, "access_time": datetime.now()}}
    )

    if result.matched_count == 0:
        return {"error": "User not found!"}
    
    return {"message": "Access token updated successfully!"}

def check_access(user:User):
    difference = datetime.now() - user.access_time
    print(difference)
    if difference < timedelta(hours=1):
        return False
    return True
#Gets user spotify access_token from the uuid
def uuid_to_access_token(uuid):
    cur_user = uuid_to_user(uuid)   
    return cur_user.access_token
    
def search_users(query: str):

    cursor = users_collection.find({"username": {"$regex":query, "$options": "i"}})  

    results = []        
    
    #Useful if you want more information from the user search
    '''for doc in cursor:
        doc.pop("password", None)       # Remove the password field from the document
        doc.pop("access_token", None)   # Remove the access_token field from the document
        doc.pop("refresh_token", None)  # Remove the refresh_token field from the document
        doc.pop("_id", None)            # Remove the _id field from the document
        doc.pop("email", None)          # Remove the email field from the document
        doc.pop("bio", None)            # Remove the bio field from the document
        doc.pop("access_time", None)    # Remove the access time field from the document
        doc.pop("followers", None)      # Remove the followers field from the document
        doc.pop("following", None)      # Remove the following field from the document
        
        results.append(doc)             # Append the modified document to the results list'''
    
    # Get only the usernames from the cursor
    results = [doc.get("username") for doc in cursor]

    return results 

#primitive function to change password
def change_password(username: str, new_password: str):
    
    user = users_collection.find_one({"username": username})
    if not user:
        return {"error": "User not found!"}

    # Encrypt the new password
    hashed_bytes = bcrypt.hashpw(new_password.encode("utf-8"), bcrypt.gensalt())
    hashed_str = hashed_bytes.decode("utf-8")

    # Update the user's password in the database
    users_collection.update_one({"username": username}, {"$set": {"password": hashed_str}})
    
    return {"message": "Password updated successfully!"}
