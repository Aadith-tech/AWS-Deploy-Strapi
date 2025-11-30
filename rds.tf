resource "aws_db_subnet_group" "rds_subnet_group" {
    name       = "rds_subnet_group"
    subnet_ids = [aws_subnet.private_1.id,aws_subnet.private_2.id]

    tags = {
      Name = "rds_subnet_group"
    }
}


resource "aws_db_instance" "strapi_db" {
  allocated_storage      = var.rds_db_config.allocated_storage
  instance_class         = var.rds_db_config.db_instance_class
  engine                 = var.rds_db_config.engine
  engine_version         = var.rds_db_config.engine_version
  db_name                = var.rds_db_config.db_name
  username               = var.rds_db_config.db_username
  password               = var.rds_db_config.db_password
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  skip_final_snapshot    = var.rds_db_config.skip_final_snapshot

  backup_retention_period = var.rds_db_config.backup_retention_period
  storage_encrypted       = var.rds_db_config.storage_encrypted
  delete_automated_backups = var.rds_db_config.delete_automated_backups

  tags = {
    Name = "strapi_db_instance"
  }
}
