# AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# AMI Data
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# AMI Data
data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]
    
    filter {
        name = "name"
        values = ["amzn-ami-hvm-*-x86_64-gp2"]
    }
    
    filter {
        name = "owner-alias"
        values = ["amazon"]
    }
}


# Locals

locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod  = "t3.large"
  }

  web_count_map = {
    stage = 1
    prod  = 2
  }

  web_vm_map = {
    stage = {
        "stage1" = {name="stage1"}
    } 
    prod  ={
        "prod1" = {name="pr1"},
        "prod2" = {name="pr2"}
    }  
  }
}

# Instance Resources

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  count         = local.web_count_map[terraform.workspace]

  cpu_core_count       = 1
  cpu_threads_per_core = 1
  monitoring           = true

  tags = {
    org  = "netology"
    name = "ec2-jjvod"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_instance" "web_for_each" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.web_instance_type_map[terraform.workspace]

  for_each = local.web_vm_map[terraform.workspace]

  monitoring = true

  tags = {
    org  = "netology"
    name = "ec2-jjvod"
  }
}