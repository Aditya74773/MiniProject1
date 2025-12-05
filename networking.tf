terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ---------------- DATA BLOCK ----------------
data "aws_availability_zones" "available" {}

# ---------------- RANDOM ID ----------------
resource "random_id" "random" {
  byte_length = 2
}

# ---------------- VPC ----------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "main-vpc-project-${random_id.random.dec}"
  }
}

# ---------------- INTERNET GATEWAY ----------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw-project-${random_id.random.dec}"
  }
}

# ---------------- ROUTE TABLE ----------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt-project-${random_id.random.dec}"
  }
}

resource "aws_default_route_table" "private_rt" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "private-rt-project-${random_id.random.dec}"
  }
}

# ---------------- SUBNETS ----------------
resource "aws_subnet" "public_subnet" {
  count                   = 1
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}-project-${random_id.random.dec}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${random_id.random.dec}-${count.index + 1}"
  }
}

# ---------------- ROUTE TABLE ASSOCIATION ----------------
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------- SECURITY GROUP ----------------
resource "aws_security_group" "project_sg" {
  name        = "project-sg-${random_id.random.dec}"
  description = "Security group for project"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "project-sg"
  }
}

# ---------------- SECURITY GROUP RULES ----------------
# Allow port 3000
resource "aws_security_group_rule" "allow_app" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = var.access_ip
  security_group_id = aws_security_group.project_sg.id
  description       = "Allow app traffic on port 3000"
}
resource "aws_security_group_rule" "allow_prometheus" {
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = var.access_ip
  security_group_id = aws_security_group.project_sg.id
  description       = "Allow app traffic on port 3000"
}
resource "aws_security_group_rule" "allow_prometheus_node" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  cidr_blocks       = var.access_ip
  security_group_id = aws_security_group.project_sg.id
  description       = "Allow app traffic on port 3000"
}

# Allow SSH
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.access_ip
  security_group_id = aws_security_group.project_sg.id
  description       = "Allow SSH access"
}

# Allow all outbound
resource "aws_security_group_rule" "allow_all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.project_sg.id
  description       = "Allow all outbound traffic"
}
# Allow HTTP traffic on port 80
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  # This uses your defined variable, which defaults to ["0.0.0.0/0"]
  cidr_blocks       = var.access_ip 
  security_group_id = aws_security_group.project_sg.id
  description       = "Allow HTTP access on port 80"
}