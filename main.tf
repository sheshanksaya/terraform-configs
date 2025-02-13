terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.7"  # or the latest stable version
    }
  }
  required_version = ">= 1.0"
}

provider "mongodbatlas" {
  public_key  = var.public_key
  private_key = var.private_key
  
}

resource "mongodbatlas_project" "my_project" {
  name   = "DevOpsDemoProject"
  org_id = var.org_id
}

resource "mongodbatlas_cluster" "my_cluster" {
  project_id                  = mongodbatlas_project.my_project.id
  name                        = "DevOpsTestCluster"
  cluster_type                = "REPLICASET"
  
  provider_name               = "TENANT"
  backing_provider_name       = "AWS"
  provider_region_name        = "US_EAST_1"
  provider_instance_size_name = "M0"  # free tier
}
resource "mongodbatlas_project_ip_access_list" "allowed_ips" {
  project_id = mongodbatlas_project.my_project.id
  cidr_block = "108.211.107.41/32"
  comment    = "Allow all for testing (not recommended for production)!"
}


resource "mongodbatlas_database_user" "devops_user" {
  username           = "devops_testuser"
  password           = "ChangeMe"
  project_id         = mongodbatlas_project.my_project.id
  auth_database_name = "admin"
  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}

