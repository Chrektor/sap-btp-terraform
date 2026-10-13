# ==============================================================================
# SAP BTP Root Module - Outputs
# ==============================================================================

output "globalaccount_id" {
  description = "The GUID of the SAP BTP Global Account"
  value       = data.btp_globalaccount.this.id
}

output "globalaccount_name" {
  description = "Display name of the SAP BTP Global Account"
  value       = data.btp_globalaccount.this.name
}

output "current_user" {
  description = "Authenticated user identity executing Terraform"
  value       = data.btp_whoami.me.email
}

output "subaccount_id" {
  description = "The target subaccount ID (GUID) managed by Terraform"
  value       = local.subaccount_id
}

output "cloudfoundry_environment" {
  description = "Cloud Foundry environment instance details if provisioned"
  value = var.enable_cloud_foundry ? {
    id            = btp_subaccount_environment_instance.cloudfoundry[0].id
    org_name      = btp_subaccount_environment_instance.cloudfoundry[0].name
    state         = btp_subaccount_environment_instance.cloudfoundry[0].state
    dashboard_url = btp_subaccount_environment_instance.cloudfoundry[0].dashboard_url
  } : null
}

output "destinations" {
  description = "List of managed subaccount destinations"
  value       = [for d in btp_subaccount_destination_generic.destinations : d.name]
}

output "role_collections" {
  description = "List of managed custom role collections"
  value       = [for rc in btp_subaccount_role_collection.custom_role_collections : rc.name]
}
