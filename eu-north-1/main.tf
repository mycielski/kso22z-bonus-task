provider "aws" {
  region  = "eu-north-1"
  profile = var.profile
}

module "vpc" {
  source       = "./modules/vpc"
  ipv4_address = var.vpc_ipv4_address
  ipv4_mask    = var.vpc_ipv4_mask
}

module "network" {
  source = "./modules/network"
  vpc_id = module.vpc.vpc_id
}

module "vm" {
  source    = "./modules/vm"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.network.subnet_id
}