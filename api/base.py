import json
from bson import json_util

def root():
    output = {"status" : "success", "code" : 200, "message" : "Successfully fetched endpoint"}
    return json.loads(json_util.dumps(output))

def root_api():
    output = {"status" : "success", "code" : 200, "message" : "Successfully fetched endpoint"}
    return json.loads(json_util.dumps(output))

def not_found():
    output = {"status" : "error", "code" : 404, "message" : "Unable to fetch resource"}
    return json.loads(json_util.dumps(output))