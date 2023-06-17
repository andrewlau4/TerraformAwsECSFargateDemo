data "aws_ami" "ecs_ec2_image" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = [ var.ami_image ]
    }

}

resource "aws_launch_template" "scale_group_lauch_template" {
    name_prefix   = "${var.ecs_cluster_name}_auto_scaling_template${var.name_suffix}"
    image_id      = data.aws_ami.ecs_ec2_image.id
    instance_type = var.ami_instance_type

    iam_instance_profile {
      arn = aws_iam_instance_profile.ecs_ec2_lauch_template_instance_profile.arn
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

    availability_zones = [ var.avail_zone ]

    tag {
        //this is needed, see https://registry.terraform.io/providers/hashicorp/aws/3.3.0/docs/resources/ecs_capacity_provider

        key                 = "AmazonECSManaged"
        value = true
        propagate_at_launch = true
    }
}