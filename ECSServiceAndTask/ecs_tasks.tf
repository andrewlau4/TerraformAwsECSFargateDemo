resource "aws_ecs_task_definition" "ecs_fargate_task_definition" {
    family                   = var.task_family_name
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    network_mode             = "awsvpc"

    cpu                      = var.container_cpu
    memory                   = var.container_memory
    requires_compatibilities = ["FARGATE"]

    container_definitions = templatefile("${path.module}/fargate_container_definition_template.tfpl",
        {
            task_image = var.task_image,
            container_name = "${local.container_name1}fargate",
            task_log_region = data.aws_region.current_region.name,
            ecs_cluster_name = var.ecs_cluster_name,
            container_port_mappings = var.container_port_mappings
        }
    )

}

resource "aws_ecs_task_definition" "ecs_ec2_task_definition" {
    family                   = var.task_family_name
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    //see https://www.youtube.com/watch?v=AaxG9vRW-4w
    // it seems it need to be bridge mode, or left blank
    //network_mode             = "awsvpc"
    //network_mode             = "bridge"

    //cpu                      = var.container_cpu
    //memory                   = var.container_memory


    requires_compatibilities = ["EC2"]

    //see https://www.youtube.com/watch?v=AaxG9vRW-4w
    container_definitions = templatefile("${path.module}/ec2_container_definition_template.tfpl",
        {
            task_image = var.task_image,
            container_name = "${local.container_name1}ec2",
            task_log_region = data.aws_region.current_region.name,
            ecs_cluster_name = var.ecs_cluster_name,
            container_port_mappings = var.container_port_mappings,
            memory_reservation = 128
        }
    )

}
