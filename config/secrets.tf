#### Secretmanager to store RDS details
module "secret-manager-without-rotation2" {
  source                     = "../modules/secret_manager/"
  secret_name                = "${var.app}-secrets"
  tags                       = local.tags
  app                        = var.app
}