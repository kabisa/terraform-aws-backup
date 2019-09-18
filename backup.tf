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
    schedule          = "cron(0 0 * * ? *)"

    lifecycle {
      //      5 weeks * 7 days = 35 days
      delete_after = 35
    }
  }

  rule {
    rule_name         = "${module.label.id}${module.label.delimiter}weekly${module.label.delimiter}rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 0 ? * 1 *)"

    lifecycle {
      //      3 months * 30 days = 90 days
      delete_after = 90
    }
  }

  rule {
    rule_name         = "${module.label.id}${module.label.delimiter}monthly${module.label.delimiter}rule"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 0 1 * ? *)"

    lifecycle {
      //      3 months * 30 days = 90 days
      cold_storage_after = 90
      //      2 years * 365 days = 730 days
      delete_after = 730
    }
  }
}

resource "aws_backup_selection" "arn_resource_selection" {
  iam_role_arn = aws_iam_role.aws_backup_role.arn
  name         = "${module.label.id}${module.label.delimiter}arn${module.label.delimiter}resource${module.label.delimiter}selection"
  plan_id      = aws_backup_plan.plan.id

  resources = var.backup_resource_ids
}