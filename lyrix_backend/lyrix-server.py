#These imports are for loading the enviroment with the ids from the spotify api
import os
from dotenv import load_dotenv

#The fastapi imports are for the app, Request is used to receive spotify authorization code
#HTTPException is for error handling
from fastapi import FastAPI, Request, HTTPException
from pydantic import BaseModel
from models.Users import User, auth_user, create_session
from models.Sessions import Session
from fastapi.middleware.cors import CORSMiddleware
from lyrix_backend.SpotifyAPIClient import SpotifyAPIClient
from models.Users import token_to_user
load_dotenv()
SPOTIFY_CLIENT_ID = os.getenv("CLIENT_ID")
SPOTIFY_CLIENT_SECRET = os.getenv("CLIENT_SECRET")
SPOTIFY_REDIRECT_URI = os.getenv("REDIRECT_URI")

spotify_client  = SpotifyAPIClient(client_id=SPOTIFY_CLIENT_ID, client_secret= SPOTIFY_CLIENT_SECRET, redirect_uri= SPOTIFY_REDIRECT_URI)
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with your frontend's URL for more security
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class UserSchema(BaseModel):
    username: str
    email: str
    password: str
    bio: str = ""

class Session(BaseModel):
    username: str
    uuid: str


@app.post("/register_user")
def register_user(user: UserSchema):
    new_user = User(user.username, user.email, user.password, user.bio)
    return new_user.register_user()

@app.get("/login")
def login_user(user:UserSchema):
    session = create_session(user)
    return session
    

@app.get("/spotifyAuth")
def auth_spotify(uniqueID):
    redirect_query = spotify_client.access_code_query(uniqueID=uniqueID)
    print (redirect_query)
    return redirect_query

@app.get("/callback")
def callback(request:Request):
    print(request)
    uuid = request.query_params.get("state")
    print(uuid)
    response = spotify_client.get_access_token(request)


    if response.status_code !=200:
        raise HTTPException(status_code=response.status_code, detail = response.json())
    
    token_data = response.json()
    access_token  = token_data["access_token"]
    update_response = token_to_user(access_token, uuid)
    # Open the file in write mode
    return "Success! Procceed to app"