resource "aws_iam_role" "aws_backup_role" {
  name               = "${module.label.id}${module.label.delimiter}backup${module.label.delimiter}role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
  tags               = module.label.tags
}

resource "aws_iam_role_policy_attachment" "aws_backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.aws_backup_role.name
}