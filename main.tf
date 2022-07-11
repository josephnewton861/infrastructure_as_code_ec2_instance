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

# Link the public subnets to a route table
resource "aws_route_table_association" "route_table_association" {
    count = "${length(var.subnets.public)}"
    subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
    route_table_id = aws_route_table.public_route_table_test.id
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

# Create a network interface (logical networking component in a VPC that represents a virtual network card)
resource "aws_network_interface" "web-server-nic" {
    subnet_id = "${element(aws_subnet.public_subnet.*.id, 0)}"
    private_ips     = ["10.0.1.50"]
    security_groups = [aws_security_group.allow_web.id]
}

# Assign an elastic IP to the network interface
resource "aws_eip" "one" {
    vpc                       = true
    network_interface         = aws_network_interface.web-server-nic.id
    associate_with_private_ip = "10.0.1.50"
    depends_on = [
      aws_internet_gateway.my_internet_gateway
    ]
}

# Setting up ubuntu server
resource "aws_instance" "web-server-instance" {
  ami = "ami-0a244485e2e4ffd03"
  instance_type = "t2.micro"
  availability_zone = "eu-west-2a"
  key_name = "iac-test"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }
  user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install apache2 -y
        sudo systemctl start apache2
        sudo bash -c 'echo My ec2 web server > /var/www/html/index.html'
  EOF
  tags = {
      name = "web-server"
  }
}

