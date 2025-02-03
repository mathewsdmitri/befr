import requests
from urllib.parse import urlencode

#user is registering account to webapp
url = 'http://127.0.0.1:8000/register_user'
user_data = {
    "username": "Shrek",
    "email": "isLove",
    "password": "Shrek",
    "bio": "isLife"
}

response = requests.post(url, json=user_data)

#Here is what frontend recevies
print(response.text)


#User is logging into web app 
user_data = {
    "username": "Shrek",
    "email": "",
    "password": "Shrek",
    "bio": ""
}

url = "http://127.0.0.1:8000/login"
response = requests.get(url,json=user_data)
#Frontend receives a session id (uuid) and is now able to be logged into account
print(response.text)


#User is linking their spotify account to webappp
data = "1233451234"
url = f"http://127.0.0.1:8000/spotifyAuth?uniqueID={data}"
response = requests.get(url=url)
data = response.text

print(data)
