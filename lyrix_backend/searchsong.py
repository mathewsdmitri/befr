import os
from dotenv import load_dotenv
from SpotifyAPIClient import SpotifyAPIClient  # or wherever your class is located
from models.Users import uuid_to_user
def main():
    load_dotenv()  # if you keep credentials in a .env file (optional)

    SPOTIFY_CLIENT_ID = os.getenv("CLIENT_ID")
    SPOTIFY_CLIENT_SECRET = os.getenv("CLIENT_SECRET")
    SPOTIFY_REDIRECT_URI = os.getenv("REDIRECT_URI")

    spotify_client  = SpotifyAPIClient(client_id=SPOTIFY_CLIENT_ID, client_secret= SPOTIFY_CLIENT_SECRET, redirect_uri= SPOTIFY_REDIRECT_URI)
    # Instantiate the client
    # In a real app, you'd either:
    #   1) Perform the OAuth flow to obtain an access token, or
    #   2) Prompt the user to input an existing token.
    # For this demo, let's just ask for it:
    access_token = uuid_to_user("d810c6b9-c804-4ad7-b1b4-9a3966fa2b80").access_token

    # Prompt user for the track name
    track_name = input("Enter the song title to search for: ").strip()

    # Perform the search
    snippet_url = spotify_client.search_track(access_token, track_name)

    if snippet_url:
        print(f"\nFound a preview URL for '{track_name}':\n{snippet_url}\n")
    else:
        print(f"\nNo snippet available for '{track_name}' or track not found.\n")

if __name__ == "__main__":
    main()
