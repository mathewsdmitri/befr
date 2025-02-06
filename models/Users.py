from bson.objectid import ObjectId
from datetime import datetime
from pymongo import MongoClient
from pydantic import BaseModel, EmailStr, ValidationError
from .Sessions import Session


client = MongoClient("mongodb://localhost:27017/") #Connect to Mongodb locally (Change if connecting to Atlas)
db = client["Users"] # Connect to the Users database
users_collection = db["users"] #Connect to the users collection

class UserModel(BaseModel):
     email: str
     username: str
     password: str
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

    def __init__(self, username: str, email: str, password: str, bio="", access_token:str=""):
        self.username = username
        self.email = email
        self.password = password #Add hashing for encryption
        self.bio = bio
        self.access_token = access_token
        
    
    #Adds user to database and returns a string if the username is already in use or if the user registered succesfully
    def register_user(self):

        """Adds a user to the database if that user doesn't already exist."""

        #Check if the username and/or email already exists in the database


        try:

            if users_collection.find_one({"username": self.username}):
                return {"Error": "Username already in use!"}
        
            if users_collection.find_one({"email": self.email}):
                return {"Error": "Email already in use!"}
        
        #Create a dictionary with the user information to store into database

            user_data = {
                "username": self.username,
                "email": self.email,
                "password": self.password,
                "bio": self.bio
            }

            #Store the dictionary with the users data into the database
            users_collection.insert_one(user_data)

            return {"message": f"User '{self.username}' registered successfully!"}
        
        #Check for valid email format
        except ValidationError as e:
            return {"error": f"Validation Error: {e}"}
        
        #Catch any other errors that occur
        except Exception as e:
            return {"error": f"An unexpected error occurred: {e}"}
        
    def login_user(self):

        if users_collection.find_one({"username": self.username}):
            return {"Error": "Username already in use!"}
         

 

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
    print(auth_user)

    if user.password == auth_user.password:
        return User(auth_user.username, auth_user.email, auth_user.password, auth_user.bio)

def create_session(user:User):
    session_user = auth_user(user)
    new_session = Session()
    new_session.generate_session(session_user.username, session_user.email)
    return new_session

# Update the user's access token in the database
def token_to_user(access_token: str, uuid: str):
    
    # Finds a user in the database by their uuid and updates the access token
    result = users_collection.update_one(
        {"_id": ObjectId(uuid)},
        {"$set": {"access_token": access_token}}
    )

    if result.matched_count == 0:
        return {"error": "User not found!"}
    
    return {"message": "Access token updated successfully!"}

             



        



    #def delete_user():

   #     """Find and delete a user from the database if the user exists."""
        

    
