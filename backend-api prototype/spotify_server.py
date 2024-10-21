#figuring out user auth with spotify api to get recently played songs
import os
from dotenv import load_dotenv
from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import RedirectResponse, JSONResponse
from urllib.parse import urlencode
import requests
load_dotenv()
SPOTIFY_CLIENT_ID = os.getenv("CLIENT_ID")
SPOTIFY_CLIENT_SECRET = os.getenv("CLIENT_SECRET")
SPOTIFY_REDIRECT_URI = os.getenv("REDIRECT_URI")
app = FastAPI()



#this line below is a decorator and is essentially the home page.
# When the server runs on http://localhost:8000/
#The def will be run
@app.get("/")
def read_root():
    return {"message": "FastAPI is running!"}


@app.get("/login")
def login():
    params = urlencode({
        "client_id" : SPOTIFY_CLIENT_ID,
        "response_type" : "code",
        "redirect_uri" : SPOTIFY_REDIRECT_URI,
        "scope" : "user-read-recently-played",
    })
    return RedirectResponse(f"https://accounts.spotify.com/authorize?{params}")

@app.get("/callback")
def callback(request: Request):
    code = request.query_params.get("code")
    if not code:
        raise HTTPException(status_code=400, detail="Authorization code not found.")
    
    url = "https://accounts.spotify.com/api/token"
    data = {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri" : SPOTIFY_REDIRECT_URI,
        "client_id" : SPOTIFY_CLIENT_ID,
        "client_secret": SPOTIFY_CLIENT_SECRET,
    }
    headers = {"Content-Type" : "application/x-www-form-urlencoded"}
    response = requests.post(url=url, data=data,headers=headers)

    if response.status_code !=200:
        raise HTTPException(status_code=response.status_code, detail = response.json())
    
    token_data = response.json()
    access_token  = token_data["access_token"]

    return RedirectResponse(f"/recently-played?access_token={access_token}")


@app.get("/recently-played")
def recently_played(access_token):
    url  = "https://api.spotify.com/v1/me/player/recently-played"
    headers = {"Authorization" : f"Bearer {access_token}"}
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code,detail=response.json())
    
    data = response.json()

    tracks = [
        {
            "track_name" : item["track"]["name"],
            "artist_name" : item["track"]["artists"][0]["name"],
            "played_at" : item["played_at"]
        }
        for item in data.get("items",[])
    ]
    for track in tracks:
        print (track["track_name"] + " - " + track["artist_name"])
        print("This song was played at " + track["played_at"])
        print(" ")
        
    return JSONResponse(content={"recently_played": tracks})