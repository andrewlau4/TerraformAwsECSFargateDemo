
data "aws_iam_policy" "AWSCodeDeployPolicy" {
    name = "AWSCodeDeployRole"
}

data "aws_iam_policy" "AWSCodePipelinePolicy" {
    name = "AWSCodePipeline_FullAccess"
}

data "aws_iam_policy" "AWSCloudWatchFullAccessPolicy" {
    name = "CloudWatchFullAccess"
}




data "aws_iam_policy_document" "ecr_codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecr_codebuild_role" {
  name               = "${var.ecs_cluster_name}_ecr_codebuild_role"
  assume_role_policy = data.aws_iam_policy_document.ecr_codebuild_assume_role.json
}

data "aws_iam_policy_document" "ecr_codebuild_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.ecr_codepipeline_bucket.arn,
      "${aws_s3_bucket.ecr_codepipeline_bucket.arn}/*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
    	"ecr:PutImageTagMutability",
		"ecr:GetAuthorizationToken",
		"ecr:DescribeRepositories",
		"ecr:ReplicateImage",
        "ecs:ListTaskDefinitions",
		"ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecr_codebuild_role_policy" {
  role   = aws_iam_role.ecr_codebuild_role.name
  policy = data.aws_iam_policy_document.ecr_codebuild_policy_document.json
}
resource "aws_iam_role_policy_attachment" "ecr_codebuild_role_cloudwatch_policy" {
  role   = aws_iam_role.ecr_codebuild_role.name
  policy_arn = data.aws_iam_policy.AWSCloudWatchFullAccessPolicy.arn
}





resource "aws_iam_role" "ecr_codepipeline_role" {

    name = "${var.ecs_cluster_name}_ecr_codepipeline_role"

    assume_role_policy = jsonencode(
        {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service":  "codepipeline.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
            }
        ]
        }
    )

    inline_policy {
        name = "demo_ecr_serverless_codepipeline_role_policy1"

        policy = jsonencode({
            "Version": "2012-10-17",
            "Statement": [

                {
                    "Action": [
                        "iam:PassRole"
                    ],
                    "Resource": "*",
                    "Effect": "Allow",
                    "Condition": {
                        "StringEqualsIfExists": {
                            "iam:PassedToService": [
                                "cloudformation.amazonaws.com",
                                "elasticbeanstalk.amazonaws.com",
                                "ec2.amazonaws.com",
                                "ecs-tasks.amazonaws.com"
                            ]
                        }
                    }
                },
                {
                    "Action": [
                        "codecommit:CancelUploadArchive",
                        "codecommit:GetBranch",
                        "codecommit:GetCommit",
                        "codecommit:GetRepository",
                        "codecommit:GetUploadArchiveStatus",
                        "codecommit:UploadArchive"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                },
                {
                    "Action": [
                        "codedeploy:CreateDeployment",
                        "codedeploy:GetApplication",
                        "codedeploy:GetApplicationRevision",
                        "codedeploy:GetDeployment",
                        "codedeploy:GetDeploymentConfig",
                        "codedeploy:RegisterApplicationRevision"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                },
                {
                    "Action": [
                        "codestar-connections:UseConnection"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                },
                {
                    "Action": [
                        "elasticbeanstalk:*",
                        "ec2:*",
                        "elasticloadbalancing:*",
                        "autoscaling:*",
                        "cloudwatch:*",
                        "s3:*",
                        "sns:*",
                        "cloudformation:*",
                        "rds:*",
                        "sqs:*",
                        "ecs:*"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                },
                {
                    "Action": [
                        "lambda:InvokeFunction",
                        "lambda:ListFunctions"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                },
                {
                    "Action": [
                        "opsworks:CreateDeployment",
                        "opsworks:DescribeApps",
                        "opsworks:DescribeCommands",
                        "opsworks:DescribeDeployments",
                        "opsworks:DescribeInstances",
                        "opsworks:DescribeStacks",
                        "opsworks:UpdateApp",
                        "opsworks:UpdateStack"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                },
                {
                    "Action": [
                        "cloudformation:CreateStack",
                        "cloudformation:DeleteStack",
                        "cloudformation:DescribeStacks",
                        "cloudformation:UpdateStack",
                        "cloudformation:CreateChangeSet",
                        "cloudformation:DeleteChangeSet",
                        "cloudformation:DescribeChangeSet",
                        "cloudformation:ExecuteChangeSet",
                        "cloudformation:SetStackPolicy",
                        "cloudformation:ValidateTemplate"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                },
                {
                    "Action": [
                        "codebuild:BatchGetBuilds",
                        "codebuild:StartBuild",
                        "codebuild:BatchGetBuildBatches",
                        "codebuild:StartBuildBatch"
                    ],
                    "Resource": "*",
                    "Effect": "Allow"
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "devicefarm:ListProjects",
                        "devicefarm:ListDevicePools",
                        "devicefarm:GetRun",
                        "devicefarm:GetUpload",
                        "devicefarm:CreateUpload",
                        "devicefarm:ScheduleRun"
                    ],
                    "Resource": "*"
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "servicecatalog:ListProvisioningArtifacts",
                        "servicecatalog:CreateProvisioningArtifact",
                        "servicecatalog:DescribeProvisioningArtifact",
                        "servicecatalog:DeleteProvisioningArtifact",
                        "servicecatalog:UpdateProduct"
                    ],
                    "Resource": "*"
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "cloudformation:ValidateTemplate"
                    ],
                    "Resource": "*"
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "ecr:DescribeImages"
                    ],
                    "Resource": "*"
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "states:DescribeExecution",
                        "states:DescribeStateMachine",
                        "states:StartExecution"
                    ],
                    "Resource": "*"
                },
                {
                    "Effect": "Allow",
                    "Action": [
                        "appconfig:StartDeployment",
                        "appconfig:StopDeployment",
                        "appconfig:GetDeployment"
                    ],
                    "Resource": "*"
                },



                {
                    "Sid": "CodepipelineFromVisualEditor0",
                    "Effect": "Allow",
                    "Action": "logs:*",
                    "Resource": "*"
                }
            ]
        })
    }
}
resource "aws_iam_role_policy_attachment" "ecr_serverless_iam_for_codepipeline_role_policy_attachment" {
    role = aws_iam_role.ecr_codepipeline_role.name
    policy_arn = data.aws_iam_policy.AWSCodePipelinePolicy.arn
}


