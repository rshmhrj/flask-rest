#!/bin/bash
# Context type required [ local, gcp ]
# e.g.:
# bash ./scripts/one-time-use/set-contexts.sh local
# bash ./scripts/one-time-use/set-contexts.sh gcp

# Variables to set
appName=${PWD##*/}
clusterName=""
zoneName="us-west2-a"
projectName=""

COLOR='\033[0;36m' # Color for echo text
NC='\033[0m' # No Color

if [ $# -eq 0 ]; then
    echo -e ${COLOR} "Must provide context type [local, gcp]" ${NC}
    echo -e ${COLOR} "e.g. :" ${NC}
    echo -e ${COLOR} "bash ./scripts/one-time-use/set-contexts.sh local" ${NC}
    echo -e ${COLOR} "bash ./scripts/one-time-use/set-contexts.sh gcp" ${NC}
    exit 1
fi

if [ $1  ==  "local" ] ; then 
  minikube start
  kubectl create namespace $appName-local
  kubectl config set-context $appName-mk --namespace=$appName-local --cluster=minikube --user=minikube
  kubectl config use-context $appName-mk
fi

if [ $1  ==  "gcp" ] ; then 
  gcloud config set project $projectName
  gcloud container clusters get-credentials $clusterName --zone $zoneName --project $projectName
  kubectl create namespace $appName-dev
  kubectl config rename-context gke_$projectName_$zoneName_$clusterName $appName-gcp
fi