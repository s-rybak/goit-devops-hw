# Головний файл для підключення модулів Terraform.
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
    helm = { 
      source = "hashicorp/helm", 
      version = "~> 2.0" 
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "goithw"
}

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.eks.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
#     token                  = data.aws_eks_cluster_auth.eks.token
#   }
# }

# data "aws_eks_cluster" "eks" {
#   name = module.eks.eks_cluster_name
# }

# data "aws_eks_cluster_auth" "eks" {
#   name = module.eks.eks_cluster_name
# }

# resource "helm_release" "django_app" {
#   name       = "django-app"
#   chart      = "./charts/django-app"
#   namespace  = "default"

#   set {
#     name  = "image.repository"
#     value = module.ecr.ecr_repository_url
#   }
  
#   set {
#     name  = "image.tag"
#     value = "latest"
#   }

#   depends_on = [module.eks]
# }

# Підключаємо модуль S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "terraform-state-bucket-goithw-rybak"
  table_name  = "terraform-locks"
}

# Підключаємо модуль VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-east-1a","us-east-1b","us-east-1c"]
  vpc_name           = "lesson-5-vpc"
}

#Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-5-ecr"
  scan_on_push = true
}

#Підключаємо модуль EKS
module "eks" {
  source          = "./modules/eks"          
  cluster_name    = "eks-cluster-demo"            # Назва кластера
  subnet_ids      = module.vpc.public_subnets     # ID підмереж
  instance_type   = "t3.small"                    # Тип інстансів
  desired_size    = 1                             # Бажана кількість нодів
  max_size        = 2                             # Максимальна кількість нодів
  min_size        = 1                             # Мінімальна кількість нодів
}