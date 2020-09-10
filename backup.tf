resource "aws_kms_key" "kms_key" {
  description = "${var.name}-key"
}

resource "aws_backup_vault" "vault" {
  name        = "${var.name}-vault"
  kms_key_arn = aws_kms_key.kms_key.arn
}

resource "aws_backup_plan" "plan" {
  name = "${var.name}-plan"

  rule {
    rule_name         = "${var.name}-daily"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = var.daily_cron

    lifecycle {
      // default = 5 weeks * 7 days = 35 days
      delete_after = var.daily_delete_after
    }
  }

  rule {
    rule_name         = "${var.name}-weekly"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = var.weekly_cron

    lifecycle {
      // default = 3 months * 30 days = 90 days
      delete_after = var.weekly_delete_after
    }
  }

  rule {
    rule_name         = "${var.name}-monthly"
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
  name         = "${var.name}-resources"
  plan_id      = aws_backup_plan.plan.id

  resources = var.backup_resource_ids
}
