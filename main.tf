provider "aws" {
  region = var.aws_region
}

module "ec2_instance_module" {
  source        = "./module/ec2_instance_module"
  ami           = "ami-0a3c3a20c09d6f377" # ami: aws linux machine
  instance_type = "t2.micro"
  instance_name = "production_instance"
  tags          = var.common_tags
}

module "parameter_store_module" {
  source               = "./module/parameter_store_module"
  parameter_store_name = var.parameter_store_name
  tags                 = var.common_tags
}

module "code_pipeline_module" {
  source                = "./module/code_pipeline_module"
  instance_name         = module.ec2_instance_module.instance_details.instance_name
  tags                  = var.common_tags
  FullRepositoryId      = var.FullRepositoryId
  BranchName            = var.BranchName
  CodeStarConnectionArn = var.CodeStarConnectionArn
}




# ----------------------------------------------------------------
# ---------------------- OUTPUT SECTION --------------------------
# ----------------------------------------------------------------


output "module_ec2_instance_details" {
  value = module.ec2_instance_module.instance_details
}

# output "private_key" {
#   value     = tls_private_key.example.private_key_pem
#   sensitive = true
# }
