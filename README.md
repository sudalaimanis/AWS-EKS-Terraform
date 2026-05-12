# AWS EKS Terraform

## Purpose

This repository provisions a reusable AWS EKS infrastructure stack using Terraform. It is designed to create a standard VPC, security groups, and an EKS cluster in a modular way so you can reuse the components in different environments or extend the architecture for production use.

## Features

- Creates a VPC with public and private subnets
- Configures an Internet Gateway and NAT gateway for outbound connectivity
- Creates security groups for EKS control plane and worker nodes
- Deploys an EKS cluster with required IAM roles and node group support
- Uses Terraform modules to isolate reusable infrastructure components

## Reuse Guidance

This repository is built for reuse and modular deployment:

- `modules/vpc` contains the VPC foundation and can be reused for any AWS application requiring network infrastructure.
- `modules/security-groups` contains reusable security group configuration for cluster-level network access.
- `modules/eks` contains the EKS control plane and worker integration and can be reused when you need an AWS-managed Kubernetes cluster.
- The root module wires these pieces together and demonstrates one deployable configuration.

To reuse the modules separately, reference them from a different Terraform project using `source = "../path/to/modules/vpc"`, `source = "../path/to/modules/security-groups"`, and `source = "../path/to/modules/eks"`.

## Repository Structure

- `main.tf` - Root Terraform configuration that composes the VPC, security groups, and EKS modules.
- `variables.tf` - Root-level variables for region, environment, and project naming.
- `outputs.tf` - Root outputs for EKS cluster name, endpoint, and ARN.
- `modules/vpc` - VPC network foundation module.
- `modules/security-groups` - EKS security group module.
- `modules/eks` - EKS cluster module.
- `terraform.tfvars` - Variable overrides for local deployment.
- `providers.tf` - Provider configuration for AWS.
- `environments/` - Optional environment-specific configuration (if present).

## Usage

1. Install Terraform.
2. Set AWS credentials in your environment or `~/.aws/credentials`.
3. Initialize Terraform:

```bash
terraform init
```

4. Review the execution plan:

```bash
terraform plan
```

5. Apply the configuration:

```bash
terraform apply
```

6. Destroy when finished:

```bash
terraform destroy
```

## Configure kubectl Access

After the EKS cluster is deployed, configure your local kubectl to connect to the cluster:

```bash
aws eks update-kubeconfig --region us-east-1 --name my-cluster
```

Replace `us-east-1` with your region and `my-cluster` with your actual cluster name (output from `terraform apply`).

Verify the connection:

```bash
kubectl get nodes
```

## Inputs

Root module variables:

- `aws_region` - AWS region for deployment. Default: `us-east-1`
- `environment` - Deployment environment name (e.g. `dev`, `staging`, `prod`). Default: `dev`
- `project_name` - Base name used for resource naming. Default: `dumbledore-army-eks`

Module-specific inputs:

- VPC module: `vpc_cidr`, `vpc_name`, `environment`
- Security groups module: `vpc_id`, `environment`
- EKS module: `cluster_name`, `vpc_id`, `subnet_ids`, `security_group_ids`, `environment`

## Outputs

The root module exports:

- `eks_cluster_name` - Name of the created EKS cluster
- `eks_cluster_endpoint` - EKS API endpoint URL
- `eks_cluster_arn` - Amazon Resource Name (ARN) for the cluster

## Notes

- This repository is intended as a reusable AWS EKS Terraform starter.
- You can duplicate or reference the modules in another Terraform project for consistent infrastructure deployment.
- Adjust `terraform.tfvars` and module inputs for your organization’s naming, networking, and environment requirements.
