variable "ecs_cluster_capacity_provider_names" {
    type = list(string)
    default = []
}

variable "ecs_cluster_name" {
    type = string
}

variable "default_capacity_provider_strategy" {
    type = object({
        base              = number
        weight            = number
        capacity_provider_name = string
    })
    default = {
        base              = 0
        weight            = 1
        capacity_provider_name = "FARGATE"
    }
}