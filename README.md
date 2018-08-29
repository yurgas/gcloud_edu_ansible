# Description:
It's a sample project for studying Google Cloud automation, not for production use.
It uses Terraform to create 3 ubuntu instances, internal and external load
balancers, and configures VM instances by running simple ansible playbook.

## Main statements:
1. Ubuntu 16.04 image for VMs
2. Use Terraform to create all resources in Google Cloud
3. Create new project in account and use one of billing accounts (tested on trial)
4. Create Internal load balancer and standalone VM for making tests
5. Create External load balancer (proxy), disabled by default (extension .off)
6. Use ssh keys on path $HOME/.ssh/id_rsa.pub for accessing VMs
7. Create ssh keys for authentication on VM in a scale set
8. Ansible playbook used to provision VMs to run apache2

# Installation:
1. Execute `./start.sh`
2. Connect to WordPress using url endpoint from the output and complete installation
3. Execute `terraform output` to get endpoints

# Clearing:
1. Execute `./delete.sh` to remove sample project from account
