output "service_entitlements" {
  description = "All entitlements that belong to services"
  value       = local.service_entitlements
}

output "app_entitlements" {
  description = "All entitlements that belong to applications"
  value       = local.app_entitlements
}

output "runtime_entitlements" {
  description = "All entitlements that belong to runtimes"
  value       = local.runtime_entitlements
}
