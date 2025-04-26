# AWS EKS and VPC Terraform Project

This project provisions an AWS Elastic Kubernetes Service (EKS) cluster and Virtual Private Cloud (VPC) infrastructure using Terraform. It leverages reusable Terraform modules for EKS and VPC to simplify deployment and management.

## Project Structure

```table
├── eks.tf                 # EKS cluster configuration
├── vpc.tf                 # VPC configuration
├── security_grp.tf        # Security group definitions
├── variables.tf           # Input variables for the project
├── outputs.tf             # Output values for the project
├── terraform.tfvars       # Variable values for the project
├── terraform.tfstate      # Terraform state file
├── .terraform/            # Terraform modules and provider cache
├── .gitignore             # Git ignore file
└── .terraform.lock.hcl    # Terraform provider lock file
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS CLI configured with appropriate credentials
- An S3 bucket and DynamoDB table for remote state management (optional but recommended)

## Usage

1. **Initialize Terraform**:

   ```bash
   terraform init
   ```

2. **Plan the Infrastructure**:

   ```bash
   terraform plan
   ```

3. **Apply the Configuration**:

   ```bash
   terraform apply
   ```

4. **Destroy the Infrastructure** (when no longer needed):

   ```bash
   terraform destroy
   ```

## Modules Used

### VPC Module

The VPC module is sourced from the [AWS VPC Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-vpc). It creates a VPC with public and private subnets, NAT gateways, and other networking resources.

### EKS Module

The EKS module is sourced from the [AWS EKS Terraform Module](https://github.com/terraform-aws-modules/terraform-aws-eks). It provisions an EKS cluster with managed node groups and optional Fargate profiles.

## Inputs

The project uses the following input variables defined in `variables.tf`:

| Name                  | Description                                | Type   | Default       |
|-----------------------|--------------------------------------------|--------|---------------|
| `region`              | AWS region to deploy resources            | string | `"us-east-1"` |
| `vpc_cidr`            | CIDR block for the VPC                    | string | `"10.0.0.0/16"` |
| `eks_cluster_name`    | Name of the EKS cluster                   | string | `"my-cluster"` |
| `node_instance_types` | Instance types for EKS worker nodes       | list   | `["t3.medium"]` |

## Outputs

The project provides the following outputs defined in `outputs.tf`:

| Name                  | Description                                |
|-----------------------|--------------------------------------------|
| `vpc_id`              | ID of the created VPC                     |
| `eks_cluster_arn`     | ARN of the EKS cluster                    |
| `eks_cluster_endpoint`| Endpoint for the Kubernetes API server    |

## Examples

### Deploying the EKS Cluster

To deploy the EKS cluster with default settings:

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.eks_cluster_name
  cluster_version = "1.31"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
}
```

### Creating a VPC

To create a VPC with public and private subnets:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name            = "my-vpc"
  cidr            = var.vpc_cidr
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
```

## Best Practices

- Use remote state management with an S3 bucket and DynamoDB table to enable collaboration.
- Enable version control for your Terraform configuration files.
- Regularly update Terraform and module versions to benefit from the latest features and fixes.

## License

This project is licensed under the [Apache 2.0 License](LICENSE).

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Authors

This project is maintained by Yan.

Feel free to customize this README.md to better fit your specific project details.
