module "rds" {
  source = "../../terraform-modules/rds"

  ### VPC ID and using private subnets for security best practices ###
  vpc_id                   = "enter the VPC ID from the VPC that you created"
  subnet_group_subnet_ids = ["enter private subnet id from az-a here", "enter private subnet id from az-b here"]

  ### Example
  #vpc_id                  = "vpc-0b5c36a37ab89eed0"
  #subnet_group_subnet_ids = ["subnet-01dd48ccbfc86c79a", "subnet-0fbd92774a5c45480"]
}

output "db_password" { # terraform output -json to get value
  value     = module.rds.db_password
  sensitive = true
}