import os, yaml, traceback


def get_config():
    if os.environ["FLASK_MODE"] == "local":
        config_file_name = os.getcwd() + "/config/local.yaml"
    elif os.environ["FLASK_MODE"] == "dev":
        config_file_name = os.getcwd() + "/config/dev.yaml"
    elif os.environ["FLASK_MODE"] == "stage":
        config_file_name = os.getcwd() + "/config/stage.yaml"
    elif os.environ["FLASK_MODE"] == "prod":
        config_file_name = os.getcwd() + "/config/prod.yaml"
    else:
        config_file_name = os.getcwd() + "/config/local.yaml"

    try:
        with open(config_file_name, 'r') as config_stream:
            cfg = yaml.load(config_stream, Loader=yaml.FullLoader)
            print(" * Environment configured")
            db_enabled = cfg['mongodb']['enabled']
            db_connection = cfg['mongodb']['connectionString']
            return {
                "db_enabled": db_enabled,
                "db_connection": db_connection
            }
    except:
        print("Exception while loading configuration yaml file")
        print(traceback.format_exc())
