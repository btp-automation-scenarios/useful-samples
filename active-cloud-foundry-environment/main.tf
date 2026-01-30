//----------------------------------------------------
// Create Subaccounts in different regions
//----------------------------------------------------
resource "btp_subaccount" "my_eu10_subaccount" {
  name      = "Test landscape Labels EU10"
  subdomain = "test-landscape-labels-eu10"
  region    = "eu10"
}

resource "btp_subaccount" "my_eu11_subaccount" {
  name      = "Test landscape Labels EU11"
  subdomain = "test-landscape-labels-eu11"
  region    = "eu11"
}

resource "btp_subaccount" "my_eu20_subaccount" {
  name      = "Test landscape Labels EU20"
  subdomain = "test-landscape-labels-eu20"
  region    = "eu20"
}

//----------------------------------------------------
// Fetch environment information for each subaccount
//----------------------------------------------------
data "btp_subaccount_environments" "env_info_eu10" {
  subaccount_id = btp_subaccount.my_eu10_subaccount.id
}

data "btp_subaccount_environments" "env_info_eu11" {
  subaccount_id = btp_subaccount.my_eu11_subaccount.id
}

data "btp_subaccount_environments" "env_info_eu20" {
  subaccount_id = btp_subaccount.my_eu20_subaccount.id
}

//----------------------------------------------------
// Store active environment landscape labels
//----------------------------------------------------
resource "terraform_data" "active_env_label_eu10" {
  input = [for env in data.btp_subaccount_environments.env_info_eu10.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry" && env.availability_level == "ACTIVE"][0].landscape_label
}

resource "terraform_data" "active_env_label_eu11" {
  input = [for env in data.btp_subaccount_environments.env_info_eu11.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry" && env.availability_level == "ACTIVE"][0].landscape_label
}

resource "terraform_data" "active_env_label_eu20" {
  input = [for env in data.btp_subaccount_environments.env_info_eu20.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry" && env.availability_level == "ACTIVE"][0].landscape_label
}
