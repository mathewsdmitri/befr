import os
from urllib.parse import urlencode
from fastapi import Request, HTTPException
import requests




class SpotifyAPIClient:
    def __init__(self, client_id:str, client_secret:str, redirect_uri:str, codeVerifier, codeChallenge):
        self.client_id = client_id
        self.client_secret = client_secret
        self.redirect_uri = redirect_uri
        self.codeVerifier = codeVerifier
        self.codeChallenge = codeChallenge
        
    
    def access_code_query(self, uniqueID:str):
        redirect_params = {
            "client_id" : self.client_id,
            "response_type" : "code",
            "redirect_uri" : self.redirect_uri,
            "scope" : "user-read-recently-played",
            "state" : uniqueID,
            "code_challenge_method": 'S256',
            "code_challenge" : self.codeChallenge
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
            "code_verifier" : self.codeVerifier,
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
        print(response)
        data = response.json()
   
        items = data["items"]
        print (items)
        tracks = []
        for item in items:
            track_data = item.get("track", {})
            album_data = track_data.get("album", {})
            images = album_data.get("images", [])

            tracks.append({
                "track_name": track_data.get("name"),
                "artist_name": track_data.get("artists", [{}])[0].get("name"),
                "played_at": item.get("played_at"),
                "album_art_url": images[0]["url"] if images else None
            })
                    
        return tracks
    
    def search_track(self, access_token: str, track_name: str) -> str:
        """
        Searches Spotify for a track and returns the preview (snippet) URL if available.
        Returns None or raises HTTPException if no preview is found or request fails.
        """
        base_url = "https://api.spotify.com/v1/search"
        headers = {
            "Authorization": f"Bearer {access_token}"
        }
        params = {
            "q": track_name,
            "type": "track",
            "limit": 1  # just get the top result
        }

        response = requests.get(base_url, headers=headers, params=params)
        if response.status_code != 200:
            raise HTTPException(status_code=response.status_code, detail=response.json())

        data = response.json()
        tracks = data.get("tracks", {}).get("items", [])
        print(tracks)
        if not tracks:
            # No matching track found
            return None

        # The snippet/preview is typically in "preview_url".
        snippet_url = tracks[0].get("preview_url")
        return snippet_url  # Might be None if the track has no preview