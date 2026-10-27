# VPC and Internet Gateway configuration

# VPC definition
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "tf-vpc"
  }
}

# Internet Gateway — serves as the route target for public internet traffic
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "gw"
  }
}
