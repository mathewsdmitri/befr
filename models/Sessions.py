from pymongo import MongoClient
from pydantic import BaseModel, EmailStr, ValidationError
import uuid


client = MongoClient("mongodb://localhost:27017/") #Connect to Mongodb locally (Change if connecting to Atlas)
db_session = client["Sessions"] 
sessions_collection = db_session["sessions"] 
db_users = client["Users"]
users_collection = db_users["users"]

class SessionModel(BaseModel):
     email: str
     username: str
     uuid: str

class Session:
    def __init__(self, username: str="", email: str="", uuid: str=""):
        self.username = username
        self.email = email
        self.uuid = uuid #Add hashing for encryption
    
    def generate_session(self, username:str, email:str):
        self.username = username
        self.email = email
        self.uuid = str(uuid.uuid4())
        session_data = {
            "username": self.username,
            "email": self.email,
            "uuid": self.uuid
            }
        sessions_collection.insert_one(session_data)

def find_in_session(uuid: str):
    session = sessions_collection.find_one({"uuid": uuid})

    if session:
        return session
    else:
        return None
    

