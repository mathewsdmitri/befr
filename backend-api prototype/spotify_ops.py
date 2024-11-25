import os
from urllib.parse import urlencode
from fastapi import Request, HTTPException
import requests

def access_code_query(spotify_client_id, spotify_redirect_uri):
    redirect_params = {
        "client_id" : spotify_client_id,
        "response_type" : "code",
        "redirect_uri" : spotify_redirect_uri,
        "scope" : "user-read-recently-played",
    }
    redirect_query = urlencode(redirect_params)
    return redirect_query

def get_access_token(spotify_redirect_uri, spotify_client_id, spotify_client_secret, request):
    code = request.query_params.get("code")
    if not code:
        raise HTTPException(status_code=400, detail="Authorization code not found.")
    
    url = "https://accounts.spotify.com/api/token"
    data = {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri" : spotify_redirect_uri,
        "client_id" : spotify_client_id,
        "client_secret": spotify_client_secret,
    }
    headers = {"Content-Type" : "application/x-www-form-urlencoded"}
    response = requests.post(url=url, data=data,headers=headers)
    return response

def get_access_token_from_file():
    with open("access_tokens.txt", "r") as file:
        first_line = file.readline()
    return first_line