variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "availability_zone" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-west-1a"]
  description = "Availability zones for subnets"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}