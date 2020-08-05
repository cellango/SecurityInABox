
# variable "create_asg" {
#   description = "Whether to create autoscaling group"
#   type        = bool
#   default     = true
# }

# variable "asg_name" {
#   description = "Creates a unique name for autoscaling group beginning with the specified prefix"
#   type        = string
#   default     = ""
# }
# }
#########
//variable "tag" {
//   default =   ""
//}
//variable "team" {
//   default =   ""
//}
//variable "app" {
//   default =   ""
//}
//variable "env" {
//   default =   ""
//}
//variable "cr_no" {
//   default =   ""
//}
variable "ami" {
   default =   ""
}
####Launch Templates
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

####################
# Autoscaling group
####################
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

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "health_check_type" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
  type        = string
}

# variable "force_delete" {
#   description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
#   type        = bool
#   default     = false
# }

# variable "load_balancers" {
#   description = "A list of elastic load balancer names to add to the autoscaling group names"
#   type        = list(string)
#   default     = []
# }

# variable "target_group_arns" {
#   description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
#   type        = list(string)
#   default     = []
# }

# variable "termination_policies" {
#   description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are OldestInstance, NewestInstance, OldestLaunchConfiguration, ClosestToNextInstanceHour, Default"
#   type        = list(string)
#   default     = ["Default"]
# }

# variable "suspended_processes" {
#   description = "A list of processes to suspend for the AutoScaling Group. The allowed values are Launch, Terminate, HealthCheck, ReplaceUnhealthy, AZRebalance, AlarmNotification, ScheduledActions, AddToLoadBalancer. Note that if you suspend either the Launch or Terminate process types, it can prevent your autoscaling group from functioning properly."
#   type        = list(string)
#   default     = []
# }



variable "standard_tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "general tags"
  type        = map(string)
  default     = {}
}

variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  type        = string
  default     = "1Minute"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

# variable "wait_for_capacity_timeout" {
#   description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
#   type        = string
#   default     = "10m"
# }

# variable "min_elb_capacity" {
#   description = "Setting this causes Terraform to wait for this number of instances to show up healthy in the ELB only on creation. Updates will not wait on ELB instance number changes"
#   type        = number
#   default     = 0
# }

# variable "wait_for_elb_capacity" {
#   description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. Takes precedence over min_elb_capacity behavior."
#   type        = number
#   default     = null
# }

# variable "protect_from_scale_in" {
#   description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for termination during scale in events."
#   type        = bool
#   default     = false
# }

# ####################
# # Launch template
# ####################
variable "image_id" {
  description = "The EC2 image ID to launch"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The size of instance to launch"
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to associate with launched instances"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The key name that should be used for the instance"
  type        = string
  default     = ""
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the launch configuration"
  # type        = list(string)
  default     = ""
}

# variable "associate_public_ip_address" {
#   description = "Associate a public ip address with an instance in a VPC"
#   type        = bool
#   default     = false
# }

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = " "
}
variable "enabled" {
  description = "bool synatx"
  type        = bool
  default     = true
}

variable "topic_arn" {
  description = "The topic arn"
  default     = ""
}
# variable "soa_path" {
#    default =   ""
# }
variable "vpc_id" {
   default =   ""
}