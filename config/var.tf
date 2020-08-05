variable "env" {
  default = "dev"
}
variable "app" {
  default = "headcount"
}
variable "cidr_blocks" {
  default = ["0.0.0.0/0"]
}

#________________ ECS Cluster ________________>>>>>
variable "region" {
  default = " "
}
variable "container_port" {
  default = "80"
}
//variable "vpc_id" {
//  default = " "
//}
//variable "subnet_ids" {
//  description = "EC2 subnets"
//  type        = "list"
//}
//variable "subnets" {
//  type = "list"
//
//}
//variable "subnet_id" {
//  description = "The VPC Subnet ID to launch in"
//  type        = string
//  default     = ""
//}
variable "instance_type" {
  default = " "
}
//variable "key_name" {
//  default = " "
//}
variable "instance_count" {
  default = " "
}

variable "max_size" {
  description = "The maximum size of the auto scale group"
  type        = string
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
  type        = string
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = string
}
//variable "vpc_zone_identifier" {
//  description = "A list of subnet IDs to launch resources in"
//  type        = list(string)
//  default     = []
//}
variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"

  type = list(object({
    device_name  = string
    no_device    = bool
    virtual_name = string
    ebs = object({
      delete_on_termination = bool
      encrypted             = bool
      iops                  = number
      kms_key_id            = string
      snapshot_id           = string
      volume_size           = number
      volume_type           = string
    })
  }))

  default = []
}
#######################
# ALB Variables
#######################

variable "name" {
  description = "The name of the LB. This name must be unique within your AWS account."
  default   = "headcount"
}
variable "access_logs_bucket" {
  type        = string
  description = "The S3 bucket name to store the logs in. Even if access_logs_enabled set false, you need to specify the valid bucket to access_logs_bucket."
}
# variable "certificate_arn" {
#   default     = ""
#   type        = string
#   description = "The ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS."
# }
variable "internal" {
  default     = ""
  type        = string
  description = "If true, the LB will be internal."
}
variable "access_logs_prefix" {
  default     = ""
  type        = string
  description = "The S3 bucket prefix. Logs are stored in the root if not configured."
}
variable "access_logs_enabled" {
  default     = ""
  type        = string
  description = "Boolean to enable / disable access_logs."
}
variable "https_port" {
  default     = ""
  type        = string
  description = "The HTTPS port."
}

variable "http_port" {
  default     = ""
  type        = string
  description = "The HTTP port."
}
variable "target_group_port" {
  default     = ""
  type        = string
  description = "The port on which targets receive traffic, unless overridden when registering a specific target."
}
variable "target_group_protocol" {
  default     = ""
  type        = string
  description = "The protocol to use for routing traffic to the targets. Should be one of HTTP or HTTPS."
}
variable "target_type" {
  default     = ""
  type        = string
  description = "The type of target that you must specify when registering targets with this target group. The possible values are instance or ip."
}
variable "health_check_path" {
  default     = ""
  type        = string
  description = "The destination for the health check request."
}
variable "health_check_port" {
  default     = ""
  type        = string
  description = "The port to use to connect with the target."
}

variable "health_check_protocol" {
  default     = ""
  type        = string
  description = "The protocol to use to connect with the target."
}
variable "enabled" {
  default     = ""
  type        = string
  description = "Set to false to prevent the module from creating anything."
}
variable "enable_deletion_protection" {
  default     = ""
  type        = string
  description = "If true, deletion of the load balancer will be disabled via the AWS API."
}
variable "listener_rule_priority" {
  default     = ""
  type        = string
  description = "The priority for the rule between 1 and 50000."
}

#----------------------RDS---------------------------------------------
//variable "name" {
//  description = "Name given resources"
//  type        = string
//}
variable "create_security_group" {
  description = "Whether to create security group for RDS cluster"
  default     = ""
}
variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
  default     = []
}

variable "replica_count" {
  description = "Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead."
  default     = ""
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  default     = []
}
variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = []
}
variable "allowed_security_groups_count" {
  description = "The number of Security Groups being added, terraform doesn't let us use length() in a count field"
  default     = 0
}

//variable "vpc_id" {
//  description = "VPC ID"
//  type        = string
//  default     = ""
//}

variable "rds_instance_type" {
  description = "Instance type to use"
  type        = string
}

variable "publicly_accessible" {
  description = "Whether the DB should have a public IP address"
  type        = bool
  default     = false
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}

variable "master_username" {
  description = "Master DB username"
  type        = string
  default     = ""
}

variable "password" {
  description = "Master DB password"
  type        = string
  default     = ""
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "skip_final_snapshot" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  default     = 7
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = ""
}

variable "preferred_maintenance_window" {
  description = "When to perform DB maintenance"
  type        = string
  default     = ""
}

variable "port" {
  description = "The port on which to accept connections"
  default     = 5432
}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected"
  type        = number
  default     = 60
}

variable "auto_minor_version_upgrade" {
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
  type        = bool
  default     = true
}

variable "db_parameter_group_name" {
  description = "The name of a DB parameter group to use"
  type        = string
  default     = ""
}

variable "db_cluster_parameter_group_name" {
  description = "The name of a DB Cluster parameter group to use"
  type        = string
  default     = ""
}

# variable "snapshot_identifier" {
#   description = "DB snapshot to create this database from"
#   type        = string
#   default     = ""
# }

variable "storage_encrypted" {
  description = "Specifies whether the underlying storage layer should be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = string
  default     = ""
}

variable "engine" {
  description = "Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql"
  type        = string
  default     = ""
}

variable "engine_version" {
  description = "Aurora database engine version."
  type        = string
  default     = ""
}

variable "replica_scale_enabled" {
  description = "Whether to enable autoscaling for RDS Aurora (MySQL) read replicas"
  # type        = bool
  default     = ""
}

variable "replica_scale_max" {
  description = "Maximum number of replicas to allow scaling for"
  type        = number
  default     = 5
}

variable "replica_scale_min" {
  description = "Minimum number of replicas to allow scaling for"
  type        = number
  default     = 2
}

variable "replica_scale_cpu" {
  description = "CPU usage to trigger autoscaling at"
  type        = number
  default     = 70
}

variable "replica_scale_in_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale in"
  type        = number
  default     = 300
}

variable "replica_scale_out_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale out"
  type        = number
  default     = 300
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data."
  type        = string
  default     = ""
}

# variable "iam_database_authentication_enabled" {
#   description = "Specifies whether IAM Database authentication should be enabled or not. Not all versions and instances are supported. Refer to the AWS documentation to see which versions are supported."
#   type        = bool
#   default     = false
# }

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = []
}

# variable "global_cluster_identifier" {
#   description = "The global cluster identifier specified on aws_rds_global_cluster"
#   type        = string
#   default     = ""
# }

variable "engine_mode" {
  description = "The database engine mode. Valid values: global, parallelquery, provisioned, serverless."
  type        = string
  default     = "provisioned"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list
  default     = []
}

variable "db_subnet_group_name" {
  description = "The existing subnet group name to use"
  type        = string
  default     = ""
}
variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots."
  default     = ""
}
//variable "target_acct_role_arn" {
//   default =   ""
//}
//variable "target_acct_ext_id" {
//   default =   ""
//}
//variable "env" {
//   default =   ""
//}
//variable "team" {
//   default =   ""
//}
//variable "subnet_ids" {
//  default =   ""
//}


## API GAteway ###
variable "path_parts" {
  type        = list
  default     = []
  description = "The last path segment of this API resource."
}
variable "http_methods" {
  type        = list
  default     = []
  description = "The last path segment of this API resource."
}


