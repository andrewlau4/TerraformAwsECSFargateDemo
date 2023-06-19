resource "aws_iam_role" "ecs_ec2_instance_role" {
  name = "${var.ecs_cluster_name}-ec2-instance-role${var.name_suffix}"
 
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

//https://serverfault.com/questions/855687/unable-to-start-task-in-ecs-tasks-are-in-pending-state
//
//
//https://catalog.workshops.aws/startup-security-baseline/en-US/c-securing-your-workload/level-1-controls/2-use-roles-for-compute-environments/2-3-create-role-for-container
//Set up a task Execution IAM Role for the Fargate launch type
//Set up an instance IAM Role for the EC2 launch type
//Create an IAM Role for Tasks
//
//https://stackoverflow.com/questions/66696083/how-to-get-set-aws-ecs-container-instance-role
//The console leads you to believe it's an ECS property but in fact it's simply an EC2 property known as "IAM Instance Profile". You have to specify this role by setting the IamInstanceProfile property on a AWS::EC2::Instance or even better on a AWS::EC2::LaunchTemplate resource that can be used inside an AutoScaling group. 
resource "aws_iam_role_policy_attachment" "ecs_ec2_task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


//https://stackoverflow.com/questions/66696083/how-to-get-set-aws-ecs-container-instance-role
resource "aws_iam_instance_profile" "ecs_ec2_lauch_template_instance_profile" {
  name = "${var.ecs_cluster_name}-ecs_ec2_lauch_template_instance_profile${var.name_suffix}"
  role = aws_iam_role.ecs_ec2_instance_role.name
}





data "aws_vpc" "default_vpc" {
  default = true
}

locals {
  replace_suffix_underscore = replace(var.name_suffix, "_", "-")
}

resource "aws_security_group" "autoscale_security_ingress" {
  name = "${var.ecs_cluster_name}-allow${local.replace_suffix_underscore}"
  vpc_id = data.aws_vpc.default_vpc.id


  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"

    self = true
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_security_group" "default_security_group" {
  vpc_id = data.aws_vpc.default_vpc.id
  name = "default"
}
