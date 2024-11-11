from flask import Flask,render_template, url_for, request, session, redirect
from pymongo import MongoClient
import bcrypt
import os
currdir = os.getcwd()
print(currdir)

app = Flask(__name__, templates = 'templates' )

client = MongoClient('localhost', 27017)

#Mongo Database
db = client.flask_database

@app.route("/")
def index():
    if 'username' in session:
        return 'You are logged in as ' + session ['username']
        
    return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():
    users = db.users
    username = request.form['username']
    password = request.form['pass']

    # Debugging print to see what username is being looked up
    print("Attempting to find user:", username)

    login_user = users.find_one({'name': username})

    if login_user:
        print("User found in database:", login_user)
        stored_password = login_user['password']
        
        # Checking password match
        if bcrypt.hashpw(password.encode('utf-8'), stored_password) == stored_password:
            session['username'] = username
            return redirect(url_for('index'))
        else:
            return 'Invalid username/password combination'
    
    print("User not found with username:", username)
    return 'User not found'

@app.route('/register', methods = ['GET', 'POST']) #Grab data and submit data
def register():
    if request.method =='POST':
        users = db.users #//////
        existing_users = users.find_one({'name' : request.form['username']})
    
        if existing_users is None:
            hashpass = bcrypt.hashpw(request.form['pass'].encode('utf-8'), bcrypt.gensalt())
            users.insert_one({'name' : request.form['username'], 'password' : hashpass})
            session['username'] = request.form['username']
            return redirect(url_for('index'))

        return 'Username already exists'

    return render_template('register.html')

if __name__ == "__main__":
        app.secret_key = 'mysecret'
        app.run(debug=True)

        