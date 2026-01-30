//----------------------------------------------------
// We fetch all roles in the subaccount to get their app IDs
//----------------------------------------------------
data "btp_subaccount_roles" "all" {
  subaccount_id = var.subaccount_id
}

//----------------------------------------------------
// We iterate over the base role collections and enhance them with app IDs fetched above
// We use the Terraform Function one() to ensure we get a single app_id for each role
// one() will throw an error if there are multiple matches
// one() will return null if there are no matches -> we validate this in the output precondition
//----------------------------------------------------
locals {
  enhanced_role_collection = {
    for collection_name, roles in var.base_role_collections : collection_name => [
      for role in roles : {
        role_template_name = role.role_template_name
        role_name          = role.role_name
        app_id = one([
          for r in data.btp_subaccount_roles.all.values : r.app_id if r.role_template_name == role.role_template_name && r.name == role.role_name
        ])
      }
    ]
  }
}
