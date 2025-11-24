variable "cidr_block"{
  default = "10.0.0.0/16"
  type = string
  description = "CIDR block for the VPC"
}


variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}