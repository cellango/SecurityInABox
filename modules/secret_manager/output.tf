// aws_secret_manger
output "secret_manager_name" {
  value = "${aws_secretsmanager_secret.secret.name}"
}