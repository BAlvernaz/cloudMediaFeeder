#!/usr/bin/env bash

source setupVariables.sh

if ! gcloud projects list | grep -q $projectId; then
    gcloud projects create $projectId
fi

gcloud config set project $projectId

