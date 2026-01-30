//----------------------------------------------------
// Flatten out the input for using it in the entitlement resource
//----------------------------------------------------
locals {
  parsed_entitlements_data = flatten([
    for service, plans in var.entitlements : [
      for plan in plans : {
        service_name = service
        plan_name    = split("=", plan)[0]
        amount       = length(split("=", plan)) > 1 ? split("=", plan)[1] : "0"
      }
    ]
  ])
}

//----------------------------------------------------
// Create a subaccount
// We skip auto entitlement to manage entitlements via btp_subaccount_entitlement resource for all services
//----------------------------------------------------
resource "btp_subaccount" "my_eu10_subaccount" {
  name                  = "Test landscape Labels EU10"
  subdomain             = "test-landscape-labels-eu10"
  region                = "eu10"
  skip_auto_entitlement = true
}

//----------------------------------------------------
// We iterate over the parsed entitlements and assign them to the subaccount
//----------------------------------------------------
resource "btp_subaccount_entitlement" "entitlement" {
  for_each = {
    for entitlement in local.parsed_entitlements_data :
    "${entitlement.service_name}-${entitlement.plan_name}" => entitlement
  }
  subaccount_id = btp_subaccount.my_eu10_subaccount.id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
  amount        = each.value.amount != "0" ? each.value.amount : null
}

//----------------------------------------------------
// The computed information from the entitlements contains the information about the category of each entitlement
// We build a map of enriched entitlements with category information
// and then group them by their category into service, app and runtime entitlements
// These groups can then be used to create service instances or subscribe to applications
//----------------------------------------------------
locals {
  enriched_entitlements = [
    for entitlement in local.parsed_entitlements_data : {
      amount       = entitlement.amount
      plan_name    = entitlement.plan_name
      service_name = entitlement.service_name
      category     = btp_subaccount_entitlement.entitlement["${entitlement.service_name}-${entitlement.plan_name}"].category
    }
  ]

  category_groups = {
    service = ["SERVICE", "ELASTIC_SERVICE", "ELASTIC_LIMITED"]
    app     = ["APPLICATION", "QUOTA_BASED_APPLICATION"]
    runtime = ["PLATFORM", "ENVIRONMENT"]
  }

  entitlements_by_type = {
    for type, categories in local.category_groups : "${type}_entitlements" => {
      for entitlement in local.enriched_entitlements :
      "${entitlement.service_name}-${entitlement.plan_name}" => entitlement
      if contains(categories, entitlement.category)
    }
  }

  service_entitlements = local.entitlements_by_type["service_entitlements"]
  app_entitlements     = local.entitlements_by_type["app_entitlements"]
  runtime_entitlements = local.entitlements_by_type["runtime_entitlements"]
}
