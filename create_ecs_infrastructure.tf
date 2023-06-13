module "autoscale_and_capacity_provider" {
    for_each = { for index, avail_zone in local.az_to_deploy_capacity_provider: index => avail_zone }

    source = "./ECSAutoScaleGrpCapacityProvider"

    ecs_cluster_name = var.ecs_cluster_name
    avail_zone = each.value
    name_suffix = "_${each.value}"
}

module "ecs_infrastructure" {
    source = "./ECSCluster"

    ecs_cluster_name = var.ecs_cluster_name
    ecs_cluster_capacity_provider_names = [ for i, value in module.autoscale_and_capacity_provider: value.ecs_capacity_provider_name ]
}

module "ecs_repo" {
    source = "./ECRRepository"

    ecr_repo_name = "${var.ecs_cluster_name}_ecr_repo"
}