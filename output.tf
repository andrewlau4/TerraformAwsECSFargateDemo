output "az_to_deploy_autoscale_capacity_provider" {
  value = local.az_to_deploy_ecs_service
}

output "subnet_ids_to_deploy_autoscale_capacity_provider" {
  value =  local.service_deploy_to_subnet_ids
}

output "fargate_service_name" {
  value =  module.ecs_service_and_task.fargate_service_name
}

output "ec2_service_name" {
  value =  module.ecs_service_and_task.ec2_service_name
}