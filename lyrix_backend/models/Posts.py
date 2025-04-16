import uuid
from pydantic import BaseModel, EmailStr, ValidationError
from datetime import datetime
from pymongo import MongoClient



client = MongoClient("mongodb://localhost:27017/") #Connect to Mongodb locally (Change if connecting to Atlas)
db = client["Users"] # Connect to the Users database
posts_collection = db["posts"] #Connect to the posts collection


class PostModel(BaseModel):
    username: str
    post_id: str
    content: str # Still need to refine this
    album_url: str
    track_name: str
    artist_name: str
    timestamp: datetime = datetime.utcnow() # Still need to refine this
    likes: list
    comments: list[dict]


#Helper model for receiving unique ID and posts
class InitPost(BaseModel):
    username: str
    content: str # Still need to refine this
    album_url: str
    track_name: str
    artist_name: str
    uniqueId: str


class Post:
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

    def __init__(self, username: str, content, track_name, artist_name, album_url=""): # Add a unique post ID
        self.post_id = str(uuid.uuid4()) # Will generate a random 36 character long string
        self.username = username
        self.content = content
        self.timestamp = datetime.now()
        self.album_url = album_url
        self.track_name = track_name
        self.artist_name = artist_name
        self.likes = []
        self.comments = []


    def create_post(self):
        """ Adds a new post to the database. """

        
        
        # Create a dictionary with the posts information
        post_data = {
            "post_id": self.post_id,
            "username": self.username,
            "content": self.content,
            "comments": self.comments,
            "album_url": self.album_url,
            "track_name": self.track_name,
            "artist_name": self.artist_name,
            "likes": self.likes,
            "date_created": self.timestamp          
        }
        # Add the dictionary with the posts information into the database

        posts_collection.insert_one(post_data)

        return {"message": "Post was made successfully!"}


def find_user_posts(username: str):
    """ Finds a post in the database if it exists. """

    list_posts = list(posts_collection.find_one({"username": username}))

    if list_posts:
        return list_posts

    else:
        return {"message": "No posts found!"}
        
def delete_post(self, username: str):
    post = posts_collection.find_one({"post_id": self.post_id})
    if post:
        posts_collection.delete_one({"_id": self.post_id})
        return {"message": "Post deleted!"}

    else:
        return {"message": "Post not found!"}
        
def like_post(post_id:str, username: str):
    """ Adds a like from the post. """

    post = posts_collection.find_one({"post_id": post_id})

    if not post:
        return {"error": "Post not found"}
    
    if username in post.get("likes", []):
        return {"message": "User already liked this post!"}

    posts_collection.update_one({"post_id": post_id}, {"$push": {"likes": username}})
    return {"message": "Post liked!"}


def unlike_post (post_id: str, username: str):
    """removes a like from the post. """
    post = posts_collection.find_one({"post_id": post_id})

    if not post:
        return {"error": "Post not found"}

    if username not in post.get("likes", []):
        return {"message": "Post hasn't been liked yet"}
        
        
    posts_collection.update_one({"post_id": post_id}, {"$pull": {"likes": username}})
    
    return {"message": "User has unliked this post!"}

def add_comment (post_id: str, username: str, comment_text: str):
    
    post = posts_collection.find_one({"post_id": post_id})

    if not post:
        return {"error": "Post not found"}

    comment_data = {
       "comment_id": str(uuid.uuid4()), # Generate a unique ID for the comment
        "username": username,
        "comment": comment_text,
        "timestamp": datetime.now().isoformat()
    }

    posts_collection.update_one({"post_id": post_id}, {"$push": {"comments": comment_data}})

    return {"message": "Comment added!"}
    
def delete_comment (post_id: str, username: str, comment_id: str):
    
    post = posts_collection.find_one({"post_id": post_id})

    if not post:
        return {"error": "Post not found"}

    comments = post.get("comments", [])
    comment_obj = next((c for c in comments if c["comment_id"] == comment_id), None)

    if not comment_obj:
        return {"error": "Comment not found"}
    
    is_comment_author = (comment_obj["username"] == username)
    is_post_author = (post["username"] == username)

    if not (is_comment_author or is_post_author):
        return {"error": "You do not have permission to delete this comment."}

    posts_collection.update_one({"post_id": post_id}, {"$pull": {"comments": {"comment_id": comment_id}}})

    return {"message": "Comment deleted!"}
          


    