from bson.objectid import ObjectId
from datetime import datetime
from pymongo import MongoClient


client = MongoClient("mongodb://localhost:27017/") #Connect to Mongodb locally (Change if connecting to Atlas)
db = client["Users"] # Connect to the Users database
users_collection = db["users"] #Connect to the users collection

class User:
    """
    A class to represent a User.

    Attributes:
        objectid (str): The user's unique ID
        username (str): The user's username
        email (Emailstr): The user's email
        password (str): The user's password
        bio (str): The user's bio(Optional)
        profile picture (Optional[UploadFile]): The uploaded profile picture file
        date created (str): The date the user created their account

    """ 

    def __init__(self, username: str, email: str, password: str, bio=""):
        self.username = username
        self.email = email
        self.password = password #Add hashing for encryption
        self.bio = bio
        
    
    def register_user(self):

        """Adds a user to the database if that user doesn't already exist."""

        #Check if the username and/or email already exists in the database

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
            

 

    def find_user(self):

        """Finds and returns a user in the database if the user exists."""

        #Check if the username exists and return the username if it does exist

        user = users_collection.find_one({"username": self.username})

        if user:
            return {"user": user}

        user = users_collection.find_one({"email": self.email})

        if user:
            return {"user": user}
        

        return {"error": "User not found!"}



        



    def delete_user():

        """Find and delete a user from the database if the user exists."""
        

    
