//----------------------------------------------------
// Create the environment instance for Cloud Foundry
//----------------------------------------------------
resource "btp_subaccount_environment_instance" "cf_runtime_prod" {
  environment_type = "cloudfoundry"
  landscape_label  = var.landscape_label
  name             = var.cf_env_instance_name
  parameters = jsonencode(
    {
      instance_name = var.cf_env_instance_name
    }
  )
  plan_name     = "standard"
  service_name  = "cloudfoundry"
  subaccount_id = var.subaccount_id
}

//----------------------------------------------------
// Create the entitlement for `APPLICATION_RUNTIME` and `MEMORY` depending on the environment instance resource
//----------------------------------------------------
resource "btp_subaccount_entitlement" "application_runtime_memory_prod" {
  amount        = var.memory_amount
  plan_name     = "MEMORY"
  service_name  = "APPLICATION_RUNTIME"
  subaccount_id = var.subaccount_id
  depends_on    = [btp_subaccount_environment_instance.cf_runtime_prod]
}
