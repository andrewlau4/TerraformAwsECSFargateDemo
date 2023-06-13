resource "aws_cloudwatch_log_group" "ecs_cluster_loggroup" {
  name = "${var.ecs_cluster_name}_loggroup"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name

  configuration {
    execute_command_configuration {
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.ecs_cluster_loggroup.name
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "my_ecs_cluster_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = concat(["FARGATE", "FARGATE_SPOT"], var.ecs_cluster_capacity_provider_names[*])

  default_capacity_provider_strategy {
    base              = var.default_capacity_provider_strategy.base
    weight            = var.default_capacity_provider_strategy.weight
    capacity_provider = var.default_capacity_provider_strategy.capacity_provider_name
  }

}

