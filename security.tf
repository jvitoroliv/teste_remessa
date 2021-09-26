//configuração do security group para acessos dos serviços/aplicações/instancias provisionados

resource "aws_security_group" "tf-sg" {
  vpc_id = aws_vpc.tf_vpc.id
  name   = "tf-sg"
  ingress = [
    {
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "Allow_ssh"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "Allow_all_ingress"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "Allow_all_egress"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = {
    name = "tf-sg"
  }
}

