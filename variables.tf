variable "aws_region" {
  type        = string
  description = "AWS region where resources will be provisioned"
  default     = "us-east-1" # Replace with your desired default region
}






# ----------------------------------------------------------------
# ----------------- AWS CODE PIPELINE VARIABLES ------------------
# ----------------------------------------------------------------






# ----------------------------------------------------------------
# --------------- AWS PARAMETER STORE VARIABLES ------------------
# ----------------------------------------------------------------

variable "parameter_store_name" {
  type        = string
  description = "Name of the AWS SSM Parameter Store"
  default     = "/requip/be"
}