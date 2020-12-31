import json
from api import app
from bson import json_util
from flask_cors import CORS
from pymongo import MongoClient

CORS(app)

class DbAccess():
    def __init__(self, db_connection):
        self.client = MongoClient(db_connection)
        self.db = self.client.test
        self.summary = self.db.test

    def __repr__(self):
        return super().__repr__()

    def getSummary(self):
        summary = self.summary.find({}).sort("recordDate", -1).limit(1)
        output = {
            "status" : "success",
            "code" : 200,
            "message" : "Successfully fetched data from db",
            "dataType" : "Summary List",
            "length" : 1,
            "data": list(summary)
        }
        return json.loads(json_util.dumps(output))
