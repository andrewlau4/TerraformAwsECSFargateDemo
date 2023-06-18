data "aws_ami" "ecs_ec2_image" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = [ var.ami_image ]
    }

}

resource "aws_launch_template" "scale_group_lauch_template" {
    name_prefix   = "${var.ecs_cluster_name}_auto_scaling_template1${var.name_suffix}"
    image_id      = data.aws_ami.ecs_ec2_image.id
    instance_type = var.ami_instance_type

    iam_instance_profile {
      arn = aws_iam_instance_profile.ecs_ec2_lauch_template_instance_profile.arn
    }

    network_interfaces {
      associate_public_ip_address = true

      security_groups = [ 
        aws_security_group.security_ingress.id,
        data.aws_security_group.default_security_group.id
        ]
    }

    //https://github.com/hashicorp/terraform-provider-aws/issues/4570
    //Remove the SG from the bottom, not the interface.
    // no that is not the issue, the issue is the name already exists, so i call it
    //  Remove the SG from the bottom, not the interface. instead
    security_group_names = [
        "default", aws_security_group.security_ingress.name
    ]

    //either install the ecs agent yourself, or use the pre-made ami see 
    //     https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-agent-install.html
    //
    //  use  sudo su -   
    //   to login as root to check this 
    user_data = base64encode(
        templatefile("${path.module}/install_ecs_agent.sh",
        { ecs_cluster_name = var.ecs_cluster_name })
    )
}

data "aws_subnets" "avail_zone_subnets" {
    filter {
        name = "availability-zone"
        values = [ var.avail_zone ]
    }
    filter {
        name = "vpc-id"
        values =  [ data.aws_vpc.default_vpc.id ]
    }
}

resource "aws_autoscaling_group" "ecs_auto_scaling" {
    name = "ecs_auto_scaling${var.name_suffix}"

    max_size = var.auto_scale_grp_info.max_size
    min_size = var.auto_scale_grp_info.min_size
    desired_capacity = var.auto_scale_grp_info.desired_capacity
    health_check_grace_period = var.auto_scale_grp_info.health_check_grace_period
    health_check_type         = "EC2"

    protect_from_scale_in = true

    launch_template {
        id = aws_launch_template.scale_group_lauch_template.id
        version = "$Default"
    }

    //availability_zones = [ var.avail_zone ]
    //cloudformation uses  vpc_zone_identifier       and not availability_zones don't
    //  know if there is any difference
    vpc_zone_identifier       = data.aws_subnets.avail_zone_subnets.ids 

    tag {
        //this is needed, see https://registry.terraform.io/providers/hashicorp/aws/3.3.0/docs/resources/ecs_capacity_provider

        key                 = "AmazonECSManaged"
        value = true
        propagate_at_launch = true
    }

    tag {
        // from generated cloudformation

        key = "Name"
        value = "ECS Instance - ${var.ecs_cluster_name}"
        propagate_at_launch = true
    }
}