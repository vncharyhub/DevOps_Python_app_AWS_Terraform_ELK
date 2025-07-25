provider "aws" {
  region = "us-east-1"
}

### 1. Custom VPC ###
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "custom-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
    Name = "custom-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.custom_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

### 2. Security Group ###
variable "allowed_ports" {
  default = [22, 80, 443, 8080, 8081, 8082]
}

resource "aws_security_group" "allow_ports" {
  name        = "allow-selected-ports"
  description = "Allow common and custom ports"
  vpc_id      = aws_vpc.custom_vpc.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-selected-ports"
  }
}

### 3. Key Pair ###
resource "aws_key_pair" "my_key" {
  key_name   = "my-ec2-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

### 4. EC2 Instance ###
resource "aws_instance" "ubuntu_vm" {
  ami                    = "ami-0fc5d935ebf8bc3bc" # Ubuntu 22.04 in us-east-1
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  key_name               = aws_key_pair.my_key.key_name

  tags = {
    Name = "Ubuntu-Custom-VPC"
  }
}

### 5. Output values ###
output "vpc_id" {
  description = "Custom VPC ID"
  value       = aws_vpc.custom_vpc.id
}

output "public_ip" {
  description = "EC2 instance public IP"
  value       = aws_instance.ubuntu_vm.public_ip
}
