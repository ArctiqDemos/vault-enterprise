# Vault Enterprise Setup (Primary On-Prem & DR on GCP)

This repository provides an automated setup for Vault Enterprise using Puppet for configuration management and Terraform to provision infrastructure on GCP for the Disaster Recovery (DR) cluster.

## Prerequisites

- **Puppet:** Install Puppet on your on-prem VMs and GCP instances.
- **Terraform:** Install Terraform and authenticate with GCP.
- **GCP Credentials:** Ensure you have a service account with permissions to provision resources in GCP.

## Setup Instructions

### Step 1: Provision Infrastructure with Terraform

1. Navigate to the `terraform/` directory:

    ```bash
    cd terraform/
    ```

2. Create a `terraform.tfvars` file with the following content:

    ```hcl
    project            = "your-gcp-project-id"
    region             = "us-central1"
    credentials_file   = "/path/to/your/gcp/credentials.json"
    service_account_email = "your-service-account@gcp-project.iam.gserviceaccount.com"
    ```

3. Initialize and apply the Terraform configuration:

    ```bash
    terraform init
    terraform apply
    ```

4. Terraform will output the necessary public IP and networking details for your Vault DR cluster on GCP.

### Step 2: Configure Vault with Puppet

1. Apply Puppet manifests to set up Vault on both the on-prem and GCP DR instances.

    ```bash
    puppet apply puppet/manifests/init.pp
    ```

2. Puppet will configure Vault with Raft storage, including the correct systemd service setup for both clusters.

## Outputs

- `instance_public_ip`: The public IP address of the Vault instance on GCP.
- Vault will be up and running with Raft integrated storage across your on-prem and DR clusters.

## Troubleshooting

- Check the systemd service status on both instances:

    ```bash
    sudo systemctl status vault
    ```

- Ensure your firewall rules are allowing necessary traffic on ports `8200` and `8201`.
