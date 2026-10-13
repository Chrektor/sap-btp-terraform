# ==============================================================================
# SAP BTP Root Module - Infrastructure as Code
# ==============================================================================

# ------------------------------------------------------------------------------
# Provider Configuration
# ------------------------------------------------------------------------------
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
  idp            = var.idp
}

# ------------------------------------------------------------------------------
# Data Sources: Account & Identity Context
# ------------------------------------------------------------------------------
data "btp_globalaccount" "this" {}

data "btp_whoami" "me" {}

# List existing subaccounts (used when managing existing subaccount e.g. Trial)
data "btp_subaccounts" "all" {
  count = var.create_subaccount ? 0 : 1
}

# ------------------------------------------------------------------------------
# Subaccount Management
# ------------------------------------------------------------------------------

# Create subaccount if requested (Enterprise / Pay-as-you-go)
resource "btp_subaccount" "this" {
  count       = var.create_subaccount ? 1 : 0
  name        = var.subaccount_name
  subdomain   = coalesce(var.subaccount_subdomain, lower(var.subaccount_name))
  region      = var.subaccount_region
  description = var.subaccount_description
  labels      = var.subaccount_labels
}

locals {
  # Dynamically resolve active subaccount ID
  subaccount_id = var.create_subaccount ? btp_subaccount.this[0].id : (
    var.subaccount_id != null ? var.subaccount_id : (
      length([for s in try(data.btp_subaccounts.all[0].values, []) : s.id if s.name == var.subaccount_name]) > 0
      ? [for s in data.btp_subaccounts.all[0].values : s.id if s.name == var.subaccount_name][0]
      : try(data.btp_subaccounts.all[0].values[0].id, "")
    )
  )
}

# ------------------------------------------------------------------------------
# Entitlements Management
# ------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "service_entitlements" {
  for_each = {
    for idx, ent in var.entitlements : "${ent.service_name}-${ent.plan_name}" => ent
  }

  subaccount_id = local.subaccount_id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
  amount        = each.value.amount
}

# ------------------------------------------------------------------------------
# Cloud Foundry Environment Provisioning
# ------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  count = var.enable_cloud_foundry ? 1 : 0

  subaccount_id    = local.subaccount_id
  name             = coalesce(var.cf_org_name, var.subaccount_name)
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = var.cf_plan_name
  landscape_label  = var.cf_landscape_label

  parameters = jsonencode({
    instance_name = coalesce(var.cf_org_name, var.subaccount_name)
    users = [
      for manager in var.cf_managers : {
        email = manager
      }
    ]
  })

  depends_on = [
    btp_subaccount_entitlement.service_entitlements
  ]
}

# ------------------------------------------------------------------------------
# Destinations Management
# ------------------------------------------------------------------------------
resource "btp_subaccount_destination_generic" "destinations" {
  for_each = var.destinations

  subaccount_id = local.subaccount_id
  destination_configuration = jsonencode(merge({
    Name           = each.key
    Type           = each.value.type
    URL            = each.value.url
    ProxyType      = each.value.proxy_type
    Authentication = each.value.authentication
    Description    = each.value.description
  }, each.value.additional_configuration))
}

# ------------------------------------------------------------------------------
# Security: Custom Role Collections
# ------------------------------------------------------------------------------
resource "btp_subaccount_role_collection" "custom_role_collections" {
  for_each = var.role_collections

  subaccount_id = local.subaccount_id
  name          = each.key
  description   = each.value.description

  roles = [
    for r in each.value.roles : {
      name                 = r.name
      role_template_app_id = r.role_template_app_id
      role_template_name   = r.role_template_name
    }
  ]
}

# ------------------------------------------------------------------------------
# Security: Role Collection Assignments to Users
# ------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "assignments" {
  for_each = {
    for idx, assign in var.role_collection_assignments : "${assign.role_collection_name}-${assign.user_name}" => assign
  }

  subaccount_id        = local.subaccount_id
  role_collection_name = each.value.role_collection_name
  user_name            = each.value.user_name
  origin               = each.value.origin

  depends_on = [
    btp_subaccount_role_collection.custom_role_collections
  ]
}
