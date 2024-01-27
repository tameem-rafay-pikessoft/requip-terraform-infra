
# Create the role for EC2 instance
resource "aws_iam_role" "EC2_Service_Role" {
  name = "ec2-role"

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
  tags = var.tags
}

# Attach different policies with EC2 role
resource "aws_iam_role_policy_attachment" "ec2_role_permissions" {
  count = length(var.ec2_role_permissions)
  policy_arn = var.ec2_role_permissions[count.index]
  role       = aws_iam_role.EC2_Service_Role.name
  tags = var.tags
}

resource "aws_iam_instance_profile" "EC2_instance_profile" {
  name = aws_iam_role.EC2_Service_Role.name
  role = aws_iam_role.EC2_Service_Role.id
  tags = var.tags
}

resource "aws_instance" "ec2_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = file("${path.module}/EC2_user_data.sh")
  iam_instance_profile = aws_iam_instance_profile.EC2_instance_profile.name
  vpc_security_group_ids = [aws_security_group.example_security_group.id]
  key_name        = var.ec2_key_name
  tags = var.tags
}
# -- Assign Elastic IP to EC2 
resource "aws_eip" "aws_instance_elastic_ip" {
  domain      = "vpc"
  instance = aws_instance.ec2_instance.id
  tags = var.tags
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
  tags = var.tags
}

