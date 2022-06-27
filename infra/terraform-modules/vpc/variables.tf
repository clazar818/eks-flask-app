variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
variable "private_subnet_a_cidr_block" {
  type    = string
  default = "10.0.0.0/19"
}
variable "private_subnet_b_cidr_block" {
  type    = string
  default = "10.0.32.0/19"
}
variable "public_subnet_a_cidr_block" {
  type    = string
  default = "10.0.64.0/19"
}
variable "public_subnet_b_cidr_block" {
  type    = string
  default = "10.0.96.0/19"
}