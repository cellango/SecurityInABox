resource "aws_secretsmanager_secret" "secret" {
  description         = "${var.app} Secrets"
  name                = var.secret_name
  tags                = var.tags
}

##### Secret
resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = <<EOF
{
  "key": "value"
}
EOF
}
