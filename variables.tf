//Configuração das variáveis utilizadas pelos modulos do terraform
variable "region" {
  description = "Define em qual região a instancia será criada"
  default     = "us-east-2"
}

variable "credentials" {
  description = "local das credenciais utilizadas para acessar a aws"
  default     = "/home/{USER}/.aws/credentials"
}

variable "profile" {
  description = "Profile de acesso utilizado para acessar a aws"
  default     = "default"
}

variable "cluster_name" {
  description = "Nome do cluster a ser criado na aws"
  default     = "teste_remessa"
}