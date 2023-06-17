resource "aws_ecs_service" "ecs_ec2_task_service" {
    count = var.enable_ec2_service ? 1 : 0

    name            = "${var.ecs_cluster_name}-ec2-service"
    cluster         = var.ecs_cluster_id
    task_definition = aws_ecs_task_definition.ecs_fargate_task_definition.arn
    desired_count   = var.ec2_service_desired_count

    network_configuration {
        subnets = var.service_deploy_to_subnet_ids
        security_groups = [ 
            aws_security_group.security_ingress.id,
            // need to add the default security group, it fix the error:
            //     unable to pull secrets or registry
            data.aws_security_group.default_security_group.id
        ]
    }

    dynamic "capacity_provider_strategy" {
        for_each = [for strategy in var.capacity_provider_strategy: strategy 
            if length(regexall("FARGATE", strategy.capacity_provider_name)) == 0 
            ]

        content {
            capacity_provider = capacity_provider_strategy.value.capacity_provider_name
            base = capacity_provider_strategy.value.base
            weight = capacity_provider_strategy.value.weight
        }
    }
  
}