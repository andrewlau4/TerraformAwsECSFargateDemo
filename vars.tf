variable "ecs_cluster_name" {
    type = string
    default = "demo-ecs-cluster"
}

variable "num_of_default_avail_zones_to_use" {  
    type = number
    default = 2
    description = "choose a number of default availability zones to use for ecs service deployment"
}

variable "availability_zones" {
    type = list(string)
    default = [ "us-east-1a" ]
    description = "this value is IGNORED if default_avail_zones_to_use > 0, otherwise, specified the availability zones here, such as us-east-1, us-east-2, ... etc"
}
