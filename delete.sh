#!/usr/bin/env bash

source ./env.sh

set -x
gcloud projects delete ${TF_PROJECT}
