variable "tags" {
  type    = map(string)
  default = {}
}

variable "FullRepositoryId" {
  type        = string
  description = "Repository used in code pipeline"
}

variable "BranchName" {
  type        = string
  description = "Select branch from repository "
}

variable "CodeStarConnectionArn" {
  type        = string
  description = "Existing connection of github/bitbucket with AWS Coestart"
}