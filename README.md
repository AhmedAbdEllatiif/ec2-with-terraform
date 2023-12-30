# Provision an EC2 with Terraform

This project provides instructions for provisioning an aws ec2 instance with the required infrastructure.

## Prerequisites
Before you proceed, make sure you have the following tools installed: 

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli): The Terraform command-line tool.
- [Configure AWS](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html): The 
AWS command-line tool.
_ [Get your current public ip](https://www.whatismyip.com/)

## Getting Started

Follow these steps:
1. **Create public Key Authenticationssh (if not exist in your local machine)**
   ```bash
    shh-keygen 
2. **Initialize Terraform**
   ```bash
    terraform init 
3. **Plan Terraform**
    ```bash
    terrform plan 
4. **Apply Terraform**
   ```bash
    terraform apply 
5. **Copy the  server public ip from your ternimal**
    ```bash
    shh ubuntu@<server-public-ip>

