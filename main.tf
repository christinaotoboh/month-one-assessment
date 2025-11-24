terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.22.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    name = "techcorp-vpc"
  }
}


resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone[0]
  tags = {
    name = "techcorp-public-subnet-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone[1]
  tags = {
    name = "techcorp-public-subnet-2"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.availability_zone[3]
  tags = {
    name = "techcorp-private-subnet-1"
  }
}
resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.availability_zone[4]
  tags = {
    name = "techcorp-private-subnet-2"
  }
}



resource "aws_internet_gateway" "techcorp-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main_igw"
    description = "Internet gateway for the VPC"
  }
}



resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.techcorp-igw.id
  }

  tags = {
    Name = "rtb_1"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.rt.id
}



resource "aws_instance" "my_instance" {
  ami           = "ami-01b799c439fd5516a"
  instance_type = var.instance_type
}