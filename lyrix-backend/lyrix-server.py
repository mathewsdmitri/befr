from fastapi import FastAPI
from pydantic import BaseModel
from models.Users import User

app = FastAPI()

class UserSchema(BaseModel):
    username: str
    email: str
    password: str
    bio: str = ""

@app.post("/register_user")
async def register_user(user: UserSchema):
    user_instance = User(user.username, user.email, user.password, user.bio)
    return user_instance.register_user()
