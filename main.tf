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

# Create an internet gateway
resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "my_internet_gateway"
  }
}

# Create a route table public and private
resource "aws_route_table" "public_route_table_test" {
    vpc_id = aws_vpc.test_vpc.id

    route {
        gateway_id = aws_internet_gateway.my_internet_gateway.id
        cidr_block = "0.0.0.0/0"
    }
    
    route {
        #ipv6_cidr_blocks
        ipv6_cidr_block        = "::/0"
        gateway_id = aws_internet_gateway.my_internet_gateway.id
    }
    tags = {
        Name = "public_route_table_test"
    }
}

# Create a security group
resource "aws_security_group" "allow_web" {
    name        = "allow_web"
    description = "Allow web inbound traffic"
    vpc_id      = aws_vpc.test_vpc.id

    ingress {
        description      = "HTTPS"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    ingress {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    ingress {
        description      = "SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "allow_web"
    }
}


