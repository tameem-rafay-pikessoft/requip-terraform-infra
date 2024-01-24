provider "aws" {
  region = var.aws_region
}

# Create the role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com",
      },
    }],
  })
}

# Attach different policies with EC2 role
resource "aws_iam_role_policy_attachment" "ec2_role_permissions" {
  count = length(var.ec2_role_permissions)
  policy_arn = var.ec2_role_permissions[count.index]
  role       = aws_iam_role.ec2_role.name
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  user_data     = file("${path.module}/EC2_user_data.sh")
  iam_instance_profile = aws_iam_role.ec2_role.name

  tags = {
    Name = "Example Instance"
  }
}
# -- Assign Elastic IP to EC2 
resource "aws_eip" "aws_instance_elastic_ip" {
  domain      = "vpc"
  instance = aws_instance.ec2_instance.id
}

#EC2 security group
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
    for_each = var.security_group_allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}



# parameter store
resource "aws_ssm_parameter" "secure_parameter" {
  name        = var.parameter_store_name
  description = "My secure parameter"
  type        = "SecureString"
  value       = ""

}