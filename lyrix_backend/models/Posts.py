import uuid
from pydantic import BaseModel, EmailStr, ValidationError
from datetime import datetime
from pymongo import MongoClient



client = MongoClient("mongodb://localhost:27017/") #Connect to Mongodb locally (Change if connecting to Atlas)
db = client["Users"] # Connect to the Users database
posts_collection = db["posts"] #Connect to the posts collection


class PostModel(BaseModel):
    user_id: str
    content: None # Still need to refine this
    timestamp: datetime = datetime.utcnow() # Still need to refine this
    likes: list[dict] = []
    comments: list[dict] = []





class Post():
    """
        A class to represent a post.

        Attributes:
            Post ID (str): The posts unique ID
            User ID (str): The users ID to link to the post
            Timestamp (str): When the post was made
            Likes (int): The amount of likes the post has
            Comments(list): List of comments for the post
            Content : The content of the post that is made
    
    """

    def __init__(self, user_id: str, content,): # Add a unique post ID
        self.post_id = str(uuid.uuid4()) # Will generate a random 36 character long string
        self.user_id = user_id
        self.content = content
        self.timestamp = datetime.now()
        self.likes = []
        self.comments = []


    def create_post(self):
        """ Adds a new post to the database. """
        
        
        # Create a dictionary with the posts information
        post_data = {
            "post_id": self.post_id,
            "user_id": self.user_id,
            "content": self.content,
            "comments": self.comments,
            "likes": self.likes,
            "date_created": self.timestamp          
        }

        # Add the dictionary with the posts information into the database

        posts_collection.insert_one(post_data)

        return {"message": "Post was made successfully!"}


    def find_post(user_id: str):
        """ Finds a post in the database if it exists. """

        list_posts = list(posts_collection.find_one({"username": user_id}))

        if list_posts:
            return list_posts

        else:
            return {"message": "No posts found!"}
        
    def delete_post(self, user_id: str):
        post = posts_collection.find_one({"post_id": self.post_id})
        if post:
            posts_collection.delete_one({"_id": self.post_id})
            return {"message": "Post deleted!"}
    
        else:
            return {"message": "Post not found!"}
        
    def like_post(self, user_id: str):
        """ Adds a like from the post. """

        post = posts_collection.find_one({"post_id": self.post_id})

        if post:
            if user_id in post["likes"]:
                return {"message": "User already liked this post!"}

            posts_collection.update_one({"_id": self.post_id}, {"$push": {"likes": user_id}})
            return {"message": "Post liked!"}

        return {"error": "Post not found"}
    
    def unlike_post (self, user_id: str):
        """removes a like from the post. """
        post = posts_collection.find_one({"post_id": self.post_id})
        if post:
            if user_id in post ["likes"]:
                posts_collection.update_one({"post_id": self.post_id}, {"$pull": {"likes": user_id}})
                return {"message": "User has unliked this post!"}
        
        
            return {"message": "Post hasn't been liked yet"}

        return {"error": "Post not found"}
        


    