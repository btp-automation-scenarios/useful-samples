output "enhanced_role_collections" {
  description = "Role Collections with app_ids of subaccount"
  value       = local.enhanced_role_collection

  // Precondition to ensure all roles have valid app_ids
  precondition {
    condition = alltrue([
      for collection_name, roles in local.enhanced_role_collection : alltrue([
        for role in roles : role.app_id != null && role.app_id != ""
      ])
    ])
    error_message = "All roles must have a non-null and non-empty app_id. Check that all role_template_name and role_name combinations exist in the subaccount."
  }
}
