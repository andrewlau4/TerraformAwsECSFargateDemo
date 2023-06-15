resource "aws_codebuild_project" "for_codepipeline_ecr_codebuild" {
  name          = "${var.ecs_cluster_name}_for_codepipeline_ecr_codebuild"
  description   = "${var.ecs_cluster_name}_for_codepipeline_demo_ecr_codebuild_project"
  build_timeout = "5"

  service_role  = aws_iam_role.ecr_codebuild_role.arn

  artifacts {
     type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"


    privileged_mode = true

    environment_variable {
      name  = "ECR_REPO_URL"
      value = var.ecr_repo_url
    }

    environment_variable {
      name  = "ECR_SERVER"
      value = split("/", var.ecr_repo_url)[0]
    }

    environment_variable {
      name  = "ECR_CONTAINER"
      value = var.container_name
    }

    environment_variable {
      name = "S3_BUCKET"
      value = aws_s3_bucket.ecr_codepipeline_bucket.bucket
    }
  }

  source {
    type            = "CODEPIPELINE"
  }

  tags = {
    SERVERLESS_COURSE = "Serverless_Course_chap143_for_codepipeline"
  }
}
