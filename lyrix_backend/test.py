import requests
import json
import os
from dotenv import load_dotenv
from urllib.parse import urlencode
# If needed, import 'spotify_client' from your local file:
# from SpotifyAPIClient import spotify_client

load_dotenv()

BASE_URL = "http://127.0.0.1:8000"

BASE_URL = "http://127.0.0.1:8000"
DEBUG = os.getenv("DEBUG", "false").lower() == "true"

def test_register_user():
    """Register a new user."""
    url = f"{BASE_URL}/register_user"
    user_data1 = {
        "username": "mathewsdmitri",
        "email": "mathewsdmitri@gmail.com",
        "password": "mathews",
        "bio": "",
        "access_token": "",
        "refresh_token": "",
    }
    user_data2 = {
        "username": "Shrek",
        "email": "shrek@",
        "password": "shrek",
        "bio": "",
        "access_token": "",
        "refresh_token": "",
    }
    user_data3 = {
        "username": "Donkey",
        "email": "donkey@",
        "password": "rodger",
        "bio": "",
        "access_token": "",
        "refresh_token": "",
    }

    response = requests.post(url, json=user_data1)
    print("Register User 1 Response:", response.text)
    # Example assertion
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

    response = requests.post(url, json=user_data2)
    print("Register User 2 Response:", response.text)
    # Example assertion
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

    response = requests.post(url, json=user_data3)
    print("Register User 3 Response:", response.text)
    # Example assertion
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def test_login_user():
    """Log in the user and retrieve the session UUID."""
    url = f"{BASE_URL}/login"
    user_data = {
        "username": "Shrek",
        "email": "",
        "password": "shrek",
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

def test_logout_user(uuid: str):
    url = f"{BASE_URL}/logout"
    data = {"uuid": uuid}
    response = requests.post(url, json=data)
    print("Logout Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

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

def test_create_post(username:str, uuid:str):
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

def delete_post_test():
    url = f"{BASE_URL}/delete_post"
    data = {
        "post_id": "32d92938-f092-42cb-b491-1f3ea7cd8d3e",  # must exist in DB
        "username": "Rodger"                                # must be post owner
    }
    response = requests.delete(url, json=data)
    print("Delete Post Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def test_follow_user(follower_user:str, user_account:str):
    url = f"{BASE_URL}/follow"
    data = {
            "follower_user": follower_user,      # The user who is following
            "user_account": user_account       # The user being followed
        }
    response = requests.post(url, json=data)
    print("Follow Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def test_unfollow_user(follower_user:str, user_account:str):
    url = f"{BASE_URL}/unfollow"
    data = {
        "follower_user": follower_user,      # The user who is unfollowing
        "user_account": user_account       # The user being unfollowed
    }
    response = requests.post(url, json=data)
    print("Unfollow Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def like_post():
    url = f"{BASE_URL}/like"
    data = {
            "post_id": "32d92938-f092-42cb-b491-1f3ea7cd8d3e",      #post ID 
            "username": "Shrek"  # The user who is liking
        }
    response = requests.post(url, json=data)
    print("Like Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def unlike_post():
   
    url = f"{BASE_URL}/unlike"
    data = {
        "post_id": "32d92938-f092-42cb-b491-1f3ea7cd8d3e",      #post ID 
        "username": "Shrek"      # The user who is unliking
    }
    response = requests.post(url, json=data)
    print("Unlike Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def add_comment():
   
    url = f"{BASE_URL}/add_comment"
    data = {
        "post_id": "32d92938-f092-42cb-b491-1f3ea7cd8d3e",      #post ID 
        "username": "Donkey",      # The user who is commenting
        "comment_text" : "So cool!"  # The comment text
    }
    response = requests.post(url, json=data)
    print("Comment Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def delete_comment():
   
    url = f"{BASE_URL}/delete_comment"
    data = {
        "post_id": "32d92938-f092-42cb-b491-1f3ea7cd8d3e",      #post ID 
        "username": "Rodger",      # Post owner or comment owner
        "comment_id" : "b95d5362-346d-4702-8802-d5a4525e02ab"  # The comment id
    }
    response = requests.post(url, json=data)
    print("Comment Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def delete_account():
    url = f"{BASE_URL}/delete_account"
    data = {
        "username": "Donkey",       # The account to delete
        "requesting_user": "Donkey" # Must match
    }
    response = requests.delete(url, json=data)
    print("Delete Account Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def search_users():
    url = f"{BASE_URL}/search_users"
    params = {"query": "mos"}
    
    response = requests.get(url, params=params)
    print("Search Users Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def change_password():
    url = f"{BASE_URL}/change_password"
    data = {
        "username": "Shrek",
        "new_password": "superSecret123"
    }
    response = requests.post(url, json=data)
    print("Change Password Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def request_reset(identifier: str) -> str:
    """Call /password_reset/request and return raw token if DEBUG; else skip."""
    resp = requests.post(f"{BASE_URL}/password_reset/request",
                         json={"identifier": identifier})
    print("Reset‑request response:", resp.text)
    resp.raise_for_status()
    data = resp.json()

    if not DEBUG:
        print(f"⚠️  No raw token returned (DEBUG={DEBUG}).")
        print("   Skipping validate & confirm steps—you’ll need to grab the link from your email and test manually.")
        return None

    # DEBUG=true → token is returned in dev mode
    token = data.get("token")
    if not token:
        raise AssertionError("DEBUG must be true to get raw token in response")
    return token


def confirm_reset(raw_token: str, new_pwd: str):
    """Call /password_reset/confirm"""
    resp = requests.post(f"{BASE_URL}/password_reset/confirm",
                         json={"token": raw_token, "new_password": new_pwd})
    print("Reset‑confirm response:", resp.text)
    resp.raise_for_status()

def validate_reset(raw_token: str):
    """Call /password_reset/validate"""
    resp = requests.get(f"{BASE_URL}/password_reset/validate", params={"token": raw_token})
    print("Validate‑token response:", resp.text)
    resp.raise_for_status()
    assert resp.json().get("valid") is True

def test_full_password_reset_flow():
    username = " " #enter username
    new_pwd  = " " #enter new password

    # 1) request reset link
    raw_token = request_reset(username)
    if raw_token is None:
        return  # DEBUG=false: we skip the rest

    # 2) validate (user clicked the link)
    validate_reset(raw_token)

    # 3) confirm (user submitted new password)
    confirm_reset(raw_token, new_pwd)

    # 4) log in with new pwd
    login_url = f"{BASE_URL}/login"
    resp = requests.post(login_url, json={
        "username": username,
        "email": "",
        "password": new_pwd,
        "bio": "",
        "access_token": "",
        "refresh_token": ""
    })
    print("Login with new pwd:", resp.text)
    resp.raise_for_status()
    print("✅ Full password‑reset flow succeeded.")

def test_get_following_posts(user):
    url = f"{BASE_URL}/getFollowingPost?username={user}"
 
    response = requests.get(url)
    print("Following Post Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"

def test_update_profile_picture(user:str, profile_picture:str):
    url = f"{BASE_URL}/updateProfilePic"
    data = {
        "email": "",
        "username": user,
        "profile_picture": profile_picture,
        "bio": ""
    }
    response = requests.post(url, json=data)
    print("Update Profile Picture Response:", response.text)
    assert response.status_code == 200, f"Expected 200, got {response.status_code}"
def main():

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

    # 5. Test follow/unfollow
    test_follow_user("Rodger", "Shrek")
    test_unfollow_user("Rodger", "Shrek")

    # 6. Test create/delete post
    test_create_post(username=logged_user['username'], uuid=logged_user['uuid'])
    delete_post_test()
    test_create_post(username=logged_user['username'], uuid=logged_user['uuid'])
    # 7. Test like/unlike
    like_post()
    unlike_post()

    # 8. Test add/delete comment
    add_comment()
    delete_comment()

    # 9. Test logout
    test_logout_user(logged_user['uuid'])

    #10. test_delete_account()
    #elete_account()

    #11. test search_user()
    search_users()

    #12 test change_password()
    #change_password()

    #13 test password reset flow
    #test_full_password_reset_flow()

    #14 Test listing user following posts
    test_follow_user(follower_user="mosquito prime", user_account="Shrek")
    test_follow_user(follower_user="mosquito prime", user_account="mosquito prime")
    test_get_following_posts("Shrek")
    print("\nForgot‑password flow succeeded.")
    test_update_profile_picture(user="Shrek",
                                profile_picture="https://static.wikia.nocookie.net/universalstudios/images/f/f2/Shrek2-disneyscreencaps.com-4369.jpg/revision/latest?cb=20250224023204")
    print("\nAll test steps completed successfully.")

if __name__ == "__main__":
    main()
