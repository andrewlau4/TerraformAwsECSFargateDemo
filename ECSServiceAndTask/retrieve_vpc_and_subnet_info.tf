
data "aws_subnet" "service_subnets" {
  for_each = toset(var.service_deploy_to_subnet_ids)
  id = each.value
}

data "aws_region" "current_region" {}

locals {
  service_available_zones = toset([for i, subnet in data.aws_subnet.service_subnets: subnet.availability_zone])
  service_vpc_id = [for i, subnet in data.aws_subnet.service_subnets: subnet][0].vpc_id
  available_zones_comma_string = join(",", local.service_available_zones)
  container_name1 = "${var.task_family_name}-container1"
}