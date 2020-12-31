#!/bin/bash
# e.g.:
# bash ./scripts/one-time-use/setup.sh

COLOR='\033[0;36m' # Color for echo text
NC='\033[0m' # No Color

echo -e ${COLOR} "Creating venv" ${NC}
python3 -m venv venv

echo -e ${COLOR} "Sourcing venv" ${NC}
source ./venv/bin/activate

echo -e ${COLOR} "Installing requirements" ${NC}
pip3 install -r requirements.txt

echo -e ${COLOR} "fin" ${NC}