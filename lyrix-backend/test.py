import requests

url = 'http://127.0.0.1:8000/register_user'
user_data = {
    "username": "Shrek",
    "email": "isLove",
    "password": "Shrek",
    "bio": "isLife"
}

response = requests.post(url, json=user_data)

print(response.text)
