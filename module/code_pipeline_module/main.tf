# Create CodeDeploy Application
resource "aws_codedeploy_app" "example_app" {
  name     = "example-application"
  compute_platform = "Server"  # For EC2 instances
}


# Create IAM role for AWS CodeDeploy
resource "aws_iam_role" "codedeploy_role" {
  name               = "codedeploy-service-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "codedeploy.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}


# Attach IAM policy granting necessary permissions for AWS CodeDeploy to the IAM role
resource "aws_iam_policy_attachment" "codedeploy_policy_attachment" {
  name       = "codedeploy-policy-attachment"
  roles      = [aws_iam_role.codedeploy_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"  # This is the AWS managed policy for CodeDeploy
}


# Create CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "example_group" {
  app_name              = aws_codedeploy_app.example_app.name
  deployment_group_name = "example-deployment-group"
  deployment_config_name = "CodeDeployDefault.OneAtATime"  # In-place deployment strategy
  service_role_arn      = aws_iam_role.codedeploy_role.arn  # Use the newly created IAM role

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  ec2_tag_filter {
    key   = "Name"
    value = "example-tag"
    type  = "KEY_AND_VALUE"
  }
}

# Create IAM role for AWS CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "example-codepipeline-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
    {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "codepipeline.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }
    ]
  })
}

# Define IAM policy allowing necessary actions on the S3 bucket
resource "aws_iam_policy" "codepipeline_s3_policy" {
  name        = "codepipeline-s3-policy"
  description = "IAM policy for CodePipeline to upload artifacts to S3 bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": "*" // Replace '*' with the ARN of your S3 bucket if you want to restrict access to a specific bucket
      }
    ]
  })
}

# Define IAM policy allowing necessary actions on CodeDeploy resources
resource "aws_iam_policy" "codedeploy_policy" {
  name        = "codedeploy-policy"
  description = "IAM policy for CodePipeline to deploy applications using CodeDeploy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "codedeploy:*",
        Resource = "*"  // Allow CreateDeployment action on all CodeDeploy resources
      }
    ]
  })
}

# Attach IAM policy to IAM role associated with CodePipeline
resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codedeploy_policy.arn
}

# Attach IAM policy to IAM role
resource "aws_iam_role_policy_attachment" "codepipeline_s3_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_s3_policy.arn
}

resource "aws_iam_role_policy" "codepipeline_assume_role_policy" {
  name   = "codepipeline-assume-role-policy"
  role   = aws_iam_role.codepipeline_role.name

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action   = "codestar-connections:UseConnection",
        Resource  = "*" // Replace with the ARN of the CodeStar Connection's IAM role
      }
    ]
  })
}

# Attach AWS managed policy for CodePipeline to the IAM role
resource "aws_iam_policy_attachment" "codepipeline_attachment" {
  name       = "example-codepipeline-policy-attachment"
  roles      = [aws_iam_role.codepipeline_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}
resource "aws_s3_bucket" "store_pipeline_artifacts_bucket" {
  bucket = "example-artifact-bucket-some-more-me-random-meeeee"
  force_destroy = true # Delete the bucket even if the Bucket is not destroyed
}

# Create CodePipeline
resource "aws_codepipeline" "example_pipeline" {
  name     = "example-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn
  tags = var.tags
  artifact_store {
    location = aws_s3_bucket.store_pipeline_artifacts_bucket.bucket
    type     = "S3"
  }


  stage {
    name = "Source-Stage"

    action {
        
    #   owner            = "ThirdParty"
      name             = "SourceAction"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
            BranchName = "main"
            FullRepositoryId = "rafay-tariq/EarthAdventureBackend"
            ConnectionArn = "arn:aws:codestar-connections:us-east-1:553763657971:connection/99b46435-d2be-482b-b00c-c449716f1cde"
            OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployAction"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["SourceArtifact"]
      configuration = {
        ApplicationName          = aws_codedeploy_app.example_app.name
        DeploymentGroupName     = aws_codedeploy_deployment_group.example_group.deployment_group_name
      }
    }
  }
}