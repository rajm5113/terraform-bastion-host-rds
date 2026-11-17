output "project" {
  value = var.project
}

### START CODE HERE ### (~ 19 lines of code)


output "bastion_host_id" {
  value = aws_instance.bastion_host.id
}

output "bastion_host_dns" {
  value = aws_instance.bastion_host.public_dns
}

output "db_host" {
  value = aws_db_instance.database.address
}

output "db_port" {
  value = aws_db_instance.database.port
}

output "db_master_username" {
  value = aws_db_instance.database.username
}

output "db_master_password" {
  value     = aws_db_instance.database.password
  sensitive = true
}

### END CODE HERE ###
