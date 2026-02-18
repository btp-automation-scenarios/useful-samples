resource "btp_subaccount" "my_project" {
  name      = "My Project for Credential Rotation"
  subdomain = "my-project-cred-rotation"
  region    = "us10"
}

data "btp_subaccount_service_plan" "auditlog_default" {
  subaccount_id = btp_subaccount.my_project.id
  offering_name = "auditlog-management"
  name          = "default"
}

resource "btp_subaccount_service_instance" "auditlog_default" {
  subaccount_id  = btp_subaccount.my_project.id
  serviceplan_id = data.btp_subaccount_service_plan.auditlog_default.id
  name           = "my-auditlog-instance-new"
}

# Create the time-based rotator which will rotate every minute
resource "time_rotating" "binding_rotation" {
  rotation_minutes = 1
  depends_on       = [btp_subaccount_service_instance.auditlog_default]
}

# Create the binding that will be rotated
resource "btp_subaccount_service_binding" "my_rotating_binding" {
  subaccount_id       = btp_subaccount.my_project.id
  service_instance_id = btp_subaccount_service_instance.auditlog_default.id
  name                = "rotated_binding_${time_rotating.binding_rotation.id}"
  lifecycle {
    replace_triggered_by = [time_rotating.binding_rotation.id]
  }
}

locals {
  # Transfer credential values to the destination configuration
  destination_configuration = {
    Name            = "My-HTTP-Destination-with-Rotation"
    Type            = "HTTP"
    clientId        = jsondecode(btp_subaccount_service_binding.my_rotating_binding.credentials).uaa.clientid
    Description     = "My HTTP Destination with Rotation, rotate timestamp: ${time_rotating.binding_rotation.id}"
    Authentication  = "OAuth2ClientCredentials"
    clientSecret    = jsondecode(btp_subaccount_service_binding.my_rotating_binding.credentials).uaa.clientsecret
    tokenServiceURL = jsondecode(btp_subaccount_service_binding.my_rotating_binding.credentials).uaa.url
    ProxyType       = "Internet"
    URL             = "https://localhost:12345"
  }
  # Create the JSON-string for the destination configuration
  destination_configuration_json = jsonencode(local.destination_configuration)
}

# Create the destination with the active credentials
resource "btp_subaccount_destination_generic" "subaccount_destination_metering_agent" {
  subaccount_id             = btp_subaccount.my_project.id
  destination_configuration = local.destination_configuration_json
}
