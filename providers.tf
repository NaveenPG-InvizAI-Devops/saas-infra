
provider "google" {
  project = "gcp-demo-349307"
}

provider "google-beta" {
  project = "inviz-gcp"
}

terraform {
  required_version = ">= 0.13"
    backend "local" {
    path = "./terraform.tfstate"
  }
}  
