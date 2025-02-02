import os
from dotenv import load_dotenv
from fastapi import FastAPI
from pydantic import BaseModel
from models.Users import User
from fastapi.middleware.cors import CORSMiddleware
from lyrix_backend.SpotifyAPIClient import SpotifyAPIClient
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



@app.post("/register_user")
async def register_user(user: UserSchema):
    new_user = User(user.username, user.email, user.password, user.bio)
    return new_user.register_user()

@app.get("/spotifyAuth")
def auth_spotify(uniqueID):
    redirect_query = spotify_client.access_code_query(uniqueID=uniqueID)
    query = f"https://accounts.spotify.com/authorize?{redirect_query}"
    return query
