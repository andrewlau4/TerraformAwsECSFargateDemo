variable "ecs_cluster_name" {
    type = string
    default = "demo-ecs-cluster"
}

variable "num_of_default_avail_zones_to_use" {  
    type = number
    default = 2
    description = "choose a number of default availability zones to use for ecs service deployment"
}

// this value is ignored if above is > 0
variable "avail_zones_to_deploy_autoscale_capacity_provider" {
    type = list(string)
    default = [ "us-east-1a" ]
    description = "this value is IGNORED if default_avail_zones_to_use > 0, otherwise, specified the availability zones here, such as us-east-1, us-east-2, ... etc"
}

variable "file_path_to_container_policy_json" {
    type = string
    default = "example_container_permissions.json"
}

variable "capacity_provider_weights" {
    type = list(object({
        base = number
        weight = number
    }))
    default = [{
        base = 0
        weight = 1
    }]
}

variable "enable_ec2_service" {
    type = bool
    default = false
}

variable "codestar_git_source_connection_name" {
    type = string
    default = "aws_ecs_demo_docker_img"
}

variable "source_repo_url" {
    type = string
    default = "andrewlau4/AwsECSDemoDockerImage"
}

variable "enable_code_pipeline" {
    type = bool
    default = true
}

variable "codepipeline_deploy_to_fargate_or_ec2" {
    type = string
    default = "FARGATE"  // can be EC2
}