module "autoscale_and_capacity_provider" {
    for_each = { for index, avail_zone in local.az_to_deploy_capacity_provider: index => avail_zone }

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
    service_deploy_to_subnet_ids = flatten( [ for az_name in local.az_to_deploy_capacity_provider: 
        lookup(local.zone_id_to_subnet_array_map, lookup(local.zone_name_to_id_map, az_name)) ])
    container_task_policy = file(var.file_path_to_container_policy_json)
}