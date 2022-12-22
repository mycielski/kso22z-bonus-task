data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_vpc" "default" {
  id = var.vpc_id
}

resource "aws_subnet" "default" {
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(data.aws_vpc.default.cidr_block, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "terraform-subnet"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = var.vpc_id
}

resource "aws_route_table" "default" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "default" {
  subnet_id      = aws_subnet.default.id
  route_table_id = aws_route_table.default.id
}
