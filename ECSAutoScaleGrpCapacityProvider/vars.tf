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

variable "capacity_provider_info" {
    type = object({
        maximum_scaling_step_size = number
        minimum_scaling_step_size = number
        target_capacity = number
    })
    default = {
        maximum_scaling_step_size = 2
        minimum_scaling_step_size = 1
        target_capacity           = 100
    }
}    

variable "ec2_managed_termination_protection" {
    type = bool
}