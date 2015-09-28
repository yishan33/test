#!/usr/bin/python

import MySQLdb
from flask import Flask, jsonify, request

app = Flask(__name__)


conn=MySQLdb.connect(host='localhost', user='lfs',passwd='lfs653',db='testDB',port=3306)
cur=conn.cursor()
count = cur.execute('select * from fruit')
info = cur.fetchmany(count)
cur.close()
conn.close()

tasks = [
	{
		'id': 1,
		'title': u'Buy groceries',
		'description': u'Milk, Cheese, Pizza, Fruit, Tylenol', 
		'done': False
	},
	{
		'id': 2,
		'title': u'Learn Python',
		'description': u'Need to find a good Python tutorial on the web', 
		'done': False
	}
]

#database login and out
def baseLogin():
	conn=MySQLdb.connect(host='localhost', user='lfs',passwd='lfs653',db='testDB',port=3306)
	cur=conn.cursor()
	return cur, conn
	
	
def baseLogout(cur, conn):
	cur.close()
	conn.commit()
	conn.close()
	
	
#database Operation
def delFruit(name):
	
	cur, conn = baseLogin()
	print 'question'
	count = cur.execute('delete from fruit where name = %s', name)
	info = cur.fetchmany(count)
	baseLogout(cur, conn)
	
def addFruit(name):
		
		cur, conn = baseLogin()
		print 'question'
		count = cur.execute('delete from fruit where name = %s', name)
		info = cur.fetchmany(count)
		baseLogout(cur, conn)
		

@app.route('/todo/api/v1.0/fruits', methods=['GET'])
def get_tasks():
	return jsonify({'fruit': dict(info)})

@app.route('/todo/api/v1.0/fruits/profile', methods=['GET'])
def get_profiles():
	profile = request.args.get('name')
	return profile



@app.route('/todo/api/v1.0/fruits/del_fruit', methods = ['GET'])
def del_fruit():
#	if request.method == 'POST' or request.method == 'GET':
	fruitname = request.args.get('name')
	print fruitname
	delFruit(fruitname)
	cur, conn = baseLogin()
	count = cur.execute('select * from fruit')
	info = cur.fetchmany(count)
	baseLogout(cur, conn)
	return jsonify({'fruit': dict(info)})
#	fruitName = request.args.get('name')
#	return fruitName
#	else :
#		return 'wrong method'

if __name__ == '__main__':
	app.run(debug=True, host = '0.0.0.0')
	
	

