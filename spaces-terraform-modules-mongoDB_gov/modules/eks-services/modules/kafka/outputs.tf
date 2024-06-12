# output "haproxy_lb_ec2_instance" {
#     value = aws_instance.kafka_ec2_creation.id
# } 

output "instance_creation_output" {
  description = "Instance creation output"
  value       = aws_instance.kafka_ec2_creation[*]
}