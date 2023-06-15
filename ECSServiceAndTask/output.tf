output "fargate_service_name" {
    value = aws_ecs_service.ecs_fargate_task_service.name
}

output "ec2_service_name" {
    value = var.enable_ec2_service ? aws_ecs_service.ecs_ec2_task_service[0].name : null
}

output "container_name" {
    value = local.container_name1
}