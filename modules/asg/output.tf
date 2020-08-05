####SOA####
output "autoscaling_group_id" {
  value = join("", aws_autoscaling_group.app-asg.*.id)
}

output "autoscaling_group_name" {
  value = join("", aws_autoscaling_group.app-asg.*.name)
}

output "autoscaling_group_arn" {
  description = "The ARN for this AutoScaling Group"
  value       =   join("", aws_autoscaling_group.app-asg.*.arn)
}

output "autoscaling_group_min_size" {
  description = "The minimum size of the autoscale group"
  value       =   join("", aws_autoscaling_group.app-asg.*.min_size)
}

output "autoscaling_group_max_size" {
  description = "The maximum size of the autoscale group"
  value       =  join("", aws_autoscaling_group.app-asg.*.max_size)
}

output "autoscaling_group_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  value       =  join("", aws_autoscaling_group.app-asg.*.desired_capacity)
}

# Launch template SOA
output "launch_template_id" {
  description = "The ID of the launch template"
  value       =  join("", aws_launch_template.launch_temp.*.id)
}

output "launch_template_name" {
  description = "The name of the launch template"
  value       =  join("", aws_launch_template.launch_temp.*.id)
}
##############################################
