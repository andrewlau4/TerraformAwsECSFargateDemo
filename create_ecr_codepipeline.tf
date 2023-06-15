
module "ecs_codepipeline" {
    count = var.enable_code_pipeline ? 1 : 0

    source = "./ECRCodePipeline"

    ecs_cluster_name = var.ecs_cluster_name
    codestar_git_source_connection_name = var.codestar_git_source_connection_name
    source_repo_url = var.source_repo_url
    ecr_repo_url = module.ecs_repo.ecr_repo_url
    container_name = module.ecs_service_and_task.container_name
    service_name = module.ecs_service_and_task.fargate_service_name
}