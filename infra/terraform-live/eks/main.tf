module "eks" {
  source = "../../terraform-modules/eks"

  ### Private Subnets For Our Node Group : ###
  subnet_id_a = "enter private subnet id from az-a here"
  subnet_id_b = "enter private subnet id from az-b here"

  # Example:
  #subnet_id_a = "subnet-01dd48ccbfc86c79a"
  #subnet_id_b = "subnet-0fbd92774a5c45480"
}
