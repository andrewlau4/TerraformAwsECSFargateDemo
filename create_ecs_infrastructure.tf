module "autoscale_and_capacity_provider" {
    for_each = { for index, value in local.az_to_deploy_ecs_service: index => value}

    source = "./ECSAutoScaleGrpCapacityProvider"

    ecs_cluster_name = var.ecs_cluster_name
    avail_zone = each.value
    name_suffix = "_${each.value}"
}

module "ecs_cluster" {
    source = "./ECSCluster"

    ecs_cluster_name = var.ecs_cluster_name
    ecs_cluster_capacity_provider_names = [ for i, value in module.autoscale_and_capacity_provider: value.ecs_capacity_provider_name ]
}

module "ecs_repo" {
    source = "./ECRRepository"

    ecr_repo_name = "${var.ecs_cluster_name}_ecr_repo"
}

module "ecs_service_and_task" {
    source = "./ECSServiceAndTask"

    ecs_cluster_name = var.ecs_cluster_name
    ecs_cluster_id = module.ecs_cluster.ecs_cluster_id
    service_deploy_to_subnet_ids = local.service_deploy_to_subnet_ids
    container_task_policy = file(var.file_path_to_container_policy_json)
    task_image = "${module.ecs_repo.ecr_repo_url}:latest"
    enable_ec2_service = var.enable_ec2_service

    capacity_provider_strategy = concat(
        [
            {
                capacity_provider_name = "FARGATE"
                base = 0
                weight =  1
            },
            {
                capacity_provider_name = "FARGATE_SPOT"
                base = 0
                weight =  1
            }

        ],
        [
            for index, cp in module.autoscale_and_capacity_provider:
                {
                     capacity_provider_name = cp.ecs_capacity_provider_name
                     base = element(var.capacity_provider_weights, index).base
                     weight = element(var.capacity_provider_weights, index).weight
                }
        ]
    )
}

module "ecs_codepipeline" {
    source = "./ECRCodePipeline"

    ecs_cluster_name = var.ecs_cluster_name
    codestar_git_source_connection_name = var.codestar_git_source_connection_name
    source_repo_url = var.source_repo_url
    ecr_repo_url = module.ecs_repo.ecr_repo_url
    container_name = module.ecs_service_and_task.container_name
}