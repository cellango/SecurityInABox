locals {
  
  db_subnet_group_name = var.db_subnet_group_name == "" ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name
  
}
# Random string to use as master password unless one is specified
resource "random_id" "master_password" {
  byte_length = 10
}
# RDS DB Subnet Group
resource "aws_db_subnet_group" "this" {
  count           = var.db_subnet_group_name == "" ? 1 : 0
  name            = "${var.app}-db-subnet"
  description     = "For Aurora cluster ${var.name} ${var.app}"
  subnet_ids      = var.subnets
  # tags = merge(var.tags, {"Name" = "db-subnet"},)}
  tags            = merge(var.tags, map("Name", "${var.app}-db-subnet"))
}
# RDS Cluster details
resource "aws_rds_cluster" "this" {
  cluster_identifier                  = var.app
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  # kms_key_id                          = var.kms_key_id
  database_name                       = var.database_name
  master_username                     = var.master_username
  master_password                     = random_id.master_password.b64
  final_snapshot_identifier           = "${var.final_snapshot_identifier_prefix}-${random_id.snapshot_identifier.hex}"
  skip_final_snapshot                 = var.skip_final_snapshot
  deletion_protection                 = var.deletion_protection
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  port                                = var.port
  db_subnet_group_name                = local.db_subnet_group_name
  vpc_security_group_ids              = compact(concat(aws_security_group.this.*.id, var.vpc_security_group_ids))
  # snapshot_identifier                 = var.snapshot_identifier
  storage_encrypted                   = var.storage_encrypted
  apply_immediately                   = var.apply_immediately
  db_cluster_parameter_group_name     = var.db_cluster_parameter_group_name
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  tags                                = merge(var.tags, map("Name", "${var.app}-cluster"))
}

# RDS Cluster Instance details
resource "aws_rds_cluster_instance" "this" {
  count                           = var.replica_scale_enabled ? var.replica_scale_min : var.replica_count
  identifier                      = "${var.app}-${count.index + 1}"
  cluster_identifier              = aws_rds_cluster.this.id
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_type
  publicly_accessible             = var.publicly_accessible
  db_subnet_group_name            = local.db_subnet_group_name
  db_parameter_group_name         = var.db_parameter_group_name
  preferred_maintenance_window    = var.preferred_maintenance_window
  apply_immediately               = var.apply_immediately
  monitoring_role_arn             = join("", aws_iam_role.rds_enhanced_monitoring.*.arn)
  monitoring_interval             = var.monitoring_interval
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  promotion_tier                  = count.index + 1
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  tags                            = merge(var.tags, map("Name", "${var.app}-instance"))
  # tags                            = var.tags
}

resource "random_id" "snapshot_identifier" {
  keepers     = {
    id        = var.name
  }

  byte_length = 4
}

data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions       = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count              = var.monitoring_interval > 0 ? 1 : 0
  name               = "${var.app}-rds-enhanced-monitoring"
  assume_role_policy = data.aws_iam_policy_document.monitoring_rds_assume_role.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count      = var.monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_enhanced_monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_appautoscaling_target" "read_replica_count" {
  count               = var.replica_scale_enabled ? 1 : 0
  max_capacity       = var.replica_scale_max
  min_capacity       = var.replica_scale_min
  resource_id        = "cluster:${aws_rds_cluster.this.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "autoscaling_read_replica_count" {
  count              = var.replica_scale_enabled ? 1 : 0
  name               = "target-metric-${var.app}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.this.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }
    scale_in_cooldown        = var.replica_scale_in_cooldown
    scale_out_cooldown       = var.replica_scale_out_cooldown
    target_value             = var.replica_scale_cpu
  }

  depends_on                = [aws_appautoscaling_target.read_replica_count]
}

resource "aws_security_group" "this" {
  count       = var.create_security_group ? 1 : 0
  name        = "${var.app}-sg"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, map("Name", "${var.app}-sg"))
}

resource "aws_security_group_rule" "default_ingress" {
  count                    = var.create_security_group ? length(var.allowed_security_groups) : 0
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = aws_security_group.this[0].id
}

resource "aws_security_group_rule" "cidr_ingress" {
  count             = var.create_security_group && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = aws_security_group.this[0].id
}