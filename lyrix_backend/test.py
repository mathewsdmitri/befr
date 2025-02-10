import requests
from urllib.parse import urlencode
import json
import os
from dotenv import load_dotenv
load_dotenv()
from SpotifyAPIClient import SpotifyAPIClient

#I added the actual api client if you need to test the client. At the moment I have removed any calls to it but just in case
#Please use spotify_client instead of SpotifyAPIClient as this is the class name
SPOTIFY_CLIENT_ID = os.getenv("CLIENT_ID")
SPOTIFY_CLIENT_SECRET = os.getenv("CLIENT_SECRET")
SPOTIFY_REDIRECT_URI = os.getenv("REDIRECT_URI")
spotify_client  = SpotifyAPIClient(client_id=SPOTIFY_CLIENT_ID, client_secret= SPOTIFY_CLIENT_SECRET, redirect_uri= SPOTIFY_REDIRECT_URI)


#user is registering account to webapp
url = 'http://127.0.0.1:8000/register_user'
user_data = {
    "username": "Shrek",
    "email": "isLove",
    "password": "Shrek",
    "bio": "",
    "access_token": ""
}

response = requests.post(url, json=user_data)

#Here is what frontend recevies
print(response.text)


#User is logging into web app 
user_data = {
    "username": "Shrek",
    "email": "",
    "password": "Shrek",
    "bio": "",
    "access_token": ""
}

url = "http://127.0.0.1:8000/login"
response = requests.get(url,json=user_data)
#Frontend receives a session id (uuid) and is now able to be logged into account
print(response.json)
uuid = json.loads(response.text)
print(uuid["uuid"])


#this needs to be ran and control+clicked and ran again so that your database sees that that there is an access token
url = f"http://127.0.0.1:8000/spotifyAuth?uniqueID={uuid["uuid"]}"
response = requests.get(url=url)
data = response.text

uuid = "d5c7e98e-ba50-40bc-a827-037fbdbb330e"
print(uuid)
url = f"http://127.0.0.1:8000/getRecentlyPlayed?uuid={uuid}"
response = requests.get(url=url)
data = response.text

print(data)
