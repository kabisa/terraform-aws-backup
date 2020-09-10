resource "aws_kms_key" "kms_key" {
  description = "${module.label.id}${module.label.delimiter}kms${module.label.delimiter}key"
}

resource "aws_backup_vault" "vault" {
  name        = "${module.label.id}${module.label.delimiter}backup${module.label.delimiter}vault"
  kms_key_arn = aws_kms_key.kms_key.arn
}

resource "aws_backup_plan" "plan" {
  name = "${module.label.id}${module.label.delimiter}backup${module.label.delimiter}plan"

  rule {
    rule_name         = "${module.label.id}${module.label.delimiter}daily${module.label.delimiter}rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = var.daily_cron

    lifecycle {
      // default = 5 weeks * 7 days = 35 days
      delete_after = var.daily_delete_after
    }
  }

  rule {
    rule_name         = "${module.label.id}${module.label.delimiter}weekly${module.label.delimiter}rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = var.weekly_cron

    lifecycle {
      // default = 3 months * 30 days = 90 days
      delete_after = var.weekly_delete_after
    }
  }

  rule {
    rule_name         = "${module.label.id}${module.label.delimiter}monthly${module.label.delimiter}rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = var.monthly_cron

    lifecycle {
      // default = 3 months * 30 days = 90 days
      cold_storage_after = var.monthly_cold_storage_after

      // default = 2 years * 365 days = 730 days
      delete_after = var.monthly_delete_after
    }
  }
}

resource "aws_backup_selection" "arn_resource_selection" {
  iam_role_arn = aws_iam_role.aws_backup_role.arn
  name         = "${module.label.id}${module.label.delimiter}arn${module.label.delimiter}resource${module.label.delimiter}selection"
  plan_id      = aws_backup_plan.plan.id

  resources = var.backup_resource_ids
}
