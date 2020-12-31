from api import app, base, config
from api.dbAccess import DbAccess
from flask import request, send_from_directory
import os
from flask_cors import CORS

CORS(app)

## Get config info
## Connect to database

cfg = config.get_config()
if cfg["db_enabled"]:
    db = DbAccess(cfg["db_connection"])

## Root routes
@app.route('/', methods=['GET'])
def root():
    return base.root()

@app.route('/api', methods=['GET'])
def root_api():
    return base.root_api()

@app.route('/favicon.ico', methods=['GET'])
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'), 'favicon.ico', mimetype='image/vnd.microsoft.icon')

@app.errorhandler(404)
def not_found(self):
    return base.not_found()

## Add additional routes below
