import requests
import json
import os
from dotenv import load_dotenv
from urllib.parse import urlencode
# If needed, import 'spotify_client' from your local file:
# from SpotifyAPIClient import spotify_client

load_dotenv()

BASE_URL = "http://127.0.0.1:8000"

def test_register_user():
    """Register a new user."""
    url = f"{BASE_URL}/register_user"
    user_data = {
        "username": "Steve",
        "email": "steveisLove@",
        "password": "steve",
        "bio": "",
        "access_token": "",
        "refresh_token": "",
    }

    response = requests.post(url, json=user_data)
    print("Register User Response:", response.text)
    # Example assertion
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def test_login_user():
    """Log in the user and retrieve the session UUID."""
    url = f"{BASE_URL}/login"
    user_data = {
        "username": "Steve",
        "email": "",
        "password": "steve",
        "bio": "",
        "access_token": "",
        "refresh_token": "",
    }

    response = requests.post(url, json=user_data)
    print("Login Response Text:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

    # Parse the UUID from the response
    data = json.loads(response.text)
    assert data, "No data found in login response!"
    return data

def test_spotify_auth(uuid: str):
    """
    Instruct the user to manually open the /spotifyAuth endpoint in their browser
    (simulating an OAuth flow), then wait for them to come back to the terminal.
    """
    # 1. Print the URL so the user can open it manually in a browser
    auth_url = f"{BASE_URL}/spotifyAuth?uniqueID={uuid}"
    print("\n----------------------------------------------------------")
    print("SPOTIFY AUTH STEP:")
    print(f"Please open this URL in your browser to authenticate or if response says that access token exists then api call is good and access token is already in database")
    response = requests.get(auth_url)
    print(response.text)
    print("----------------------------------------------------------\n")
    print("SpotifyAuth (confirmation) Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"
    # 2. Wait for the user to finish
    input("After completing the browser-based Spotify authorization, close the browser window/tab and press ENTER here to continue...")
    


def test_get_recently_played(uuid: str):
    """Call getRecentlyPlayed using the existing UUID."""
    url = f"{BASE_URL}/getRecentlyPlayed?uuid={uuid}"
    response = requests.get(url)
    print("getRecentlyPlayed Response:", response.text)

    assert response.status_code == 200, f"Expected 200, got {response.status_code}"
    return response.text

def test_create_post(uuid:str, username:str):
    url = f"{BASE_URL}/post"
    post_data = {
        "username": username,
        "content": "This song gets me pumped!", # Still need to refine this
        "album_url": "https://images.genius.com/1b3a29b3ea00ab2c45a1831ede4dad49.500x500x1.jpg",
        "track_name": "If I Could Hold Your Soul",
        "artist_name": "Cities Aviv",
        "uniqueId": uuid
    }
    response = requests.post(url, json=post_data)
    print("Post Response:", response.text)
    # Example assertion
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def main():
    # 0. Create Post


    # 1. Register user
    test_register_user()

    # 2. Log in to retrieve UUID
    logged_user = test_login_user()
    print("Extracted UUID:", logged_user['uuid'])

    # 3. Prompt user for Spotify Auth
    test_spotify_auth(logged_user['uuid'])

    # 4. Get recently played tracks
    recently_played = test_get_recently_played(logged_user['uuid'])
    print("Recently Played:", recently_played)

    test_create_post(username=logged_user['username'], uuid=logged_user['uuid'])
    print("\nAll test steps completed successfully.")

if __name__ == "__main__":
    main()
