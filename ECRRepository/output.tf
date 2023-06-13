output "ecr_repo_arn" {
  value = aws_ecr_repository.ecs_repo.arn
}

output "ecr_repo_id" {
  value = aws_ecr_repository.ecs_repo.registry_id
}

output "ecr_repo_url" {
  value = aws_ecr_repository.ecs_repo.repository_url 
}

