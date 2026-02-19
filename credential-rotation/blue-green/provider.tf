terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
    rotating = {
      source  = "apollorion/rotating"
      version = "1.0.0"
    }
  }
}

# Configure the BTP Provider
provider "btp" {
  globalaccount = var.globalaccount
}
