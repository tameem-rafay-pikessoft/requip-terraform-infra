variable "aws_region" {
  type        = string
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1" # Replace with your desired default region
}
# ----------------------------------------------------------------
# ---------------------- AWS Resource Tags -----------------------
# ----------------------------------------------------------------

variable "common_tags" {
  type = map(string)
  default = {
    Project_Name = var.project_name
    Environment  = var.environment
    Account_ID   = var.account_id
    Region       = var.aws_region
  }
}

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