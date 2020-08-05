# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
//
# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}
# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}
//
# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}
############################
####### ECS Cluster#########
############################
output "alb_target_group_arn" {
  value       = module.alb.alb_target_group_arn
  description = "The ARN of the Target Group (matches id)"
}
output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of ALB"
}
output "this_iam_instance_profile_arn" {
  value = module.ec2-profile.this_iam_instance_profile_arn
}

output "autoscaling_group_name" {
  value = module.asg.autoscaling_group_name
}


#----------------RDS-----------------------
// aws_rds_cluster
output "this_rds_cluster_id" {
  description = "The ID of the cluster"
  value       = module.aurora.this_rds_cluster_id
}

output "this_rds_cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = module.aurora.this_rds_cluster_resource_id
}

output "this_rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.aurora.this_rds_cluster_endpoint
}

output "this_rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = module.aurora.this_rds_cluster_reader_endpoint
}

output "this_rds_cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = module.aurora.this_rds_cluster_database_name
}

output "this_rds_cluster_master_password" {
  description = "The master password"
  value       = module.aurora.this_rds_cluster_master_password
}

output "this_rds_cluster_port" {
  description = "The port"
  value       = module.aurora.this_rds_cluster_port
}

output "this_rds_cluster_master_username" {
  description = "The master username"
  value       = module.aurora.this_rds_cluster_master_username
}

// aws_rds_cluster_instance
output "this_rds_cluster_instance_endpoints" {
  description = "A list of all cluster instance endpoints"
  value       = module.aurora.this_rds_cluster_instance_endpoints
}

// aws_security_group
output "this_security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.aurora.this_security_group_id
}
# output "random_id_name" {
#   value = "${module.aurora.random_id_name}"
# }

// Secrets name
output "secret_manager_name" {
  description = "The security group ID of the cluster"
  value       = module.secret-manager-without-rotation.secret_manager_name
}


#### API GAteway####

output "arn" {
  value       = join("", module.api-gateway.*.execution_arn)
  description = "The Execution ARN of the REST API."
}

output "api_id" {
  value       = join("", module.api-gateway.*.id)
  description = "The ID of the REST API."
}
