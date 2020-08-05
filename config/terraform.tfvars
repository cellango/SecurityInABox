region              = "us-east-2"
app   = "headcount"
env   = "dev"

#<---------- ECS Cluster ----------->
//region              = "us-east-1"
//vpc_id              = "vpc-df3fdca2"
//subnets             = ["subnet-b50fd8d3" , "subnet-b5cf1294", "subnet-963923a8",
//  "subnet-910264dc" , "subnet-2727ae29", "subnet-0e9f4c51"]
//subnet_ids          = ["subnet-b50fd8d3" , "subnet-b5cf1294", "subnet-963923a8",
//  "subnet-910264dc" , "subnet-2727ae29", "subnet-0e9f4c51"]  # private subnets
//vpc_zone_identifier = ["subnet-b50fd8d3" , "subnet-b5cf1294", "subnet-963923a8",
//  "subnet-910264dc" , "subnet-2727ae29", "subnet-0e9f4c51"]
#vpc_zone_identifier = ["subnet-910264dc" ,"subnet-2727ae29", "subnet-0e9f4c51"] # private subnets # "subnet-019474e140741d209"
instance_type       = "t2.micro"
container_port      = 3443
max_size            = 1
min_size            = 1
desired_capacity    = 1

block_device_mappings = [
  {
    device_name  = "/dev/xvda"
    no_device    = "false"
    virtual_name = "EBS"
    ebs = {
      delete_on_termination     = true
      encrypted = false
      volume_size     = 40
      volume_type = "gp2"
      iops        = null
      kms_key_id = null
      snapshot_id = null
    }
  }
]
##############################################################
# ALB Configurations
##############################################################
access_logs_bucket = "xyz"
internal = false
access_logs_prefix = "lb-logs"
access_logs_enabled = false
https_port = "443"
http_port = "80"
target_group_port = "3443"
target_group_protocol = "HTTP"
target_type = "instance"
health_check_path = "/health"
health_check_port = "3443"
health_check_protocol = "HTTP"
enabled = true
enable_deletion_protection = false
listener_rule_priority = 1

#---------------------------RDS----------------------------------
//name                            = "rds"
//subnets                         = ["subnet-0cb72a3634dacbb2e" , "subnet-019474e140741d209" , "subnet-0f83d46704a704fdb"] #private subnet
//subnet_ids                      = ["subnet-0cb72a3634dacbb2e" , "subnet-019474e140741d209" , "subnet-0f83d46704a704fdb"] #private subnet
replica_count                   = 1
replica_scale_enabled           = false #auto scaling
//vpc_id                          = "vpc-0203ddc19e978da69"
rds_instance_type               = "db.t3.medium"  #https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html
database_name                   = "headcount_db"
master_username                 = "headcount_admin"
preferred_backup_window         = "01:00-02:00"
preferred_maintenance_window    = "sun:03:00-sun:04:00"
db_parameter_group_name         = "default.aurora5.6"
db_cluster_parameter_group_name = "default.aurora5.6"
engine                          = "aurora-postgresql"
engine_version                  = "10.7"
db_subnet_group_name            = ""
apply_immediately               = true
skip_final_snapshot             = true
enabled_cloudwatch_logs_exports = ["postgresql"]
copy_tags_to_snapshot           = true
create_security_group           = true
//allowed_security_groups         = ["sg-0d09130427f64caac"]
allowed_cidr_blocks             = []
#####
executionRoleArn                = "arn:aws:iam::389197809423:role/ecsTaskExecutionRole"
secrets                         = [
  {
  name: "AUTH0_CLIENT_SECRET",
  valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:AUTH0_CLIENT_SECRET::"
  },
  {
    name: "AUTH0_CLIENT_ID",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:AUTH0_CLIENT_ID::"
  },
  {
    name: "SENDGRID_API_KEY",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:SENDGRID_API_KEY::"
  },
  {
    name: "SENDGRID_TEMPLATE_CONTRACTOR_INVITE_ID",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:SENDGRID_TEMPLATE_CONTRACTOR_INVITE_ID::"
  },
  {
    name: "ROUTEFUSION_CLIENT_ID",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:ROUTEFUSION_CLIENT_ID::"
  },
  {
    name: "ROUTEFUSION_CLIENT_SECRET",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:ROUTEFUSION_CLIENT_SECRET::"
  },
  {
    name: "PLAID_CLIENT_ID",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:PLAID_CLIENT_ID::"
  },
  {
    name: "PLAID_SECRET",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:PLAID_SECRET::"
  },
  {
    name: "PLAID_PUBLIC_KEY",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:PLAID_PUBLIC_KEY::"
  },
  {
    name: "AWS_ACCESS_KEY_ID",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:AWS_ACCESS_KEY_ID::"
  },
  {
    name: "AWS_SECRET_ACCESS_KEY",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:AWS_SECRET_ACCESS_KEY::"
  },
  {
    name: "SENTRY_DSN",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:SENTRY_DSN::"
  },
  {
    name: "BASIC_AUTH_PASSWORD",
    valueFrom: "arn:aws:secretsmanager:us-east-2:389197809423:secret:headcount-secrets-bzBhpz:BASIC_AUTH_PASSWORD::"
  }


]





