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

variable "ecs_cluster_id" {
    type = string
}

variable "service_desired_count" {
    type = number
    default = 1
}

variable "service_deploy_to_subnet_ids" {
    type = list(string)
}

variable "assign_public_ip_to_service" {
    type = bool
    default = true
}

variable "container_task_policy" {
    type = string
}

variable "container_port_mappings" {
    type = list(number)
    default = [ 80 ]
}

//this article explains the below 2 numbers
// https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html
variable "container_cpu" {
    type = number
    default = 256
}

variable "container_memory" {
    type = number
    default = 512
}

variable "service_ingress_allow" {
    type = list(object({
        from_port = number
        to_port = number
        cidr_ipv4 = string
        cidr_ipv6 = string
        ip_protocol = string
    }))
    default = [
    {
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
      from_port = 80
      ip_protocol = "tcp"
      to_port = 80
    },
    {
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
      from_port = 443
      ip_protocol = "tcp"
      to_port = 443
    }]
}

variable "service_egress_allow" {
    type = list(object({
        from_port = number
        to_port = number
        cidr_ipv4 = string
        cidr_ipv6 = string
        ip_protocol = string
    }))
    default = [
    {
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
      from_port = 0
      ip_protocol = "tcp"
      to_port = 0
    },
    {
      cidr_ipv4 = "0.0.0.0/0"
      cidr_ipv6 = "::/0"
      from_port = 0
      ip_protocol = "udp"
      to_port = 0
    }    
    
    ]
}

variable "capacity_provider_strategy" {
    type = list(object({
        capacity_provider_name = string
        base = number
        weight = number
    }))
}

variable "enable_ec2_service" {
    type = bool
}
