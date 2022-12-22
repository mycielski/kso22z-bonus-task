output "key_file_path" {
  value = local_sensitive_file.key.filename
}

output "instance_public_ip" {
  value = aws_instance.default.public_ip
}

output "instance_username" {
  value = "ubuntu"
}

output "instance_dns" {
  value = aws_instance.default.public_dns
}