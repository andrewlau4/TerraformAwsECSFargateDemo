variable "ami_image" {
    type = string
    default = "al2023-ami-2023.0.2023*-x86_64*"
}

variable "ami_instance_type" {
    type = string
    default = "t2.nano" 
}

variable "ecs_cluster_name" {
    type = string
}

variable "avail_zone" {
    type = string
}

variable "name_suffix" {
    type = string
}

variable "auto_scale_grp_info" {
    type = object({
        max_size = number
        min_size = number
        desired_capacity = number
        health_check_grace_period = number
    })
    default = {
        max_size = 2
        min_size = 0
        desired_capacity = 0
        health_check_grace_period = 300
    }
}

variable "capacity_weight" {
    type = object({
      base = number
      weight = number
    })
    default = {
        base = 0
        weight = 1
    }
    description = "see https://www.youtube.com/watch?v=Vb_4wAEcfpQ 15:05"
}