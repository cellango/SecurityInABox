resource "aws_lb" "application" {
  # count                            = "${var.enabled}"
  count                            = "${var.enabled}" ? 1 : 0
  load_balancer_type               = "application"
  name                             = var.name
  internal                         = var.internal
  security_groups                  = var.security_groups
  subnets                          = var.subnets
  idle_timeout                     = var.idle_timeout
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  # tags                             = "${merge(var.tags, map("CostCentre", "XXXXXXXXX"))}"
    # tags                            = "${merge(local.tags, map ("CostCentre", "XXXXXXXXX"))}"

  access_logs {
    bucket  = var.access_logs_bucket
    prefix  = var.access_logs_prefix
    enabled = var.access_logs_enabled
  }
}

resource "aws_lb_target_group" "default" {
  # count                 = "${var.enabled}"
  count                 = var.enabled ? 1 : 0
  name                  = "${var.name}-tg"
  vpc_id                = var.vpc_id
  port                  = var.target_group_port
  protocol              = var.target_group_protocol
  target_type           = var.target_type
  deregistration_delay  = var.deregistration_delay
  slow_start            = var.slow_start
  health_check {
    path                = var.health_check_path
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    port                = var.health_check_port
    protocol            = var.health_check_protocol
  }
  # tags                  = "${merge(var.tags, map("CostCentre", "XXXXXXXXX"))}"
  # tags                  = "${merge(local.tags, map ("CostCentre", "XXXXXXXXX"))}"
  depends_on = [aws_lb.application]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  count = local.enable_http_listener ? 1 : 0

  # load_balancer_arn = "${aws_lb.application.arn}"
  # load_balancer_arn   = "${aws_lb.application[count.index]}"
  load_balancer_arn   = element(concat(aws_lb.application.*.arn),0,)
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default[0].arn
  }
}

//resource "aws_lb_listener" "https" {
//  count               = "${local.enable_https_listener ? 1 : 0}"
//  # load_balancer_arn   = "${aws_lb.application.arn}"
//  # load_balancer_arn   = "${aws_lb.application[count.index]}"
//  load_balancer_arn   = element(concat(aws_lb.application.*.arn),0,)
//  port                = "${var.https_port}"
//  protocol            = "HTTPS"
//  ssl_policy          = "${var.ssl_policy}"
//  certificate_arn     = "${var.certificate_arn}"
//
//  default_action {
//    type              = "forward"
//    # target_group_arn  = "${aws_lb_target_group.default[count.index]}"
//    target_group_arn = aws_lb_target_group.default[0].id
//  }
//}


//resource "aws_lb_listener" "http" {
//  count = "${local.enable_http_listener ? 1 : 0}"
//
//  # load_balancer_arn = "${aws_lb.application.arn}"
//  # load_balancer_arn   = "${aws_lb.application[count.index]}"
//  load_balancer_arn   = element(concat(aws_lb.application.*.arn),0,)
//  port              = "${var.http_port}"
//  protocol          = "HTTP"
//
//   default_action {
//      type = "redirect"
//    redirect {
//      port        = "${var.https_port}"
//      protocol    = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
//}




locals {
  enable_https_listener                  = var.enabled && var.enable_https_listener
  enable_http_listener                   = var.enabled && var.enable_http_listener
  # enable_redirect_http_to_https_listener = "${var.enabled && var.enable_http_listener && (var.enable_https_listener && var.enable_redirect_http_to_https_listener)}"
}

