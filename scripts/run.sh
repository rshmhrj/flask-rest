#!/bin/bash
# environment required [local, dev, stage, prod]
# e.g. bash ./scripts/run.sh dev

COLOR='\033[0;36m' # Color for echo text
NC='\033[0m' # No Color

if [ $# -eq 0 ]; then
    echo -e ${COLOR} "Must provide environment [local, dev, stage, prod]" ${NC}
    echo -e ${COLOR} "e.g. :" ${NC}
    echo -e ${COLOR} "bash ./scripts/run.sh local" ${NC}
    echo -e ${COLOR} "bash ./scripts/run.sh dev" ${NC}
    exit 1
fi

echo -e ${COLOR} "Sourcing venv" ${NC}
source ./venv/bin/activate
mode=$1
debug=0

if [ $mode == "prod" ]; then
    debug=0
else
    debug=1
fi

if [ $mode != "prod" ]; then
    reload=development
else
    reload=prod
fi


echo -e ${COLOR} "Exporting env values: FLASK_ENV=$1 FLASK_MODE=$reload FLASK_DEBUG=$debug" ${NC}
export FLASK_ENV=$1
export FLASK_MODE=$reload
export FLASK_DEBUG=$debug

echo -e ${COLOR} "Starting flask: flask run --host=0.0.0.0 --port=5001" ${NC}
flask run --host=0.0.0.0 --port=5001

echo -e ${COLOR} "fin" ${NC}
