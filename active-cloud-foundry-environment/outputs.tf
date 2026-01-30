//----------------------------------------------------
// Output the information
//----------------------------------------------------

# EU10 has several extension landscapes
output "active_environment_eu10" {
  value = terraform_data.active_env_label_eu10.input
}

# EU11 has no extension landscape
output "active_environment_eu11" {
  value = terraform_data.active_env_label_eu11.input
}

# EU20 has several extension landscapes
output "active_environment_eu20" {
  value = terraform_data.active_env_label_eu20.input
}
