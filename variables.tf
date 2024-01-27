variable "aws_region" {
  type        = string
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1" # Replace with your desired default region
}

# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------


variable "ssh_allowed_ip" {
  type    = string
  default = "72.255.40.255/32"
}



# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------



variable "project_name" {
  type    = string
  default = "Requip"
}

variable "environment" {
  type    = string
  default = "Production"
}

variable "account_id" {
  type    = string
  default = "553763657971"
}

# ----------------------------------------------------------------
# --------------- AWS PARAMETER STORE VARIABLES ------------------
# ----------------------------------------------------------------

variable "parameter_store_name" {
  type        = string
  description = "Name of the AWS SSM Parameter Store"
  default     = "/requip/be"
}

# ----------------------------------------------------------------
# --------------- AWS CodePipeline VARIABLES ---------------------
# ----------------------------------------------------------------

variable "FullRepositoryId" {
  type        = string
  description = "Repository used in code pipeline"
  default     = "rafay-tariq/EarthAdventureBackend"
}

variable "BranchName" {
  type        = string
  description = "Select branch from repository "
  default     = "main"
}

variable "s3BucketNameForArtifacts" {
  type        = string
  description = "S3 bucket to store the source code artifacts"
  default     = "example-artifact-bucket-some-more-me-random-meeeee"
}

variable "CodeStarConnectionArn" {
  type        = string
  description = "Existing connection of github/bitbucket with AWS Coestart"
  default     = "arn:aws:codestar-connections:us-east-1:553763657971:connection/99b46435-d2be-482b-b00c-c449716f1cde"
}
