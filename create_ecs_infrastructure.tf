module "autoscale_and_capacity_provider" {
    for_each = toset( local.az_to_deploy_ecs_service )

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
    service_deploy_to_subnet_ids = local.service_deploy_to_subnet_ids
    container_task_policy = file(var.file_path_to_container_policy_json)
    task_image = "${module.ecs_repo.ecr_repo_url}:latest"
}