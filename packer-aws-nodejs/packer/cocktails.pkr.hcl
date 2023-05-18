packer {
    required_plugins {
        amazon = {
            version = ">= 1.1.0"
            source = "github.com/hashicorp/amazon"
        }
    }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "cocktails" {
    ami_name = "cocktails-app-${local.timestamp}"

    source_ami_filter {
        filters = {
            name                = "al2023-ami-2023.*.*.0-kernel-6.1-x86_64"
            root-device-type    = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners      = ["amazon"]
    }

    instance_type = "t3.micro"
    region = "us-east-1"
    ssh_username = "ec2-user"
}

build {
    sources = [
        "source.amazon-ebs.cocktails"
    ]

    provisioner "file" {
        source = "../app/cocktails.zip"
        destination = "/home/ec2-user/cocktails.zip"
    }

    provisioner "file" {
        source = "./app.service"
        destination = "/tmp/cocktails.service"
    }

        provisioner "shell" {
        script = "./app.sh"
    }
}