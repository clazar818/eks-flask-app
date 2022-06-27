resource "random_password" "password" {
  length  = var.db_pw_length
  special = false
}

resource "aws_security_group" "sg1" {
  name   = var.rds_acess_sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.rds_acess_sg_ingress_port
    to_port     = var.rds_acess_sg_ingress_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}

resource "aws_db_subnet_group" "default" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_group_subnet_ids
}

# Create a database server
resource "aws_db_instance" "default" {
  allocated_storage      = var.rds_db_allocated_storage
  engine                 = var.rds_db_engine
  engine_version         = var.rds_engine_version
  instance_class         = var.rds_instance_class
  username               = var.rds_db_username
  parameter_group_name   = var.rds_db_parameter_group_name
  skip_final_snapshot    = var.rds_skip_final_snapshot
  password               = random_password.password.result
  vpc_security_group_ids = [aws_security_group.sg1.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  multi_az               = var.rds_multi_az_enabled
  db_name                = "main"
  # etc - aws_db_instance docs for more
}

output "db_password" { #terraform output -json to get value
  value     = random_password.password.result
  sensitive = true
}