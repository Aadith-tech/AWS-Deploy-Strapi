output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.StrapiVM.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.StrapiVM.public_dns
}

output "strapi_url" {
  description = "Strapi application URL"
  value       = "http://${aws_instance.StrapiVM.public_ip}:1337"
}

output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = aws_db_instance.strapi_db.endpoint
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.strapi_db.db_name
}






