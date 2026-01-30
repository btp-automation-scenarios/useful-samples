variable "subaccount_id" {
  type        = string
  description = "The ID of the subaccount where the role collections should be fetched from."
}


variable "base_role_collections" {
  type = map(list(object({
    role_template_name = string
    role_name          = string
  })))
  description = "Map of role names and role template names"
}
