resource "aws_instance" "StrapiVM" {
  ami                         = var.ec2_config.ami_id
  instance_type               = var.ec2_config.instance_type
  key_name                    = var.private_key_config.key_name
  associate_public_ip_address = var.ec2_config.associate_public_ip_address
  iam_instance_profile        = aws_iam_instance_profile.strapi_profile.name

  user_data = templatefile("Cloud-init-strapi.sh", {
    db_host               = aws_db_instance.strapi_db.address
    db_port               = aws_db_instance.strapi_db.port
    db_name               = var.rds_db_config.db_name
    db_username           = var.rds_db_config.db_username
    db_password           = var.rds_db_config.db_password
    aws_region            = var.region
    s3_bucket             = var.s3
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
  })
  ebs_block_device {
    device_name = var.ebs_config.device_name
    volume_size = var.ebs_config.volume_size
    volume_type = var.ebs_config.volume_type
    delete_on_termination = var.ebs_config.delete_on_termination
  }

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  subnet_id              = aws_subnet.public_1.id

  depends_on = [aws_db_instance.strapi_db]

  tags = {
    Name = "StrapiVM"
  }
}
