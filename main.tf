provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

resource "aws_ecr_repository" "my_repository" {
  name = "my-repository"  # Replace with your desired repository name
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"  # Replace with your desired role name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess"

  role = aws_iam_role.codebuild_role.name
}

resource "aws_codebuild_project" "my_project" {
  name        = "my-project"  # Replace with your desired project name
  description = "My CodeBuild project"

  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
  }

  source {
    type            = "CODEPIPELINE"
    buildspec       = "buildspec.yml"
    git_clone_depth = 1
  }
}
