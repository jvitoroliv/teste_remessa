# Subnet, route table and route table association configuration

# Public subnet in us-east-2a
resource "aws_subnet" "tf_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.gw]

  tags = {
    Name = "tf-subnet"
  }
}

# Public subnet in us-east-2c
resource "aws_subnet" "tf_subnet2" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "172.16.20.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.gw]

  tags = {
    Name = "tf-subnet2"
  }
}

# Route table with a default route to the Internet Gateway
resource "aws_route_table" "route-table-env" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "env-route-table"
  }
}

# Route table association for subnet 1
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.tf_subnet.id
  route_table_id = aws_route_table.route-table-env.id
}

# Route table association for subnet 2
resource "aws_route_table_association" "subnet2-association" {
  subnet_id      = aws_subnet.tf_subnet2.id
  route_table_id = aws_route_table.route-table-env.id
}
