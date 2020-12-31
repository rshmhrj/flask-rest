#!/bin/bash
# deployment required [docker, k8s]
# environment required [local, dev, stage, prod]
# e.g. bash ./scripts/start.sh k8s dev
# e.g. bash ./scripts/start.sh docker local

# Variables to edit
appName=${PWD##*/}
df="./Dockerfiles/Dockerfile"
registryLocation="registry.gitlab.com/igbc-lc/templates/$appName"

COLOR='\033[0;36m' # Color for echo text
NC='\033[0m' # No Color

if [ $# -eq 0 ]; then
    echo -e ${COLOR} "Must provide deployment [docker, k8s] and environment [local, dev, stage, prod]" ${NC}
    echo -e ${COLOR} "e.g. :" ${NC}
    echo -e ${COLOR} "bash ./scripts/start.sh k8s dev" ${NC}
    echo -e ${COLOR} "bash ./scripts/start.sh docker local" ${NC}
    exit 1
fi

if [ $# -eq 1 ]; then
    echo -e ${COLOR} "Must provide environment [local, dev, stage, prod]" ${NC}
    echo -e ${COLOR} "e.g. :" ${NC}
    echo -e ${COLOR} "bash ./scripts/start.sh k8s dev" ${NC}
    echo -e ${COLOR} "bash ./scripts/start.sh docker local" ${NC}
    exit 1
fi

deploymentType=$1
mode=$2
debug=0

echo -e ${COLOR} "Deployment = $deploymentType" ${NC}
echo -e ${COLOR} "Environment = $mode" ${NC}

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

flaskEnv=$2
flaskMode=$reload
flaskDebug=$debug
echo -e ${COLOR} "Container env values: FLASK_ENV=$flaskEnv FLASK_MODE=$flaskMode FLASK_DEBUG=$flaskDebug" ${NC}

dt=$(date '+%Y%m%d-%H.%M.%S');
echo -e ${COLOR} "$dt" ${NC}

app="$appName-$flaskEnv"
appTag=$app:$dt
echo -e ${COLOR} $appTag ${NC}

containerImage=$registryLocation/$appTag

echo -e ${COLOR} "Building and tagging docker image" ${NC}
echo -e ${COLOR} "docker build --no-cache -f $df -t $appTag -t $app:latest -t $containerImage ." ${NC}

docker build --no-cache -f $df -t $appTag -t $app:latest -t $containerImage .

if [ $flaskEnv != "local" ]; then
  echo -e ${COLOR} "Pushing docker image to registry" ${NC}
  docker push $containerImage
fi

if [ $deploymentType == "docker" ]; then
  echo -e ${COLOR} "Auto-running docker image" ${NC}
  echo -e ${COLOR} "docker run -d --rm -i -t \
    -e FLASK_ENV=$flaskEnv -e FLASK_MODE=$flaskMode -e FLASK_DEBUG=$flaskDebug \
    -p 5001:5001 --name=$app $appTag" ${NC}
  docker run -d --rm -i -t \
    -e FLASK_ENV=$flaskEnv -e FLASK_MODE=$flaskMode -e FLASK_DEBUG=$flaskDebug \
    -p 5001:5001 --name=$app $appTag
fi

if [ $deploymentType == "k8s" ]; then

    if [ $flaskEnv == "local" ]; then
      echo -e ${COLOR} "Updating deploy yaml with image, mode, and env values - LOCAL" ${NC}
      cat ./k8s/$appName-deploy.yaml | sed "s/FLASK_ENV_VALUE/$flaskEnv/; s/FLASK_MODE_VALUE/$flaskMode/; s/ENVIRONMENT/$flaskEnv/; s#CONTAINER_IMAGE#$appTag#; s/FLASK_DEBUG_VALUE/$flaskDebug/" > ./k8s/deployments/$app-deploy-$dt.yaml
      echo "vi ./k8s/deployments/$app-deploy-$dt.yaml"
      echo "kubectl apply -f ./k8s/deployments/$app-deploy-$dt.yaml"

      echo -e ${COLOR} "Applying deploy changes in local cluster" ${NC}
      minikube cache add $appTag $appTag
      kubectl config use-context $appName-mk
    else
      echo -e ${COLOR} "Updating deploy yaml with image, mode, and env values - CLOUD" ${NC}
      cat ./k8s/$appName-deploy.yaml | sed "s/FLASK_ENV_VALUE/$flaskEnv/; s/FLASK_MODE_VALUE/$flaskMode/; s/ENVIRONMENT/$flaskEnv/; s#CONTAINER_IMAGE#$containerImage#; s/FLASK_DEBUG_VALUE/$flaskDebug/" > ./k8s/deployments/$app-deploy-$dt.yaml
      echo "vi ./k8s/deployments/$app-deploy-$dt.yaml"
      echo "kubectl apply -f ./k8s/deployments/$app-deploy-$dt.yaml"

      echo -e ${COLOR} "Applying deploy changes in GCP cluster" ${NC}
      kubectl config use-context $appName-gcp
    fi

    kubectl apply -f ./k8s/deployments/$app-deploy-$dt.yaml
    kubectl get pods --namespace=$app

    echo -e ${COLOR} "Checking rollout status" ${NC}
    # if ! kubectl rollout status deployment $app -n $app; then
    #     kubectl rollout undo deployment $app -n $app
    #     kubectl rollout status deployment $app -n $app
    #     exit 1
    # fi

    if [ $flaskEnv == "local" ]; then
      echo -e ${COLOR} "Exposing local deployment and starting minikube service" ${NC}
      kubectl expose deployment $app --type=LoadBalancer --port=5001 --namespace=$app
      minikube service -n $app --url $app
    fi
fi
echo -e ${COLOR} "fin" ${NC}




