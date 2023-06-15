locals {
    random_strings = split("-", uuid())
    bucket_suffix = local.random_strings[length(local.random_strings)-1]
    bucket_prefix = replace(var.ecs_cluster_name, "_", "-")
}

resource "aws_s3_bucket" "ecr_codepipeline_bucket" { 
  bucket = "${local.bucket_prefix}-codepipeline-bucket-${local.bucket_suffix}"
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


