import os
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

application = Flask(__name__)

application.config.from_object(os.environ['APP_SETTINGS'])
application.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(application)
migrate = Migrate(application, db)

from models import Client

#Index
@application.route("/")
def index():
    return "This is the application index"

#Add client and money
@application.route("/add")
def add_client():
    name=request.args.get('name')
    money=request.args.get('money')
    try:
        client=Client(
            name=name,
            money=money
        )
        db.session.add(client)
        db.session.commit()
        return "Client added with id={}".format(client.id)
    except Exception as e:
	    return(str(e))

#Get all clients
@application.route("/getall")
def get_all():
    try:
        clients=Client.query.all()
        return  jsonify([e.serialize() for e in clients])
    except Exception as e:
	    return(str(e))

#Get client by ID
@application.route("/get/<id_>")
def get_by_id(id_):
    try:
        client=Client.query.filter_by(id=id_).first()
        return jsonify(client.serialize())
    except Exception as e:
	    return(str(e))

#Get client by Name
@application.route("/getn/<name_>")
def get_by_name(name_):
    try:
        client=Client.query.filter_by(name=name_).first()
        return jsonify(client.serialize())
    except Exception as e:
	    return(str(e))

if __name__ == '__main__':
    application.run()
