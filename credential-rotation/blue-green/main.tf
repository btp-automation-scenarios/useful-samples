resource "btp_subaccount" "my_project" {
  name      = "My Project for Blue Green Credential Rotation"
  subdomain = "my-project-cred-rotation-bg"
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
  name           = "my-auditlog-instance"
}

# Create the blue-green rotator which will rotate every minute
resource "rotating_blue_green" "rotator" {
  rotate_after_minutes = 1
  depends_on           = [btp_subaccount_service_instance.auditlog_default]
}

# Create the blue UUID
# The keepers argument ensures that a new UUID is generated when the blue-green rotator triggers a rotation by changing the value of `rotating_blue_green.rotator.blue_uuid`.
resource "random_uuid" "blue" {
  keepers = {
    uuid = rotating_blue_green.rotator.blue_uuid
  }
}

# Create the green UUID
# The keepers argument ensures that a new UUID is generated when the blue-green rotator triggers a rotation by changing the value of `rotating_blue_green.rotator.green_uuid`.
resource "random_uuid" "green" {
  keepers = {
    uuid = rotating_blue_green.rotator.green_uuid
  }
}

# Create the blue binding
resource "btp_subaccount_service_binding" "my_binding_blue" {
  subaccount_id       = btp_subaccount.my_project.id
  service_instance_id = btp_subaccount_service_instance.auditlog_default.id
  name                = "binding-blue-${random_uuid.blue.id}"
  lifecycle {
    replace_triggered_by = [random_uuid.blue]
  }
}

# Create the green binding
resource "btp_subaccount_service_binding" "my_binding_green" {
  subaccount_id       = btp_subaccount.my_project.id
  service_instance_id = btp_subaccount_service_instance.auditlog_default.id
  name                = "binding-green-${random_uuid.green.id}"
  lifecycle {
    replace_triggered_by = [random_uuid.green]
  }
}

locals {
  # Identify the active binding based on the blue-green rotator's state
  active_binding = jsondecode(rotating_blue_green.rotator.active == "blue" ? btp_subaccount_service_binding.my_binding_blue.credentials : btp_subaccount_service_binding.my_binding_green.credentials)
  # Transfer credential values to the destination configuration
  destination_configuration = {
    Name            = "My-HTTP-Destination-with-Rotation"
    Type            = "HTTP"
    clientId        = local.active_binding.uaa.clientid
    Description     = "My HTTP Destination with Rotation - ${rotating_blue_green.rotator.active}, rotate timestamp: ${rotating_blue_green.rotator.rotate_timestamp}"
    Authentication  = "OAuth2ClientCredentials"
    clientSecret    = local.active_binding.uaa.clientsecret
    tokenServiceURL = local.active_binding.uaa.url
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
