resource "aws_ecs_task_definition" "ecs_task_definition" {
    family                   = var.task_family_name
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"

    cpu                      = var.container_cpu
    memory                   = var.container_memory
    requires_compatibilities = ["FARGATE"]

    container_definitions = templatefile("${path.module}/container_definition_template.tfpl",
        {
            task_image = var.task_image,
            container_name = local.container_name1,
            task_log_region = data.aws_region.current_region.name
            ecs_cluster_name = var.ecs_cluster_name
            container_port_mappings = var.container_port_mappings
        }
    )

}


resource "aws_ecs_service" "ecs_task_service" {
    name            = "${var.ecs_cluster_name}-service"
    cluster         = var.ecs_cluster_id
    task_definition = aws_ecs_task_definition.ecs_task_definition.arn
    desired_count   = var.service_desired_count

    network_configuration {
        subnets = var.service_deploy_to_subnet_ids
        assign_public_ip = var.assign_public_ip_to_service

        security_groups = [ 
            aws_security_group.security_ingress.id,
            // need to add the default security group, it fix the error:
            //     unable to pull secrets or registry
            data.aws_security_group.default_security_group.id
        ]
    }

    capacity_provider_strategy {
        capacity_provider = "FARGATE"
        base = 0
        weight = 1
    }
  
}