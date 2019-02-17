from flask import Flask, render_template, request, redirect, make_response
import requests
import sqlite3
import pyrebase

config = {
    "apiKey": "AIzaSyCaY4mqwMRYMY9HdgBJ8yuo63SLDXtuE4c",
    "authDomain": "treehacks-247bf.firebaseapp.com",
    "databaseURL": "https://treehacks-247bf.firebaseio.com",
    "projectId": "treehacks-247bf",
    "storageBucket": "treehacks-247bf.appspot.com",
    "messagingSenderId": "1032236352208"
 }

firebase = pyrebase.initialize_app(config)
auth = firebase.auth()
user = "err"
db = firebase.database()

app = Flask(__name__)

base_url = 'treehacks-247bf.firebaseapp.com'

@app.route('/')
@app.route('/home')
def home():
	return render_template('home.html', coins=0)

@app.route('/sign-in')
def signin():
	user = auth.sign_in_with_email_and_password("germans@stanford.edu", "testing")
	print(user)
	return render_template('home.html', coins=0)

@app.route('/get-coins')
def getCoins(): 
	data = {"coins": 10}
	users = db.child("users").get()
	print(users)
	german = "trash"
	for user in users.each():
	    if user.key() == "ZI6CoYf06HeRH1izINg0mECeR4j1":
	    	german = user.val()
	print(german["numCoins"])
	return render_template('home.html', coins=german["numCoins"])

@app.route('/increment-coins')
def setCoins():
	data = {"coins": 10}
	users = db.child("users").get()
	print(users)
	german = "trash"
	for user in users.each():
	    if user.key() == "ZI6CoYf06HeRH1izINg0mECeR4j1":
	    	german = user.val()
	# set coins to be coins + 60 in database
	db.child("users").child("ZI6CoYf06HeRH1izINg0mECeR4j1").update({"numCoins": (german["numCoins"] + 60)})
	return render_template('home.html', coins=(german["numCoins"]))


# @app.route('/send-text')
# def sentText():


# @app.route('/get-quote')
# def quote():
# 	response = requests.get(base_url).json()
# 	return render_template('random_quote.html', quote=response)



# @app.route('/save-quote')
# def save():
# 	conn = sqlite3.connect('database.db')
# 	c = conn.cursor()
# 	quote = request.args.get('quote')
# 	author = request.args.get('author')
# 	c.execute('''insert into quotes values(null, "''' + request.cookies.get('username', default='null', type=str) + '''", "'''+ quote +'''", "'''+ author +'''")''')
# 	conn.commit()
# 	conn.close()
# 	return home()

if __name__ == '__main__':
	app.run(host="0.0.0.0")