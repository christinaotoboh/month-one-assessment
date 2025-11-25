variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "web_instance_type" {
  description = "Instance type for web servers"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_type" {
  description = "Instance type for database server"
  type        = string
  default     = "t3.small"
}

variable "key_pair_name" {
  description = "Name of the SSH key pair to use for EC2 instances"
  type        = string
}

variable "my_ip" {
  description = "Your IP address for SSH access to bastion"
  type        = string
}

variable "admin_password" {
  description = "Password for admin user (for SSH password authentication)"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}