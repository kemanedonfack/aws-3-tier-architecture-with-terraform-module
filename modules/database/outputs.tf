output "database_endpoint" {
  value = aws_db_instance.rds_master.endpoint
}

output "database_username" {
  value = aws_db_instance.rds_master.username
}

output "database_password" {
  value = aws_db_instance.rds_master.password
}

output "database_name" {
  value = aws_db_instance.rds_master.db_name
}
