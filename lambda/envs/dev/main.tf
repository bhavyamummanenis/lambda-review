module "network" {
  source             = "../../modules/network"
  region             = var.region
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  private_subnet_cidr= var.private_subnet_cidr
}

module "lambda_snapshot_cleanup" {
  source            = "../../modules/lambda"
  region            = var.region
  environment       = var.environment
  subnet_ids        = [ module.network.private_subnet_id ]
  security_group_ids= [ module.network.lambda_sg_id ]
  age_days          = var.age_days
  deployment_package= "../../scripts/deployment_package.zip"
}

module "schedule_snapshot_cleanup" {
  source        = "../../modules/schedule"
  environment   = var.environment
  lambda_arn    = module.lambda_snapshot_cleanup.function_arn
  cron_schedule = var.cron_schedule
}

output "lambda_function_name" {
  value = module.lambda_snapshot_cleanup.function_name
}