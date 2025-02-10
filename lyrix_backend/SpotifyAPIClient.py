import os
from urllib.parse import urlencode
from fastapi import Request, HTTPException
import requests
from models.Users import uuid_to_access_token

class SpotifyAPIClient:
    def __init__(self, client_id:str, client_secret:str, redirect_uri:str ):
        self.client_id = client_id
        self.client_secret = client_secret
        self.redirect_uri = redirect_uri
    
    def access_code_query(self, uniqueID:str):
        redirect_params = {
            "client_id" : self.client_id,
            "response_type" : "code",
            "redirect_uri" : self.redirect_uri,
            "scope" : "user-read-recently-played",
            "state" : uniqueID
        }
        redirect_query = urlencode(redirect_params)
        query = f"https://accounts.spotify.com/authorize?{redirect_query}"
        return query

    def get_access_token(self, request:Request):
        code = request.query_params.get("code")
        if not code:
            raise HTTPException(status_code=400, detail="Authorization code not found.")
    
        url = "https://accounts.spotify.com/api/token"
        data = {
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri" : self.redirect_uri,
            "client_id" : self.client_id,
            "client_secret": self.client_secret,
        }
        headers = {"Content-Type" : "application/x-www-form-urlencoded"}
        response = requests.post(url=url, data=data,headers=headers)
        return response
    
    def getsongs(self, access_token):
        url  = "https://api.spotify.com/v1/me/player/recently-played"
        headers = {"Authorization" : f"Bearer {access_token}"}
        response = requests.get(url, headers=headers)

        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code,detail=response.json())
        
        data = response.json()
        
        items = data["items"]
        tracks = []
        for item in items:
            tracks.append({"track_name": item["track"]["name"],
                        "artist_name": item["track"]["artists"][0]["name"],
                        "played_at": item["played_at"],
                        })
            
        return tracks