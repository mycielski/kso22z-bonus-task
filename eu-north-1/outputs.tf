output "ssh_command" {
  description = "The SSH command to use to connect to the instance"
  value       = "ssh -i ${module.vm.key_file_path} ${module.vm.instance_username}@${module.vm.instance_dns}"
}
