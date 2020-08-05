variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}
variable "alb_target_group_arn" {
  description = "ARN of the ALB target group that should be associated with the ECS service"
}

//variable "cluster" {
//  description = "Name of the ECS cluster to create service in"
//}

variable "container_name" {
  description = "Name of the container that will be attached to the ALB"
  default = "demo"
}

variable "container_port" {
  description = "port the container is listening on"
  default     = 80
}
variable "iam_role" {
  default = ""
}
variable "app" {
  default = "headcount"
}
variable "task_def" {
  default = ""
}