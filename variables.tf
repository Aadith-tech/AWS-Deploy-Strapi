variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "The AWS region to deploy resources"
}

variable "ec2_config" {
  type = map(string)
  default = {
    ami_id = "ami-02b8269d5e85954ef"
    instance_type = "c5.large"
    associate_public_ip_address = "true"
  }
  description = "EC2 instance configuration"
}

variable "ebs_config" {
  type = map(string)
  default = {
    device_name = "/dev/sda1"
    volume_type = "gp3"
    volume_size = "30"
    delete_on_termination = "true"
  }
  description = "EBS volume configuration"
}


variable "rds_db_config" {
    type = map(string)
    default = {
        allocated_storage = "20"
        db_name     = "strapi_db"
        db_username = "admin"
        db_password = "password"
        db_instance_class = "db.t3.micro"
        engine = "mysql"
        engine_version = "8.0.42"
        skip_final_snapshot = "true"
        backup_retention_period = "7"
        storage_encrypted = "false"
        delete_automated_backups = "true"
}
}

variable "s3" {
  type = string
  default = "aadithnewbucket"
}

variable "aws_vpc" {
    type = map(string)
    default = {
      cidr_block = "10.0.0.0/16"
      enable_dns_hostnames = "true"
      enable_dns_support = "true"
    }
}

variable "public_subnet" {
    type = map(string)
    default = {
      cidr_block = "10.0.1.0/24"
      availability_zone = "ap-south-1a"
    }
}

variable "private_subnet1" {
    type = map(string)
    default = {
      cidr_block = "10.0.2.0/24"
        availability_zone = "ap-south-1b"

      }
}

variable "private_subnet2" {
  type = map(string)
  default = {
    cidr_block = "10.0.3.0/24"
    availability_zone = "ap-south-1b"

  }
}

variable "private_key_config" {
  type = map(string)
  default = {
    key_name = "aadithkey"
    private_key_path = "/Users/aaditharasu/downloads/aadithkey.pem"
  }
  description = "Private key configuration for SSH access"
}

variable "aws_access_key_id" {
  type        = string
  description = "AWS Access Key ID for S3 upload"
  sensitive   = true
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS Secret Access Key for S3 upload"
  sensitive   = true
}