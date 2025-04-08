# VPC
resource "aws_vpc" "terraform_lab1_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "terraform_lab1-vpc" }
}


# Public & Private Subnets using for_each loop
resource "aws_subnet" "terraform_lab1_subnets" {
  for_each = {
    "public1"  = { cidr_block = "10.0.1.0/24", az = "us-east-1a", type = "public" }
    "private1" = { cidr_block = "10.0.2.0/24", az = "us-east-1b", type = "private" }
    "private2" = { cidr_block = "10.0.3.0/24", az = "us-east-1c", type = "private" } 
    "public2"  = { cidr_block = "10.0.4.0/24", az = "us-east-1d", type = "public" } 
  }

  vpc_id                  = aws_vpc.terraform_lab1_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
 
 # to make public subnet
  map_public_ip_on_launch = each.value.type == "public" ? true : false

  tags = {
    Name = "terraform-lab1-${each.key}-subnet"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "terraform_lab1_igw" {
  vpc_id = aws_vpc.terraform_lab1_vpc.id
  tags   = { Name = "terraform_lab1-igw" }
}

# Public Route Table
resource "aws_route_table" "terraform_lab1_public_rt" {
  vpc_id = aws_vpc.terraform_lab1_vpc.id
  tags   = { Name = "terraform_lab1-public-rt" }
}

# Public Route 
resource "aws_route" "terraform_lab1_public_route" {
  route_table_id         = aws_route_table.terraform_lab1_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.terraform_lab1_igw.id
}

# Private Route Table
resource "aws_route_table" "terraform_lab1_private_rt" {
  vpc_id = aws_vpc.terraform_lab1_vpc.id
  tags   = { Name = "terraform_lab1-private-rt" }
}


# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "terraform_lab1_public_assoc" {
  for_each       = { for k, v in aws_subnet.terraform_lab1_subnets : k => v if v.map_public_ip_on_launch }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.terraform_lab1_public_rt.id
}


# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "terraform_lab1_private_assoc" {
  for_each       = { for k, v in aws_subnet.terraform_lab1_subnets : k => v if !v.map_public_ip_on_launch }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.terraform_lab1_private_rt.id
}


