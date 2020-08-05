resource "aws_secretsmanager_secret" "secret" {

  description         = "${var.app} Secrets "
#   kms_key_id          = "${data.aws_kms_key.sm.arn}"
  name                = "${var.app}-${var.secret_name}"
  tags                = var.tags
}
# resource "random_string" "rds_password" {
#   length = 16
#   special = true
# }


resource "aws_secretsmanager_secret_version" "secret_version" {
  # lifecycle {
  #   ignore_changes = [
  #     "secret_string"
  #   ]
  # }

  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = <<EOF
{
  "username": "${var.username}",
  "engine": "${var.engine}",
  "dbname": "${var.dbname}",
  "host": "${var.host}",
  "password": "${var.password}",
  "port": ${var.port},
  "dbClusterIdentifier": "${var.dbClusterIdentifier}"
}
EOF
}
