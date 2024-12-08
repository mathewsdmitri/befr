import os
from urllib.parse import urlencode
from fastapi import Request, HTTPException
import requests
from pymongo import MongoClient

def access_code_query(spotify_client_id, spotify_redirect_uri, uniqueID):
    redirect_params = {
        "client_id" : spotify_client_id,
        "response_type" : "code",
        "redirect_uri" : spotify_redirect_uri,
        "scope" : "user-read-recently-played",
        "state" : uniqueID
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

def get_access_token_with_uuid(uuid):
    myclient = MongoClient("mongodb://localhost:27017/")
    mydb = myclient["Users"]
    mycol = mydb["users"]

    x = mycol.find_one({"uuid": uuid})

    print(x["access_token"])
    return x["access_token"]

def post_access_token_to_database(access_token, uuid):

    # Connect to MongoDB
    client = MongoClient('mongodb://localhost:27017')
    db = client['Users']
    collection = db['users']

    # Insert a document
    document = {"access_token": access_token, "uuid": uuid}
    insert_result = collection.insert_one(document)
    print(f"Inserted document with ID: {insert_result.inserted_id}")


def post_song_to_database(uuid, songPost):

    # Connect to MongoDB
    client = MongoClient('mongodb://localhost:27017')
    db = client['Users']
    collection = db['Posts']

    # Insert a document
    document = {"post": songPost, "uuid": uuid}
    insert_result = collection.insert_one(document)
    print(f"Inserted document with ID: {insert_result.inserted_id}")
    # Read Documents

def get_song_posts():
    myclient = MongoClient("mongodb://localhost:27017/")
    mydb = myclient["Users"]
    mycol = mydb["Posts"]

    cursor = mycol.find()
    song_posts = []
    for document in cursor:
        song_posts.append({
            'uuid': document['uuid'],
            'post': document['post']
        })
    return song_posts
    # Update a document

    #query = {"name": "Alice"}
    #new_values = {"$set": {"age": 31}}
    #update_result = collection.update_one(query, new_values)
    #print(f"\nUpdated {update_result.modified_count} document(s)")