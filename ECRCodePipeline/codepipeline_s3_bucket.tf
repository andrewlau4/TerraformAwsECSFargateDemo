locals {
    bucket_prefix = replace(var.ecs_cluster_name, "_", "-")
}

resource "aws_s3_bucket" "ecr_codepipeline_bucket" { 
  bucket_prefix = "${local.bucket_prefix}-codepipeline-bucket-"
}

resource "aws_s3_bucket_ownership_controls" "ecr_codepipeline_bucket_ownrshp_ctrl" {
  bucket = aws_s3_bucket.ecr_codepipeline_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "ecr_codepipeline_bucket_acl" {
  bucket = aws_s3_bucket.ecr_codepipeline_bucket.id
  acl    = "private"
  depends_on = [ aws_s3_bucket_ownership_controls.ecr_codepipeline_bucket_ownrshp_ctrl ]
}


