output "az_to_deploy_autoscale_capacity_provider" {
  value = local.az_to_deploy_ecs_service
}

output "subnet_ids_to_deploy_autoscale_capacity_provider" {
  value =  local.service_deploy_to_subnet_ids
}