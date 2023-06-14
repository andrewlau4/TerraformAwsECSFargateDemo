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




