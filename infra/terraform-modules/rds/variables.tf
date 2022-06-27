variable "db_pw_length" {
  type    = number
  default = 16
}
variable "rds_acess_sg_name" {
  type    = string
  default = "rds-access-tf"
}
variable "rds_acess_sg_ingress_port" {
  type    = number
  default = 3306
}
variable "vpc_id" {
  type = string
}
variable "subnet_group_name" {
  type    = string
  default = "private-group-tf"
}
variable "subnet_group_subnet_ids" {
  type = list(string)
}
variable "rds_db_allocated_storage" {
  type    = number
  default = 10
}
variable "rds_db_engine" {
  type    = string
  default = "mysql"
}
variable "rds_engine_version" {
  type    = string
  default = "5.7"
}
variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "rds_db_username" {
  type    = string
  default = "admin"
}
variable "rds_db_parameter_group_name" {
  type    = string
  default = "default.mysql5.7"
}
variable "rds_skip_final_snapshot" {
  type    = bool
  default = true
}

variable "rds_multi_az_enabled" {
  type    = bool
  default = true
}