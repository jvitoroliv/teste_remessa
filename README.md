# AWS EKS Cluster with Nginx on Terraform

Automated provisioning of an Amazon EKS cluster with a containerized Nginx deployment, exposed via LoadBalancer and Ingress, fully managed through Terraform.

## Architecture

This stack provisions the following AWS and Kubernetes resources:

**AWS Infrastructure:**
- VPC (`172.16.0.0/16`) with DNS support enabled
- Two public subnets across separate availability zones (`us-east-2a`, `us-east-2c`)
- Internet Gateway with route table associations for both subnets
- Security group with SSH and broad ingress/egress rules

**EKS Cluster:**
- Amazon EKS `1.30` cluster using the [terraform-aws-modules/eks/aws](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws) module (`~> 20.0`)
- Managed node group with `t3.large` instances (1-3 nodes, auto-scaling)

**Kubernetes Resources:**
- Dedicated `remessa` namespace
- Nginx Deployment with resource limits (0.5 CPU / 512Mi memory)
- LoadBalancer Service exposing port 80
- Ingress resource routing HTTP traffic to the Nginx service

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.3
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with valid credentials
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- AWS IAM user/role with permissions to manage EKS, VPC, EC2, and IAM resources

## Usage

### 1. Clone and configure

```sh
git clone https://github.com/jvitoroliv/teste_remessa.git
cd teste_remessa
```

Review `variables.tf` and adjust defaults as needed (region, cluster name, AWS profile).

### 2. Initialize Terraform

```sh
terraform init
```

### 3. Review the execution plan

```sh
terraform plan
```

### 4. Apply the configuration

```sh
terraform apply
```

Type `yes` to confirm. The EKS cluster creation typically takes 10-15 minutes.

### 5. Configure kubectl

After the stack is created, update your kubeconfig to interact with the cluster:

```sh
aws eks --region us-east-2 update-kubeconfig --name teste_remessa
```

### 6. Access Nginx

The `load_balancer_hostname` output displays the LoadBalancer address. Wait approximately 2 minutes for DNS propagation, then open the hostname in a browser to see the Nginx welcome page.

```sh
terraform output load_balancer_hostname
```

### Destroying the stack

Before running `terraform destroy`, you must comment out the `depends_on` block in the `kubernetes_namespace` resource (`kubernetes.tf`). The EKS module must be destroyed before the namespace resource attempts cleanup, and the explicit dependency causes a circular reference during destruction.

```sh
# 1. Comment out depends_on in kubernetes_namespace.remessa (kubernetes.tf)
# 2. Then run:
terraform destroy
```

## Variables

| Name | Description | Default |
|------|-------------|---------|
| `region` | AWS region where resources will be created | `us-east-2` |
| `profile` | AWS CLI profile used for authentication | `default` |
| `cluster_name` | Name of the EKS cluster | `teste_remessa` |

## Outputs

| Name | Description |
|------|-------------|
| `load_balancer_hostname` | Hostname of the LoadBalancer exposing the Nginx service |

## Context

Built as a hiring assessment for Remessa Online (Bee Tech) demonstrating end-to-end EKS provisioning and Kubernetes resource management with Terraform. The assessment required automating the deployment of an Nginx container on EKS. Led to a final job offer.
