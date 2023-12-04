# Project 01 - DevOps AWS - Creating an Architecture  using Terraform
![aws-ecs drawio (3)](https://github.com/rashiddaha/01_devops-aws-terraform-ecs/assets/51082957/769189b5-edbe-4d81-bdb1-985dfe07b92b)

Welcome to Project 01 in the DevOps AWS series! In this project, we'll create a robust Architecture Diagram  using Terraform. The goal is to build essential AWS resources like S3, RDS, ECR, ECS, load balancers, security groups, and VPCs to facilitate a seamless deployment process.

## Infrastructure Overview
The infrastructure for this project involves setting up an environment to support a Django backend application. It includes creating AWS services such as S3 for storage, RDS for the database, ECR for container images, ECS for container orchestration, load balancers for traffic distribution, security groups for network security, and VPCs for isolation.

### Step 01: Obtain Certificate ARN, CNAME Name, and CNAME Value

1. Run the script `pre_requisite/get-certificate` to create a certificate.
    - Update the region name in this script and provide your domain name.
    - It will print the domain ARN and CNAME record; save these for later use.
  
2. Create an AWS S3 bucket and upload/copy the 'pre_requisite/production.django-backend.env' file.
    - Run the Python script `pre_requisite/script.py`.
    - Update values in `script.py`, such as the S3 bucket name and region.
    - Execute the script to obtain the S3 bucket's ARN and the object URL of the env file; save these for later use.

## Step 02: Update Terraform Configuration

1. Update the `variables.tf` file created earlier.
    - Update the ARN, domain name, account ID, and the ARN of the env file obtained in previous steps.

### Step 03: Validate, Plan, Apply, and Test

1. Validate the Terraform configuration to ensure correctness: `terraform validate`.
2. Plan the changes to be applied: `terraform plan`.
    - Review the proposed changes and ensure they align with expectations.
3. Apply the changes to create the AWS resources: `terraform apply`.
    - Verify the resources are provisioned as expected.

4. Optionally, for testing purposes, consider running: `terraform destroy` to clean up the resources created.

Ensure appropriate permissions and access are configured in your AWS account to execute these steps successfully.

Keep in mind to replace placeholders like `<placeholder>` with actual values in your scripts and configuration files.

Good luck with  Architecture using  Terraform on AWS! If you encounter issues, refer to AWS and Terraform documentation for detailed guidance.
