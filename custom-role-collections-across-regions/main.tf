//----------------------------------------------------
// Create subaccounts in different regions
//----------------------------------------------------
resource "btp_subaccount" "my_eu10_subaccount" {
  name      = "Test landscape Labels EU10"
  subdomain = "test-landscape-labels-eu10"
  region    = "eu10"
}

resource "btp_subaccount" "my_eu20_subaccount" {
  name      = "Test landscape Labels EU20"
  subdomain = "test-landscape-labels-eu20"
  region    = "eu20"
}


//----------------------------------------------------
// Based on the base role collections, fetch the app IDs for role templates
// => The magic happens in the module!
//----------------------------------------------------
module "roles_with_app_id_eu10" {
  source                = "./modules/role-app-id"
  subaccount_id         = btp_subaccount.my_eu10_subaccount.id
  base_role_collections = var.custom_role_collections
}

module "roles_with_app_id_eu20" {
  source                = "./modules/role-app-id"
  subaccount_id         = btp_subaccount.my_eu20_subaccount.id
  base_role_collections = var.custom_role_collections
}

//----------------------------------------------------
// Create custom role collections in each subaccount/region
//----------------------------------------------------
resource "btp_subaccount_role_collection" "eu10_collections" {
  for_each = module.roles_with_app_id_eu10.enhanced_role_collections

  subaccount_id = btp_subaccount.my_eu10_subaccount.id
  name          = each.key
  description   = "Custom role collection: ${each.key}"

  roles = [
    for role in each.value : {
      name                 = role.role_name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    }
  ]
}

resource "btp_subaccount_role_collection" "eu20_collections" {
  for_each = module.roles_with_app_id_eu20.enhanced_role_collections

  subaccount_id = btp_subaccount.my_eu20_subaccount.id
  name          = each.key
  description   = "Custom role collection: ${each.key}"

  roles = [
    for role in each.value : {
      name                 = role.role_name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    }
  ]
}
