#!/usr/bin/env bash
set -o errexit

source ./env.sh

set -x

# Create a new project and link it to billing account
gcloud projects create ${TF_PROJECT} \
  --set-as-default

gcloud beta billing projects link ${TF_PROJECT} \
  --billing-account ${TF_VAR_billing_account}

# Create the service account and download the JSON credentials
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_PROJECT}.iam.gserviceaccount.com

# Grant terraform admin account editor on project
gcloud projects add-iam-policy-binding ${TF_PROJECT} \
  --member serviceAccount:terraform@${TF_PROJECT}.iam.gserviceaccount.com \
  --role roles/editor

# Enable API
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com

# Create bucket for state file
gsutil mb -p ${TF_PROJECT} gs://${TF_PROJECT}

set +x
cat > backend.tf <<EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_PROJECT}"
   prefix    = "terraform/state"
   project = "${TF_PROJECT}"
 }
}
EOF

set -x
# Set versioning on terraform state bucket
gsutil versioning set on gs://${TF_PROJECT}

# Init terraform and create resources
[ -d .terraform ] && rm -r .terraform

terraform init

terraform apply -auto-approve

set +x
terraform output | awk '/instance/ {print $1" ansible_host="$3}' > inventory

set -x
ansible --ssh-common-args='-o StrictHostKeyChecking=no' -m ping -i inventory all

ansible-playbook -i inventory provisioning/apache.yml
