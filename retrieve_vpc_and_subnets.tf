data "aws_availability_zones" "account_default_az" {
    state = "available"
}

data "aws_vpc" "default_vpc" {
    default = true
}

data "aws_subnets" "default_subnets" {
    filter {
        name   = "vpc-id"
        values = [data.aws_vpc.default_vpc.id]
    }
}

data "aws_subnet" "default_subnets_info" {
    for_each = toset(data.aws_subnets.default_subnets.ids)
    id = each.value
}

locals {
    useAccountDefaultAZ = (var.num_of_default_avail_zones_to_use <= 0)
    lengthDefaultAccAZ = local.useAccountDefaultAZ ? length(data.aws_availability_zones.account_default_az.names) : 0

    available_zones = ( local.useAccountDefaultAZ 
        ? slice(data.aws_availability_zones.account_default_az.names, 
            0, min(var.num_of_default_avail_zones_to_use, local.lengthDefaultAccAZ) ) 
        : var.availability_zones )

    //zone name to zone id map
    zone_name_to_id_map = { for az_name in local.available_zones: 
        az_name =>
            data.aws_availability_zones.account_default_az.zone_ids[
                index(data.aws_availability_zones.account_default_az.names, az_name)]
        }

    // create a map of zone_id => [ subnet_ids,..]
    //   the '...' syntax means 'group by' see: https://developer.hashicorp.com/terraform/language/expressions/for
    zone_id_to_subnet_array_map = { for subnet in data.aws_subnet.default_subnets_info 
                            : subnet.availability_zone_id => 
                                subnet.id... }
}