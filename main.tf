provider "aws" {
  region = var.aws_region
}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "example_key_pair" {
  key_name   = "example-key"
  public_key = tls_private_key.example.public_key_openssh
  # public_key = file("~/.ssh/id_rsa.pub") # Replace with the path to your public key file
  provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.example.private_key_pem}' > ./private-key.pem"
  }
}

module "ec2_instance_module" {
  source        = "./module/ec2_instance_module"
  ami           = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  ec2_key_name  = aws_key_pair.example_key_pair.key_name
}

module "parameter_store_module" {
  source               = "./module/parameter_store_module"
  parameter_store_name = var.parameter_store_name
}

output "module_instance_id" {
  value = module.ec2_instance_module.instance_id
}

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}
