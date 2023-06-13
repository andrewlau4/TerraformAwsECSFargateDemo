module "autoscale_and_capacity_provider" {
    for_each = { for index, avail_zone in local.az_to_deploy_capacity_provider: index => avail_zone }

    source = "./ECSAutoScaleGrpCapacityProvider"

    ecs_cluster_name = var.ecs_cluster_name
    avail_zone = each.value
    name_suffix = each.value
}