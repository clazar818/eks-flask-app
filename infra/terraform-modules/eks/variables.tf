variable "aws_eks_cluster_name" {
  type    = string
  default = "demo"
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "ecr_repo_name" {
  type    = string
  default = "flask-app"
}

variable "ecr_image_tag_mutability" {
  type    = string
  default = "IMMUTABLE"
}
variable "ecr_image_scan_on_push" {
  type    = bool
  default = true
}

variable "subnet_id_a" {
  type = string
}
variable "subnet_id_b" {
  type = string
}