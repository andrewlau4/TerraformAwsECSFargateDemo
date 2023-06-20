resource "aws_ecs_task_definition" "ecs_fargate_task_definition" {
    family                   = "${var.task_family_name}_fargate"
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    //https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#network_mode
    //  only the Amazon ECS-optimized AMI, other Amazon Linux variants with the ecs-init package, or AWS Fargate infrastructure support the awsvpc network mode.
    //  If using the Fargate launch type, the awsvpc network mode is required. If using the EC2 launch type, the allowable network mode depends on the underlying EC2 instance's operating system. If Linux, any network mode can be used.
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
    family                   = "${var.task_family_name}_ec2"
    task_role_arn            = aws_iam_role.ecs_task_role.arn
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    //see https://www.youtube.com/watch?v=AaxG9vRW-4w
    // it seems it need to be bridge mode, or left blank
    //https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#network_mode
    //  only the Amazon ECS-optimized AMI, other Amazon Linux variants with the ecs-init package, or AWS Fargate infrastructure support the awsvpc network mode.
    //  If using the Fargate launch type, the awsvpc network mode is required. If using the EC2 launch type, the allowable network mode depends on the underlying EC2 instance's operating system. If Linux, any network mode can be used.
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
