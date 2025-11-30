resource "aws_security_group" "rds_sg" {
  name        = "rds-msql-sg"
  description = "Security group for RDS MSQL instance"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "MySQL access from Strapi EC2 only"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.strapi_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-msql-sg"
  }
}


