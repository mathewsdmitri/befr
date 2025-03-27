from bson.objectid import ObjectId
from datetime import datetime, timedelta
from pymongo import MongoClient
from pydantic import BaseModel, EmailStr, ValidationError
import bcrypt
from .Sessions import Session, SessionModel, find_in_session


client = MongoClient("mongodb://localhost:27017/") #Connect to Mongodb locally (Change if connecting to Atlas)
db = client["Users"] # Connect to the Users database
users_collection = db["users"] #Connect to the users collection

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
    friends: list

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

    def __init__(self, username: str, email: str, password: str, bio="", access_token:str="" , refresh_token:str = "", friends = []):
        self.username = username
        self.email = email
        self.password = password #Add hashing for encryption
        self.bio = bio
        self.access_token = access_token
        self.refresh_token = refresh_token
        self.access_time = datetime.now()
        self.friends = friends

        
    
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
            "friends": self.friends

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

    
         

 
#Pass in a User object can be passed with ex. User(username="some name", email= "")
#This would find a user "some name" if they exist it will return all information that the user has in the database.
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
    