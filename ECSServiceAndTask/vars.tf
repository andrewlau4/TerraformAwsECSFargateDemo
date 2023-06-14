variable "task_family_name" {
    type = string
    default = "demo_ecr"
}

variable "task_image" {
    type = string
}

variable "ecs_cluster_name" {
    type = string
}

variable "service_deploy_to_subnet_ids" {
    type = list(string)
}

variable "container_task_policy" {
    type = string
}

variable "container_port_mappings" {
    type = list(number)
    default = [ 80 ]
}