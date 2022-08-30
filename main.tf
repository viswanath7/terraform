provider "aws" {
  region = "eu-west-1"
}

variable "vpc-name" {
  type = string
  description = "Name of the virtual private network to create"
  default = "playground"
}

variable "cidr-blocks" {
  description = "CIDR blocks for VPC and subnets"
  type = list(object({
    cidr = string,
    name = string
  }))
}

resource "aws_vpc" "playground" {
  cidr_block = var.cidr-blocks[0].cidr
  tags = {
    Name = var.cidr-blocks[0].name
  }
}

variable "subnet-name" {
  type = string
  description = "Name of the subnet within virtual private network"
  default = "subnet"
}

locals {
  subnet_name = "${var.vpc-name}-${var.subnet-name}"
}

resource "aws_subnet" "playground-subnet-1" {
  vpc_id     = aws_vpc.playground.id
  cidr_block = var.cidr-blocks[1].cidr
  availability_zone = "eu-west-1a"
  tags = {
    Name = "${var.cidr-blocks[0].name}-${var.cidr-blocks[1].name}"
  }
}

/* 
data "aws_vpc" "playground-vpc" {
  filter {
    name   = "tag:Name"
    values = ["playground"]
  }
}
 */

resource "aws_subnet" "playground-subnet-2" {
  vpc_id     = aws_vpc.playground.id
  cidr_block = var.cidr-blocks[2].cidr
  availability_zone = "eu-west-1b"
  tags = {
    Name = "${var.cidr-blocks[0].name}-${var.cidr-blocks[2].name}"
  }
}

resource "aws_subnet" "playground-subnet-3" {
  vpc_id     = aws_vpc.playground.id
  cidr_block = var.cidr-blocks[3].cidr
  availability_zone = "eu-west-1c"
  tags = {
    Name = "${var.cidr-blocks[0].name}-${var.cidr-blocks[3].name}"
  }
}

output "vpc-arn" {
  value = aws_vpc.playground.arn
  sensitive = false
  description = "ARN of the virtual private network in which all the resources shall be created"
}


output "vpc-first-subnet-arn" {
  value = aws_subnet.playground-subnet-1.arn
  sensitive = false
  description = "ARN of VPC's first subnet"
}


output "vpc-second-subnet-arn" {
  value = aws_subnet.playground-subnet-2.arn
  sensitive = false
  description = "ARN of VPC's second subnet"
}


output "vpc-third-subnet-arn" {
  value = aws_subnet.playground-subnet-3.arn
  sensitive = false
  description = "ARN of VPC's third subnet"
}

output "combined-local-variable" {
  value = local.subnet_name
}