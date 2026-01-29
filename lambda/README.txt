This repo sets up a scheduled Lambda function to automatically delete EC2 snapshots older than a specified age (default is 365)

## What It Provisions

- A secure VPC with public and private subnets
- IAM role and policies for Lambda
- A Lambda function that runs in a private subnet with NAT access
- A scheduled EventBridge rule to trigger the Lambda daily

## Tech stack used

- Terraform for infrastructure  
- AWS Lambda (Python 3) for snapshot cleanup logic  
- Modular Terraform architecture (network / lambda / schedule)  
- Multi‑environment support (dev, prod) via `envs/` directory

## Repository Structure

modules/
network/  # VPC, subnets, NAT gateway, security group
lambda_cleanup/ # Lambda function deployment
schedule/ # EventBridge rule

envs/
dev/  # Dev environment entry point
prod/ # Prod environment entry point

lambda_code/
lambda_function.py # Python cleanup logic

scripts/
package_lambda.sh  # Zips the Lambda code

##  Infrastructure-as-Code

## Prerequisites

- Install both Terraform and AWS CLI
- Run "aws configure" to set the credentials and region

### Deployment

# Clone the repository
git clone <repo-url>
cd envs/dev # or envs/prod

# Initialize Terraform
terraform init

# Plan with variables
terraform plan -var-file="terraform.tfvars" -out=tfplan

# Apply the plan
terraform apply tfplan

### Deploy the Lambda Code

'''bash
# Package the Python code
./scripts/package_lambda.sh

# Deploy Lambda (if code changes)
terraform apply -var-file="terraform.tfvars" -target=module.lambda_snapshot_cleanup
'''
## Scheduling

- Lambda is triggered through EventBridge rule
- we can customize the frequency using 'cron_schedule' in 'terraform.tfvars'


## Monitoring

- Logs are automatically pushed to CloudWatch Logs:
  '/aws/lambda/${var.environment}-snapshot-cleanup'
- Use CloudWatch Log Insights or set CloudWatch Alarms to monitor success/failures

## Architecture Diagram
The Architecture Daigram is attached in the root folder as "architecture_lambda function.jpeg