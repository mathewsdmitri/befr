#figuring out user auth with spotify api to get recently played songs

#These imports are for loading the enviroment with the ids from the spotify api
import os
from dotenv import load_dotenv

#The fastapi imports are for the app, Request is used to receive spotify authorization code
#HTTPException is for error handling
from fastapi import FastAPI, Request, HTTPException

#Responses are used to serve the redirect to spotify auth
from fastapi.responses import RedirectResponse

#This function is to encode the paramaters that spotify needs to authorize and redirect 
from urllib.parse import urlencode

#requests is used to hit api endpoints 
import requests


from fastapi import FastAPI
from starlette.responses import FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
import json
from spotify_ops import access_code_query, get_access_token, get_access_token_from_file, post_access_token_to_database
from spotify_ops import get_access_token_with_uuid

#loading .env variables and assigning them to variable names
load_dotenv()
SPOTIFY_CLIENT_ID = os.getenv("CLIENT_ID")
SPOTIFY_CLIENT_SECRET = os.getenv("CLIENT_SECRET")
SPOTIFY_REDIRECT_URI = os.getenv("REDIRECT_URI")

#create fastapi app instance
app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with your frontend's URL for more security
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#this line below is a decorator and is essentially the home page.
# When the server runs on http://localhost:8000/
#The def will be run
#@app.get("/")
#def read_root():
#    return {"message": "FastAPI is running!"}
def songlist(access_token):
    url  = "https://api.spotify.com/v1/me/player/recently-played"
    headers = {"Authorization" : f"Bearer {access_token}"}
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code,detail=response.json())
    
    data = response.json()
    
    items = data["items"]
    tracks = []
    for item in items:
        print (item)
        tracks.append({"track_name": item["track"]["name"],
                       "artist_name": item["track"]["artists"][0]["name"],
                       "played_at": item["played_at"],
                       })
        
    return tracks

@app.get("/")
async def read_index():
    return FileResponse('index.html')


#when you go to http://localhost:8000/login
#Will have you login into spotify and authorize reading recently played
#Encodes necessary parameters into a query string
#When this is done, user will be redirected to http://localhost:8000/callback
@app.get("/login")
def login(uniqueID):
    redirect_query = access_code_query(spotify_client_id=SPOTIFY_CLIENT_ID,spotify_redirect_uri=SPOTIFY_REDIRECT_URI, uniqueID=uniqueID)
    #return RedirectResponse(f"https://accounts.spotify.com/authorize?{redirect_query}")
    query = f"https://accounts.spotify.com/authorize?{redirect_query}"
    print (query)
    return query

#This receives the auth code and passes in the code and the ids to get an access token. We then pass in this token to use the api.
@app.get("/callback")
def callback(request: Request):
    uuid = request.query_params.get("state")
    print(uuid)
    response = get_access_token(SPOTIFY_REDIRECT_URI, SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET, request)


    if response.status_code !=200:
        raise HTTPException(status_code=response.status_code, detail = response.json())
    
    token_data = response.json()
    access_token  = token_data["access_token"]
    post_access_token_to_database(access_token, uuid)
    # Open the file in write mode
    return "Login Successful, Procceed to Application."
    #return RedirectResponse(f"/getlistofsongs?access_token={access_token}")

@app.get("/getlistofsongs")
def getsongs(uniqueID):
    access_token = get_access_token_with_uuid(uniqueID)
    url  = "https://api.spotify.com/v1/me/player/recently-played"
    headers = {"Authorization" : f"Bearer {access_token}"}
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code,detail=response.json())
    
    data = response.json()
    
    items = data["items"]
    tracks = []
    for item in items:
        #print (item)
        tracks.append({"track_name": item["track"]["name"],
                       "artist_name": item["track"]["artists"][0]["name"],
                       "played_at": item["played_at"],
                       })
        
    return tracks

@app.get("/recently-played")
def recently_played():
    return FileResponse('index2.html')

@app.get("/getHelloPls")
def getHello():
    return "This is an api request."
