#These imports are for loading the enviroment with the ids from the spotify api
import os
from dotenv import load_dotenv

#The fastapi imports are for the app, Request is used to receive spotify authorization code
#HTTPException is for error handling
from fastapi import FastAPI, Request, HTTPException
from models.Users import User, LoginModel, AccessModel, create_session
from models.Sessions import Session
from fastapi.middleware.cors import CORSMiddleware
from SpotifyAPIClient import SpotifyAPIClient
from models.Users import token_post_to_user, uuid_to_access_token, uuid_to_user
from models.Sessions import find_in_session
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
'''
This is how the models look in the models directory. 

class LoginModel(BaseModel):
    username: str
    email: str
    password: str
    bio: str
    access_token: str

class SessionModel(BaseModel):
    username: str
    email: str
    uuid: str

'''
#this is a post request to register users
@app.post("/register_user")
def register_user(user: LoginModel):
    new_user = User(user.username, user.email, user.password)
    return new_user.register_user()

@app.post("/login")
def login_user(user:LoginModel):
    print(user)
    session = create_session(user)
    return session.uuid
    

@app.get("/spotifyAuth")
def auth_spotify(uniqueID):
    cur_user = uuid_to_user(uuid=uniqueID)
    existing_token = cur_user.access_token
    if existing_token:
        return {"message": "Access token already exists, no need to re-authenticate."}
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
    update_response = token_post_to_user(access_token, uuid)
    # Open the file in write mode
    return update_response

@app.get("/getRecentlyPlayed")
def getRecentlyPlayed(uuid):
    access_token = uuid_to_access_token(uuid=uuid)
    list = spotify_client.getsongs(access_token=access_token)
    return list