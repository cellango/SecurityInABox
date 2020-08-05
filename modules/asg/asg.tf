
resource "aws_launch_template" "launch_temp" {
    count                     = var.enabled ? 1 : 0
# count                         = var.enabled && var.app != "soa" ? 1 : 0
  name                          = "lt-demo"
  disable_api_termination       = false
  iam_instance_profile {
    name                        = var.iam_instance_profile
  }
  image_id                      = var.image_id
  instance_initiated_shutdown_behavior = "stop"
  instance_type                 = var.instance_type
  key_name                      = var.key_name
  vpc_security_group_ids        = [var.security_groups]
  ebs_optimized                 = false
  
  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = lookup(block_device_mappings.value, "device_name", null)
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten(list(lookup(block_device_mappings.value, "ebs", [])))
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          iops                  = lookup(ebs.value, "iops", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
        }
      }
    }
  }
  user_data                     = var.user_data
  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = var.standard_tags
  }
  tag_specifications {
    resource_type = "volume"
    tags = var.standard_tags
  }
  tags = var.tags
    lifecycle {
    create_before_destroy = true
  }
}
## Creating AutoScaling Group
resource "aws_autoscaling_group" "app-asg" {
  count                     = var.enabled ? 1 : 0
# count                         = var.enabled && var.app != "soa" ? 1 : 0
  name                      = "asg-demo"
  launch_template           {
    id                      = aws_launch_template.launch_temp[0].id
    version                 = "$Latest"
  }
  vpc_zone_identifier       = var.vpc_zone_identifier
  force_delete              = true
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  default_cooldown          = 300
  health_check_type         = var.health_check_type
  enabled_metrics           = var.enabled_metrics
                                
 metrics_granularity        = var.metrics_granularity
  dynamic "tag" {
    for_each                = var.standard_tags

    content {
      key                   = tag.key
      value                 = tag.value
      propagate_at_launch   = true
    }
  }
  lifecycle {
    create_before_destroy   = true
  }
}

## ASG Notification

//resource "aws_autoscaling_notification" "asg_notifications" {
//
//  group_names = [
//    aws_autoscaling_group.app-asg[0].name,
//  ]
//
//  notifications = [
//    "autoscaling:EC2_INSTANCE_LAUNCH",
//    "autoscaling:EC2_INSTANCE_TERMINATE",
//    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
//    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
//  ]
//
//  topic_arn = var.topic_arn
//}

