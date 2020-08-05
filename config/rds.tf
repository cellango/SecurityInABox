#############
# RDS Aurora
#############
module "aurora" {
  source                          = "../modules/rds/"
  name                            = var.name
  engine                          = var.engine
  engine_version                  = var.engine_version
  subnets                         = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id
  replica_count                   = var.replica_count
  replica_scale_enabled           = var.replica_scale_enabled
  instance_type                   = var.rds_instance_type
  database_name                   = var.database_name
  master_username                 = var.master_username
  storage_encrypted               = true
  monitoring_interval             = 60
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  apply_immediately               = var.apply_immediately
  skip_final_snapshot             = var.skip_final_snapshot
  db_parameter_group_name         = aws_db_parameter_group.aurora_db_postgres10_parameter_group.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_postgres10_parameter_group.id
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  allowed_security_groups         = [aws_security_group.app_sg.id]
  allowed_cidr_blocks             = var.allowed_cidr_blocks
  create_security_group           = var.create_security_group
  tags                            = local.tags
  app                             = var.app
}

resource "aws_db_parameter_group" "aurora_db_postgres10_parameter_group" {
  name                            = "${var.app}-aurora-db-postgres10-parameter-group"
  family                          = "aurora-postgresql10"
  description                     = "${var.app}-aurora-db-postgres10-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_cluster_postgres10_parameter_group" {
  name                            = "${var.app}-aurora-postgres10-cluster-parameter-group"
  family                          = "aurora-postgresql10"
  description                     = "${var.app}-aurora-postgres10-cluster-parameter-group"
}


#### Secretmanager to store RDS details
module "secret-manager-without-rotation" {
  source                     = "../modules/rds_secret_manager/"
  # name                       = "PassRotation"
  secret_name                = "db-credentials"
  username                   = module.aurora.this_rds_cluster_master_username
  engine                     = "postgres"
  dbClusterIdentifier        = module.aurora.this_rds_cluster_indentifier
  dbname                     = module.aurora.this_rds_cluster_database_name
  host                       = module.aurora.this_rds_cluster_endpoint
  password                   = module.aurora.this_rds_cluster_master_password
  port                       = module.aurora.this_rds_cluster_port
  tags                       = local.tags
  app                        = var.app
}



