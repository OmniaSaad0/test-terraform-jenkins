variable "project_name" {
  description = "Project name to tag resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnets" {
  description = "Map of public and private subnets"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    type              = string  
  }))
}

