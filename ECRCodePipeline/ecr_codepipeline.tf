data "aws_codestarconnections_connection" "source_code_connection" {
    name = var.codestar_git_source_connection_name
}


resource "aws_codepipeline" "ecr_codepipeline" {

    name = "${var.ecs_cluster_name}_ecr_codepipeline"

    role_arn = aws_iam_role.ecr_codepipeline_role.arn

    artifact_store {
        location = aws_s3_bucket.ecr_codepipeline_bucket.bucket
        type     = "S3"
    }

    stage {
        name = "SourceStage"

        action {
            name = "SourceAction"

            category = "Source"

            owner = "AWS"

            provider = "CodeStarSourceConnection"
            version  = "1"

            output_artifacts = ["source_output"]

            namespace = "source_output_variables_namespace"

            configuration = {
                ConnectionArn    = data.aws_codestarconnections_connection.source_code_connection.id
                FullRepositoryId = var.source_repo_url

                BranchName    = "main"
                DetectChanges = true
            }
        }
    }

    stage {
        name = "CodeBuildStage"

        action {
            name             = "CodeBuild"
            category         = "Build"
            owner            = "AWS"
            provider         = "CodeBuild"
            input_artifacts  = ["source_output"]
            output_artifacts = ["code_build_output"]
            version          = "1"

            configuration = {
                ProjectName = aws_codebuild_project.for_codepipeline_ecr_codebuild.name

                PrimarySource = "source_outputput"
            }
        }
    }

    stage {
        name = "ECSDeploy"

        action {
            run_order = 1

            name     = "ECSDeployServiceAction"
            category = "Deploy"
            owner    = "AWS"
            provider = "ECS"
            version  = "1"

            input_artifacts = ["code_build_output"]

            configuration = {
                ClusterName = var.ecs_cluster_name

                ServiceName = var.service_name

                FileName = var.image_definition_filename
            }

        }

    }

}
