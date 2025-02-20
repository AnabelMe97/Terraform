module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name    = "vpc-${var.project_name}"
  cidr    = "192.168.0.0/24"

  azs             = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  private_subnets = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  public_subnets  = ["192.168.100.0/24", "192.168.101.0/24", "192.168.101.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "Dev_user02"
  }
}