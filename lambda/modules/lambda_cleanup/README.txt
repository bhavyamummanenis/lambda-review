This module will Deploy the snapshot‑cleanup Lambda function within the VPC, with the appropriate IAM Role and policy.

module "lambda_snapshot_cleanup" {
  source            = "../../modules/lambda"
  region            = var.region
  environment       = var.environment
  subnet_ids        = [ module.network.private_subnet_id ]
  security_group_ids= [ module.network.lambda_sg_id ]
  age_days          = 365
  deployment_package= "../../scripts/deployment_package.zip"
}