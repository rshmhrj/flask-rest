# Flask REST API Template
## Overview
This is a simple project template for creating a REST API in Python running on Flask.
It was built off of the default PyCharm Flask project, but includes additional structure and configuration settings in-built.

## Requirements
`python3.7` and `pip`

On Mac:
```bash
brew install python
python3 --version
``` 

## Installation

```bash
bash ./scripts/one-time-use/setup.sh
```

or

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Project structure

```bash
.
├── Dockerfiles
│   └── Dockerfile
├── README.md
├── api
│   ├── __init__.py
│   ├── base.py
│   ├── config.py
│   ├── dbAccess.py
│   └── routes.py
├── app.py
├── config
│   ├── dev.yaml
│   ├── local.yaml
│   ├── prod.yaml
│   └── stage.yaml
├── k8s
│   ├── deployments
│   └── flask-rest-deploy.yaml
├── requirements.txt
├── scripts
│   ├── entrypoint.sh
│   ├── one-time-use
│   │   ├── set-contexts.sh
│   │   └── setup.sh
│   ├── run.sh
│   └── start.sh
├── static
│   └── favicon.ico
├── templates
└── venv
```

## Run project

### Run Locally

Run the build script with the environment you want to start [ local, dev, stage, prod ]

`bash ./scripts/run.sh`

### Run Docker Locally

Run the startDocker script with the environment you want to start [ local, dev, stage, prod ]

`bash ./scripts/start.sh docker local`

To stop, `docker ps` and copy the Container ID.  Then `docker stop <CONTAINER ID>`.

### Run Kubernetes Locally

Install minikube: `brew install minikube`

`bash ./scripts/start.sh k8s local`

or

```bash
minikube start

kubectl create namespace flask-rest-dev

kubectl config set-context flask-rest-mk --namespace=flask-rest-local \
  --cluster=minikube \
  --user=minikube

kubectl config use-context flask-rest-mk

```

To stop K8S and clean up:

```bash
kubectl delete deployment flask-rest-local
kubectl delete service flask-rest-local
minikube stop
```