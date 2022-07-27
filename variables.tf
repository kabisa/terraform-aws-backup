# General
variable "backup_resource_ids" {
  type        = list
  description = "List of resource id's or ARNs you would like to include in the backup"
}

variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. 'app' or 'jenkins'"
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
