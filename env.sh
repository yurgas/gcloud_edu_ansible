##!/usr/bin/env bash

export TF_VAR_billing_account=$(gcloud beta billing accounts list |tail -n 1 |awk '{print $1}')
export TF_PROJECT=${USER}-terraform-ansible
export TF_CREDS=~/.config/gcloud/terraform-admin.json

# Set env variables for GCP
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_PROJECT=${TF_PROJECT}

# Set env variables for terraform
export TF_VAR_project_name=${TF_PROJECT}
export TF_VAR_region=us-central1

export TF_VAR_gce_ssh_user=${USER}
export TF_VAR_gce_ssh_pub_key_file=${HOME}/.ssh/id_rsa.pub
