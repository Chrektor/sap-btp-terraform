# ==============================================================================
# Variables for SAP BTP Terraform Root Module
# ==============================================================================

variable "globalaccount" {
  type        = string
  description = "Subdomain of your SAP BTP Global Account (can also be supplied via BTP_GLOBALACCOUNT env var)"
}

variable "cli_server_url" {
  type        = string
  description = "The URL of the SAP BTP CLI server"
  default     = "https://cli.btp.cloud.sap"
}

variable "idp" {
  type        = string
  description = "Custom Identity Provider (IAS host/tenant). Leave null if using default SAP ID Service"
  default     = null
}

# ------------------------------------------------------------------------------
# Subaccount Configuration
# ------------------------------------------------------------------------------

variable "create_subaccount" {
  type        = bool
  description = "Whether to create a new subaccount (true) or manage an existing one (false, standard for Trial accounts)"
  default     = false
}

variable "subaccount_id" {
  type        = string
  description = "ID (GUID) of an existing subaccount to manage. Required if create_subaccount is false (e.g. for Trial accounts)"
  default     = null
}

variable "subaccount_name" {
  type        = string
  description = "Display name of the subaccount"
  default     = "trial"
}

variable "subaccount_subdomain" {
  type        = string
  description = "Subdomain for the subaccount (unique within region, required if create_subaccount is true)"
  default     = null
}

variable "subaccount_region" {
  type        = string
  description = "Region identifier for the subaccount (e.g., us10, eu10, ap21)"
  default     = "us10"
}

variable "subaccount_description" {
  type        = string
  description = "Description for the subaccount"
  default     = "Managed by Terraform via Antigravity"
}

variable "subaccount_labels" {
  type        = map(list(string))
  description = "Labels to assign to the subaccount"
  default = {
    environment = ["dev"]
    managed_by  = ["terraform"]
  }
}

# ------------------------------------------------------------------------------
# Cloud Foundry Environment Configuration
# ------------------------------------------------------------------------------

variable "enable_cloud_foundry" {
  type        = bool
  description = "Whether to provision / manage a Cloud Foundry environment on this subaccount"
  default     = false
}

variable "cf_org_name" {
  type        = string
  description = "Name for the Cloud Foundry Organization (defaults to subaccount_subdomain or subaccount_name if not set)"
  default     = null
}

variable "cf_plan_name" {
  type        = string
  description = "Cloud Foundry environment service plan (e.g. 'trial' for trial accounts, 'standard' for enterprise)"
  default     = "trial"
}

variable "cf_landscape_label" {
  type        = string
  description = "Landscape label for Cloud Foundry (e.g., cf-us10, cf-eu10). Leave null for provider auto-selection"
  default     = null
}

variable "cf_managers" {
  type        = list(string)
  description = "List of user email addresses to assign as CF Org Managers upon provisioning"
  default     = []
}

# ------------------------------------------------------------------------------
# Entitlements Configuration
# ------------------------------------------------------------------------------

variable "entitlements" {
  type = list(object({
    service_name = string
    plan_name    = string
    amount       = optional(number)
  }))
  description = "List of service entitlements and plans to assign to the subaccount"
  default     = []
}

# ------------------------------------------------------------------------------
# Destinations Configuration
# ------------------------------------------------------------------------------

variable "destinations" {
  type = map(object({
    url                      = string
    type                     = optional(string, "HTTP")
    proxy_type               = optional(string, "Internet")
    authentication           = optional(string, "NoAuthentication")
    description              = optional(string, "Managed by Terraform")
    additional_configuration = optional(map(string), {})
  }))
  description = "Map of subaccount-level destinations to configure"
  default     = {}
}

# ------------------------------------------------------------------------------
# Security & Role Collections
# ------------------------------------------------------------------------------

variable "role_collections" {
  type = map(object({
    description = string
    roles = optional(list(object({
      role_template_app_id = string
      role_template_name   = string
      name                 = string
    })), [])
  }))
  description = "Custom role collections to create in the subaccount"
  default     = {}
}

variable "role_collection_assignments" {
  type = list(object({
    role_collection_name = string
    user_name            = string
    origin               = optional(string, "sap.default")
  }))
  description = "Assignments of role collections to users in the subaccount"
  default     = []
}
