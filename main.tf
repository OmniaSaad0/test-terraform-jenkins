module "network" {
  source       = "./modules/network"
  project_name = "terraform_lab1"
  vpc_cidr     = "10.0.0.0/16"

  subnets = {
    "public1"  = { cidr_block = "10.0.1.0/24", availability_zone = "us-east-1a", type = "public" }
    "public2"  = { cidr_block = "10.0.4.0/24", availability_zone = "us-east-1d", type = "public" }
    "private1" = { cidr_block = "10.0.2.0/24", availability_zone = "us-east-1b", type = "private" }
    "private2" = { cidr_block = "10.0.3.0/24", availability_zone = "us-east-1c", type = "private" }
  }
}
