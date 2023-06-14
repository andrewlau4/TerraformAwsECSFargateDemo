resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.ecs_cluster_name}-exec-role"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "ecs_task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "ecs_task-execution-role-cloudwatch-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}



//this is the role given to the container, whatever aws service you want to access
// from the container, you need to give permission to this role 
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.ecs_cluster_name}-task-role"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}
resource "aws_iam_policy" "container_task_policy" {
  name        = "${var.ecs_cluster_name}-task-policy"
  description = "policy given to the ecs task, so it can access aws services"
  policy      = var.container_task_policy
}
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.container_task_policy.arn
}





resource "aws_security_group" "security_ingress" {
  name = "${var.ecs_cluster_name}-allow"
  vpc_id = local.service_vpc_id


  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"

    self = true
  }

  dynamic "ingress" {
    for_each = toset(var.service_ingress_allow)

    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.ip_protocol
      cidr_blocks      = [ingress.value.cidr_ipv4]
      ipv6_cidr_blocks = [ingress.value.cidr_ipv6]
    }
  }

  dynamic "egress" {
    for_each = toset(var.service_egress_allow)

    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.ip_protocol
      cidr_blocks      = [egress.value.cidr_ipv4]
      ipv6_cidr_blocks = [egress.value.cidr_ipv6]
    }
  }
}


data "aws_security_group" "default_security_group" {
  vpc_id = local.service_vpc_id
  name = "default"
}
