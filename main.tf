terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

 provider "aws" {
  region = "us-east-1"
 }


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true 
  tags = {
    name = "techcorp-vpc"
  }
}


resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
      name = "techcorp-public-subnet-1"
    } 
}

resource "aws_subnet" "public-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-west-1a"
    tags = {
      name = "techcorp-public-subnet-2"
    } 
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-west-1a"
    tags = {
      name = "techcorp-private-subnet-1"
    } 
}
resource "aws_subnet" "private-2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-west-1a"
    tags = {
      name = "techcorp-private-subnet-2"
    } 
}




resource "aws_instance" "my_instance" {
  ami           = "ami-01b799c439fd5516a"
  instance_type = var.instance_type
}