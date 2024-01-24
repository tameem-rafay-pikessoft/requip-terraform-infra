provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  user_data     = file("${path.module}/EC2_user_data.sh")


  tags = {
    Name = "Example Instance"
  }
}
# -- Assign Elastic IP to EC2 
resource "aws_eip" "aws_instance_elastic_ip" {
  vpc      = true
  instance = aws_instance.ec2_instance.id
}

resource "aws_security_group" "example_security_group" {
  name        = "example-security-group"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_ip]
  }

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}