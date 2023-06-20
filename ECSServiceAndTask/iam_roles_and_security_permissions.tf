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
/*
//https://serverfault.com/questions/855687/unable-to-start-task-in-ecs-tasks-are-in-pending-state
//
//
//https://catalog.workshops.aws/startup-security-baseline/en-US/c-securing-your-workload/level-1-controls/2-use-roles-for-compute-environments/2-3-create-role-for-container
//Set up a task Execution IAM Role for the Fargate launch type
//Set up an instance IAM Role for the EC2 launch type
//Create an IAM Role for Tasks
//
//https://stackoverflow.com/questions/66696083/how-to-get-set-aws-ecs-container-instance-role
//
//https://stackoverflow.com/questions/66696083/how-to-get-set-aws-ecs-container-instance-role
//The console leads you to believe it's an ECS property but in fact it's simply an EC2 property known as "IAM Instance Profile". You have to specify this role by setting the IamInstanceProfile property on a AWS::EC2::Instance or even better on a AWS::EC2::LaunchTemplate resource that can be used inside an AutoScaling group. 
resource "aws_iam_role_policy_attachment" "ecs_ec2_task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
*/

resource "aws_iam_role_policy_attachment" "ecs_task-execution-role-cloudwatch-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}



//this is the role given to the container, whatever aws service you want to access
// from the container, you need to give permission to this role 
// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html?icmpid=docs_ecs_hp-task-definition
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
