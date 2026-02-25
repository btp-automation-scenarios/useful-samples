variable "globalaccount" {
  type        = string
  description = "Subdomain of the global account"
}

variable "subaccount_id" {
  type        = string
  description = "ID of the subaccount where the environment instance will be created"
}

variable "cf_env_instance_name" {
  type        = string
  description = "Name of the Cloud Foundry environment instance"
}

variable "landscape_label" {
  type        = string
  description = "Landscape label of the Cloud Foundry environment instance"
}

variable "memory_amount" {
  type        = number
  description = "Amount of memory to be assigned in MB for the Cloud Foundry environment instance entitlement"
}
