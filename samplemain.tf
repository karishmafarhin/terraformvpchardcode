provider "aws" {
  region = "${var.region}"
  access_key = "${var.acc_key}"
  secret_key = "${var.sec_key}"
}
resource "aws_vpc" "Test_vpc" {
  cidr_block = "${var.vpc_cid}"
  enable_dns_hostnames = true
  tags = {
      Name = "${var.vpc_nam}"
  }

}
resource "aws_subnet" "test_subnet1" {
  vpc_id     = aws_vpc.Test_vpc.id
  cidr_block = "${var.sub1_cid}"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.sub1_nam}"
  }
}
resource "aws_subnet" "test_subnet2" {
  vpc_id     = aws_vpc.Test_vpc.id
  cidr_block = "${var.sub2_cid}"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.sub2_nam}"
  }
}
resource "aws_subnet" "test_subnet3" {
  vpc_id     = aws_vpc.Test_vpc.id
  cidr_block = "${var.sub3_cid}"
  availability_zone = "us-east-1c"

  tags = {
    Name = "${var.sub3_nam}"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Test_vpc.id

  tags = {
    Name = "${var.ig_name}"
  }
}
resource "aws_route_table" "test-route-table" {
  vpc_id = aws_vpc.Test_vpc.id
   route {
      cidr_block = "${var.rout_cid}"
      gateway_id = aws_internet_gateway.gw.id
    }
    tags = {
    Name = "${var.rout_name}"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.test_subnet1.id
  route_table_id = aws_route_table.test-route-table.id
}
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.Test_vpc.id

  ingress {
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }
}

  tags = {
    Name = "allow_all"
  }
}

