variable "ecs_cluster_name" {
    type = string
}

variable "codestar_git_source_connection_name" {
    type = string
}

variable "codebuild_image" {
    type = string
    default = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
}

variable "source_repo_url" {
    type = string
}

variable "ecr_repo_url" {
    type = string
}

variable "image_definition_filename" {
    type = string
    //https://docs.aws.amazon.com/codepipeline/latest/userguide/ecs-cd-pipeline.html
    default = "imagedefinitions.json"
}

variable "container_name" {
    type = string
}

variable "service_name" {
    type = string
}