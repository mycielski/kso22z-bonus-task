resource "aws_vpc" "default" {
  cidr_block           = "${var.ipv4_address}/${var.ipv4_mask}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-vpc"
  }
}
