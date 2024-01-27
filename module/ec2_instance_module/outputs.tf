output "instance_details" {
  value = {
    instance_id   = aws_instance.ec2_instance.id
    instance_name = aws_instance.ec2_instance.tags["Name"]
  }
}
output "elastic_ip" {
  value = aws_eip.aws_instance_elastic_ip.public_ip
}