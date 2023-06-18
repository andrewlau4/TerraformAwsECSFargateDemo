resource "aws_cloudwatch_log_group" "ecs_cluster_loggroup" {
  name = "${var.ecs_cluster_name}_loggroup"
}

//generated cloudformation has this:
resource "aws_service_discovery_http_namespace" "cluster_http_namespace" {
  name        = var.ecs_cluster_name
  description = "${var.ecs_cluster_name} http namespace"
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

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.cluster_http_namespace.arn
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

