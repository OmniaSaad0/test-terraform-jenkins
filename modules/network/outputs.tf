output "vpc_id" {
  value = aws_vpc.terraform_lab1_vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.terraform_lab1_vpc.cidr_block
}

output "subnet_ids" {
  value = { for s, v in aws_subnet.terraform_lab1_subnets : s => v.id }
}

output "private_subnet_ids" {
  value = { for k, v in aws_subnet.terraform_lab1_subnets : k => v.id if v.map_public_ip_on_launch == false }
}
