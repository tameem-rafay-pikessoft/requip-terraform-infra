output "instance_details" {
  value = {
    instance_id   = aws_instance.ec2_instance.id
    instance_name = aws_instance.ec2_instance.tags["Name"]
  }
}