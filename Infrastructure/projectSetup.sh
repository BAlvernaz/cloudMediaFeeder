#!/usr/bin/env bash

# Script File To Create the Google Cloud Project

source setupVariables.sh
 
 # Check if your Project exist if not Create New Project

if ! gcloud projects list | grep -q $projectId; then
    gcloud projects create $projectId
fi

# Check if Your Project is set in the config, If not set it to this Project

if ! gcloud config list | grep -q $projectId; then
    gcloud config set project $projectId
fi

# Check if Kubernetes api is Enabled, if not enable it

if ! gcloud services list --enabled | grep -q $kubeApi; then
    gcloud services enable $kubeApi
fi

# Checks if you have a Cluster, if not creates one

if ! gcloud container clusters list | grep  -q $clusterName; then 
gcloud beta container --project $projectId clusters create $clusterName --zone $myZone --no-enable-basic-auth --cluster-version "1.15.12-gke.20" --machine-type "g1-small" --image-type "COS" --disk-type "pd-standard" --disk-size "500" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-stackdriver-kubernetes --enable-ip-alias --network "projects/cloudmediafeeder/global/networks/default" --subnetwork "projects/cloudmediafeeder/regions/us-west1/subnetworks/default" --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0

fi

gcloud container clusters get-credentials $clusterName --zone=$myZone

kubectl apply -f ../sonarr.yaml