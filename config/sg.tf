### Security Group #######
resource "aws_security_group" "app_sg" {
  name        = "app-sg-${var.app}"
  description = "Allow inbound traffic and outbound traffic"
  vpc_id      = module.vpc.vpc_id
  tags        = merge(local.tags, map("Name", "app-sg-${var.app}"))
}
resource "aws_security_group_rule" "ingress1" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  security_group_id = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}
resource "aws_security_group_rule" "egress" {
  type                    = "egress"
  from_port               = 0
  to_port                 = 0
  protocol                = "-1"
  cidr_blocks             = ["0.0.0.0/0"]
  security_group_id       = aws_security_group.app_sg.id
}
#############################################################
### Security Group #######
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-${var.app}"
  description = "Allow inbound traffic and outbound traffic"
  vpc_id      = module.vpc.vpc_id
  tags        = merge(local.tags, map("Name", "alb-sg-${var.app}"))
}
resource "aws_security_group_rule" "alb_ingress1" {
  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = var.cidr_blocks

}
resource "aws_security_group_rule" "alb_egress" {
  type                    = "egress"
  from_port               = 0
  to_port                 = 0
  protocol                = "-1"
  cidr_blocks             = ["0.0.0.0/0"]
  security_group_id       = aws_security_group.alb_sg.id
}