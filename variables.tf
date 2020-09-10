# General
variable "backup_resource_ids" {
  type        = list
  description = "List of resource id's or ARNs you would like to include in the backup"
}

# Labels
variable "namespace" {
  type        = "string"
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "name" {
  type        = "string"
  default     = ""
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

# Backup rules
variable "daily_cron" {
  default = "cron(0 0 * * ? *)"
}

variable "daily_delete_after" {
  default = 35
}

variable "weekly_cron" {
  default = "cron(0 0 ? * 1 *)"
}

variable "weekly_delete_after" {
  default = 90
}

variable "monthly_cron" {
  default = "cron(0 0 1 * ? *)"
}

variable "monthly_delete_after" {
  default = 730
}

variable "monthly_cold_storage_after" {
  default = 90
}
