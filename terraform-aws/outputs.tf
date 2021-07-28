output "my_instance_id" {
  description = "InstanceID of our server"
  value       = aws_instance.app_server[*].id
}

output "my_instance_ip" {
  description = "IP of our server"
  value       = (length(aws_instance.app_server) > 0 ? aws_instance.app_server[*].public_ip:[])
}

output "my_sg_id" {
  description = "ID of sec_grp"
  value       = aws_security_group.web_sg.id
}
