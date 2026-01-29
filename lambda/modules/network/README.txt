Network module will create the VPC, subnets (public, private), NAT gateway and security group for the Lambda function.

module "network" {
  source = "../../modules/network"

  region             = var.region
  environment        = var.environment
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.0.0/24"
  private_subnet_cidr= "10.0.1.0/24"
}