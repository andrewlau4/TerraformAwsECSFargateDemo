resource "aws_ecs_task_definition" "my_ecs_task_definition" {
    family                   = var.task_family_name
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"

    cpu                      = "256"
    memory                   = "512"
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