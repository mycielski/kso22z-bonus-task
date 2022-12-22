output "vpc_id" {
  value = aws_vpc.default.id
}

output "vpc_cidr_block" {
  value = aws_vpc.default.cidr_block
}
