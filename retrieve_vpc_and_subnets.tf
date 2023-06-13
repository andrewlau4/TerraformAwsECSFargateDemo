data "aws_availability_zones" "account_default_az" {
  state = "available"
}

locals {
  useAccountDefaultAZ = (var.num_of_default_avail_zones_to_use <= 0)
  lengthDefaultAccAZ = local.useAccountDefaultAZ ? length(data.aws_availability_zones.account_default_az.names) : 0

  available_zones = ( local.useAccountDefaultAZ 
    ? slice(data.aws_availability_zones.account_default_az.names, 
        0, min(var.num_of_default_avail_zones_to_use, local.lengthDefaultAccAZ) ) 
    : var.availability_zones )

  zone_name_to_id_map = { for az_name in local.available_zones: 
    az_name =>
        data.aws_availability_zones.account_default_az.zone_ids[
            index(data.aws_availability_zones.account_default_az.names, az_name)]
   }
}