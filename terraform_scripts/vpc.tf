module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.15.0" # Or later version

  name           = "test_ecs_provisioning"
  cidr           = "10.0.0.0/16"
  azs            = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  tags = {
    "env"       = "dev"
    "createdBy" = "Sahitya_Gupta"
  }
}
