provider "aws" {
  region = var.aws_region
}

module "ec2_instance_module" {
  source               = "./module/ec2_instance_module"
  ami                  = "ami-0a3c3a20c09d6f377"
  instance_type        = "t2.micro"
}

module "parameter_store_module" {
  source = "./module/parameter_store_module"
  parameter_store_name   = var.parameter_store_name
}


