resource "aws_ecs_capacity_provider" "ecs_auto_scaling_capacity_provider" {

  name = "capacity_provider${var.name_suffix}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_auto_scaling.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = var.capacity_provider_info.maximum_scaling_step_size
      minimum_scaling_step_size = var.capacity_provider_info.minimum_scaling_step_size
      status                    = "ENABLED"
      target_capacity           = var.capacity_provider_info.target_capacity
    }
  }
}