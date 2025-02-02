import requests
from urllib.parse import urlencode
url = 'http://127.0.0.1:8000/register_user'
user_data = {
    "username": "Shrek",
    "email": "isLove",
    "password": "Shrek",
    "bio": "isLife"
}

response = requests.post(url, json=user_data)

print(response.text)
data = "1233451234"
url = f"http://127.0.0.1:8000/spotifyAuth?uniqueID={data}"
response = requests.get(url=url)
data = response.text
print(data)