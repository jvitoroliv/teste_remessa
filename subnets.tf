//configuração da subnet e tabela de rotas e associação

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

//Definição das tabelas de rotas da VPC para o trafego roteável para internet
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

//Associação da tabela de rota à subnet
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.tf_subnet.id
  route_table_id = aws_route_table.route-table-env.id
}