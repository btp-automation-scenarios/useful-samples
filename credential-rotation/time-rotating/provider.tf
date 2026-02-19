terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.20.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

# Configure the BTP Provider
provider "btp" {
  globalaccount = var.globalaccount
}
