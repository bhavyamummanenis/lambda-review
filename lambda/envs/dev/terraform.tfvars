## randomly given
region      = "us‑east‑1"
environment = "dev"

vpc_cidr             = "10.20.0.0/16"
public_subnet_cidr   = "10.20.1.0/24"
private_subnet_cidr  = "10.20.2.0/24"
age_days             = 180                      # delete snapshots older than 180 days
cron_schedule        = "cron(0 2 * * ? *)"      # run daily at 2 AM UTC
memory_size          = 256                      # bump memory for better performance
timeout              = 60                       # allow up to 60 seconds for execution

