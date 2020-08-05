resource "aws_cloudwatch_log_group" "ecs_cw" {
  name              = var.app
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "this" {
  family                = var.app
  execution_role_arn      =  "arn:aws:iam::389197809423:role/ecsTaskExecutionRole"
  container_definitions = var.task_def
}

resource "aws_ecs_service" "this" {
  name            = var.app
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 1

  //  iam_role        = var.iam_role


  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.app
    container_port   = var.container_port
  }
}

//resource "aws_ecs_service" "svc" {
//  name            = "${var.name}"
//  cluster         = "${var.cluster}"
//  task_definition = "${var.task_definition_arn}"
//  desired_count   = "${var.desired_count}"
//  iam_role        = "${aws_iam_role.svc.arn}"
//
//  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
//  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
//
//  load_balancer {
//    target_group_arn = "${var.alb_target_group_arn}"
//    container_name   = "${var.container_name}"
//    container_port   = "${var.container_port}"
//  }
//}