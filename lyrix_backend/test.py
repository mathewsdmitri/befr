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
        "username": "Shrek",
        "email": "isLove",
        "password": "Shrek",
        "bio": "",
        "access_token": ""
    }

    response = requests.post(url, json=user_data)
    print("Register User Response:", response.text)
    # Example assertion
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def test_login_user():
    """Log in the user and retrieve the session UUID."""
    url = f"{BASE_URL}/login"
    user_data = {
        "username": "Shrek",
        "email": "",
        "password": "Shrek",
        "bio": "",
        "access_token": ""
    }

    response = requests.post(url, json=user_data)
    print("Login Response Text:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

    # Parse the UUID from the response
    data = json.loads(response.text)
    uuid = data
    assert uuid, "No 'uuid' found in login response!"
    return uuid

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

def main():
    # 1. Register user
    test_register_user()

    # 2. Log in to retrieve UUID
    user_uuid = test_login_user()
    print("Extracted UUID:", user_uuid)

    # 3. Prompt user for Spotify Auth
    test_spotify_auth(user_uuid)

    # 4. Get recently played tracks
    recently_played = test_get_recently_played(user_uuid)
    print("Recently Played:", recently_played)

    print("\nAll test steps completed successfully.")

if __name__ == "__main__":
    main()
