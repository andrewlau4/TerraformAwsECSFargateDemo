output "az_to_deploy_autoscale_capacity_provider" {
    value = local.az_to_deploy_capacity_provider
}

output "subnet_ids_to_deploy_autoscale_capacity_provider" {
  value =  flatten( [ for az_name in local.az_to_deploy_capacity_provider: 
        lookup(local.zone_id_to_subnet_array_map, lookup(local.zone_name_to_id_map, az_name)) ])
}