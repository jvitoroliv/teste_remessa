# teste_remessa
Desafio proposto pela remessa para instanciar um container nginx no eks de forma automatizada via terraform.
Antes da utilização desta automação é necessário atender alguns requisitos.
São eles:
0 - Esta automação foi desenvolvida utilizando uma máquina com sistema operacional linux, logo o passo a passo e todos os comandos serão baseados na utilização através do linux.

1 - Possuir uma conta na aws, caso não possua, é possível criar através do link abaixo:
https://www.google.com/aclk?sa=L&ai=DChcSEwjq8_Pm7PLyAhUICJEKHTysBLAYABABGgJjZQ&sig=AOD64_14ANiCTAajp1T9x2hSYceo7EzdSA&q&adurl&ved=2ahUKEwiL1Orm7PLyAhXpq5UCHYBOCDwQ0Qx6BAgDEAE

2 - Criar uma conta no IAM para obter as credenciais:
https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_users_create.html
Obs: Foi utilizado um usuário com permissões de administrador para essa automação, necessário
ficar atento pois caso as permissões sejam diferentes, podem ocorrer problemas.

3 - Possuir as credenciais devidamente configuradas na máquina:
https://docs.aws.amazon.com/pt_br/rekognition/latest/dg/setup-awscli-sdk.html
Vale a pena conferir também a instalação do AWS CLI
https://docs.aws.amazon.com/pt_br/cli/latest/userguide/install-cliv2-linux.html

4 - Ter o terraform instalado na máquina
https://learn.hashicorp.com/tutorials/terraform/install-cli

Para utilizar a automação, é necessário realizar o clone local deste repositório.

Após realizar o clone siga os passo abaixo:

1. Abra o arquivo variables.tf
1.1. Este arquivo é onde se encontram todas as váriaveis utilizadas nos módulos do terraform.
1.2. É necessário modificar a variável credentials indicando o local onde estão as credenciais para acesso a aws.

2. Execute o comando "$terraform init" para instalar os módulos e as dependencias do terraform e deixa-lo pronto para execução.

3. Execute o comando terraform plan para verificar se está tudo pronto para utilizar o terraform.

4. Execute o terraform Apply e digite yes para executar o terraform.

5. Após a construção o terraform irá indicar um output com o "hostname" do loadbalancer.
Aguarde alguns minutos (aproximadamente 2 minutos)
e cole o endereço no navegador para acessar a pagina principal do nginx instanciada no container criado.
5.1. É importante salientar que a saida acontecerá no seguinte formato:
Apply complete! Resources: 35 added, 0 changed, 0 destroyed.

Outputs:

load_balancer_hostname = tolist([
  {
    "load_balancer" = tolist([
      {
        "ingress" = tolist([
          {
            "hostname" = "Endereço_esperado.us-east-2.elb.amazonaws.com"
            "ip" = ""
          },
        ])
      },
    ])
  },
])

O valor que deve ser utilizado no navegador para acessar o nginx é o valor entre aspas após "hostname" =

Obs: Para executar o comando terraform destroy, é necessário acessar o arquivo kubernetes.tf e comentar o 
depends_on contido no resource "kubernetes_namespace" "remessa" que aguarda o module.eks ser criado.


