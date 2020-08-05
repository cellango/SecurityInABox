## ALB
module "alb" {
  source                           = "../modules/alb/"
  name                             = var.app
  vpc_id                           = module.vpc.vpc_id
  subnets                          = module.vpc.public_subnets
  security_groups                  = [aws_security_group.alb_sg.id]
  access_logs_bucket               = var.access_logs_bucket
  //  certificate_arn                  = data.aws_acm_certificate.cert.arn
  enable_https_listener            = true
  enable_http_listener             = true
  # enable_redirect_http_to_https_listener = true
  internal                         = var.internal
  idle_timeout                     = 120
  enable_http2                     = true
  ip_address_type                  = "ipv4"
  access_logs_prefix               = var.access_logs_prefix
  access_logs_enabled              = var.access_logs_enabled
  ssl_policy                       = "ELBSecurityPolicy-2016-08"
  https_port                       = var.https_port
  http_port                        = var.http_port
  target_group_port                = var.target_group_port
  target_group_protocol            = var.target_group_protocol
  target_type                      = var.target_type
  deregistration_delay             = 300
  slow_start                       = 0
  health_check_path                = var.health_check_path
  health_check_healthy_threshold   = 2
  health_check_unhealthy_threshold = 2
  health_check_timeout             = 3
  health_check_interval            = 5
  health_check_matcher             = "200-299"
  health_check_port                = var.health_check_port
  health_check_protocol            = var.health_check_protocol
  listener_rule_priority           = var.listener_rule_priority
  enabled                          = var.enabled
  # tags                             = merge(local.tags, map ("CostCentre", "XXXXXXXXX"))
  enable_deletion_protection = false
}

### ASG
module "asg" {
  source                            = "../modules/asg/"
  image_id                          = data.aws_ami.amazon_linux_ecs.id
  instance_type                     = var.instance_type
  iam_instance_profile              = module.ec2-profile.this_iam_instance_profile_id
  key_name                          = var.app
  user_data                         =  base64encode(data.template_file.user_data.rendered)

  security_groups                   = aws_security_group.app_sg.id
  //  app                               = var.app
  standard_tags                     = local.standard_tags
  tags                              = local.tags
  //  tag                               = var.tag
  //  env                               = var.env
  block_device_mappings             = var.block_device_mappings
  //  topic_arn                         = data.aws_sns_topic.sns_notify.arn
  vpc_zone_identifier               = module.vpc.private_subnets
  health_check_type                 = "EC2"
  //target_group_arns                 = module.alb.alb_target_group_arn
  min_size                          = var.min_size
  max_size                          = var.max_size
  desired_capacity                  = var.desired_capacity
  vpc_id                            = module.vpc.vpc_id
}

### Attaching TG to ASG
resource "aws_autoscaling_attachment" "alb_autoscale" {
  alb_target_group_arn   = module.alb.alb_target_group_arn
  autoscaling_group_name = module.asg.autoscaling_group_name
}

locals {
  name        = var.app
  environment = var.env

  # This is the convention we use to know what belongs to each other
  ec2_resources_name = "${local.name}-${local.environment}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

#----- ECS --------
module "ecs" {
  source             = "../modules/ecs-cluster/"
  name               = local.name
  container_insights = true

}

module "ec2-profile" {
  source = "../modules/ecs-instance-profile"
  name   = local.name

}

#----- ECS  Services--------


module "ecs_service" {
  source                  = "../modules/ecs_service"
  cluster_id              = module.ecs.this_ecs_cluster_id
  alb_target_group_arn    = module.alb.alb_target_group_arn
  iam_role                = module.ec2-profile.this_iam_instance_profile_arn
  app                     = var.app
  task_def                = data.template_file.this.rendered
  container_port          = var.container_port
}
#--------task definition read from data source --------------
variable "secrets" {
  default = ""
}
variable "executionRoleArn" {
  default = ""
}
data "template_file" "this" {
  template = file("./task_definition/task_definition.json.tpl")
  vars = {
//    aws_ecr_repository = aws_ecr_repository.repo.repository_url
    tag                = "latest"
    app_port           = var.container_port
    host_port          = var.container_port
    awslogs-group      = var.app
    awslogs-region     = var.region
    secrets            = jsonencode(var.secrets)
    executionRoleArn   = var.executionRoleArn
  }
}

#----- ECS  Resources--------
data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    cluster_name = local.name
  }
}


