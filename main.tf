provider "aws" {
  region     = "${var.credentials.region}"
  access_key = "${var.credentials.access_key}"
  secret_key = "${var.credentials.secret_access_key}"
}

# Create a VPC
resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "test_vpc"
  }
}

# Set up subnets with availablity zones 3 private and 3 public
resource "aws_subnet" "public_subnet" {
    count = "${length(var.availability_zones)}"
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "${var.subnets.public[count.index]}"
    availability_zone = "${var.availability_zones[count.index]}"
    tags = {
      "Name" = "public_subnet-${count.index}"
    }
}

resource "aws_subnet" "private_subnet" {
    count = "${length(var.availability_zones)}"
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "${var.subnets.private[count.index]}"
    availability_zone = "${var.availability_zones[count.index]}"
    tags = {
      "Name" = "private_subnet-${count.index}"
    }
}
