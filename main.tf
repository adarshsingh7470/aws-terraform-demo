data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "selected" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = var.availability_zone

}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  tags = {
    Name = "${var.instance_name}-ami"
  }

}


## This security group for aws instance
resource "aws_security_group" "ec2_sg" {
  name        = "${var.instance_name}-security-group"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_ssh_ip]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow NFS traffic for EFS Connection"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## This is for EFS

resource "aws_security_group" "efs_sg" {
  name        = "${var.efs_name}-security-group"
  description = "Security group for EFS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow NFS traffic from EC2 instances"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.efs_name}-security-group"
  }

}

resource "aws_efs_file_system" "main" {
  creation_token = var.efs_name

  availability_zone_name = var.availability_zone

  encrypted = true

  performance_mode = "generalPurpose"

  throughput_mode = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = var.efs_name
  }

}

resource "aws_efs_mount_target" "main" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = data.aws_subnet.selected.id
  security_groups = [aws_security_group.efs_sg.id]

}

resource "aws_instance" "demo_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]


  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y amazon-efs-utils
                mkdir /mnt/efs
                sleep 30
                mount -t efs ${aws_efs_file_system.main.id}:/ /mnt/efs
                echo "${aws_efs_file_system.main.id}:/ /mnt/efs efs defaults,_netdev 0 0" >> /etc/fstab
  echo "Hello from EFS!" > /mnt/efs/test.txt
  chmod 777 /mnt/efs
                EOF

  tags = {
    Name = var.instance_name
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "ars-terraform-demo-bucket-123456"
  tags = {
    Name = "ars-terraform-demo-bucket"
  }

}