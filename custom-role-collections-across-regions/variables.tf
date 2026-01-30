variable "globalaccount" {
  type        = string
  description = "Subdomain of the global account"
}

variable "custom_role_collections" {
  type = map(list(object({
    role_template_name = string
    role_name          = string
  })))
  default = {
    "custom-subaccount-admin" = [{
      role_template_name = "Subaccount_Admin"
      role_name          = "Subaccount Admin"
      },
      {
        role_template_name = "Subaccount_Service_Administrator"
        role_name          = "Subaccount Service Administrator"
      },
      {
        role_template_name = "xsuaa_admin"
        role_name          = "User and Role Administrator"
      },
    ],
    "custom-auditor" = [{
      role_template_name = "Subaccount_Service_Auditor"
      role_name          = "Subaccount Service Auditor"
      },
      {
        role_template_name = "xsuaa_auditor"
        role_name          = "User and Role Auditor"
    }],
  }
}
