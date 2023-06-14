
data "aws_subnet" "service_subnets" {
  for_each = toset(var.service_deploy_to_subnet_ids)
  id = each.value
}

locals {
    service_available_zones = toset([for i, subnet in data.aws_subnet.service_subnets: subnet.availability_zone])
}