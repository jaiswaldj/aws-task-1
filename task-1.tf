provider "aws" {
       region  = "ap-south-1"
       profile = "Deepak"
}

resource "aws_key_pair" "mykey111" {
    key_name= "mykey111"
    public_key= "ssh-rsa MIIEowIBAAKCAQEAnn1K+TFtXA0NJjJCUJMkCaXviCA07Vwv6P7n0TmGEctL6p7n8X1UGC/DfhIe
LiXdtBGiNBgxnMzVdYJXpJjZLTPGTFHgCZFxQ3N94al8ryJA8bsN2sq9IR+baBv12hMIRtFr668a
PAiZECr7IRemmDFyfRsXKgTPk7E4domutjgqivxkjRgRP2kGMiiqLeWi4hMMoHP8icKS3Ssinu6U
lHxeWLz7rvZUoL4H9tfZwbKRIacEZZ+Vv+YamcL2guiJTWREAoJ91FdtY4pxhzAh8YOa/4scFRGa
roNIfQ5CzV7i7Xb/9gcW6U9KGMiXplBgvJ1oswCpbdbO79mGY9kUPwIDAQABAoIBAFFCqGgwIYQq
5O0Ko9mwN7ACtlezO6/frmjmGXG67rS86YW4R/AXdECabL99BqBepdenmuTe6sEcfO2tEMbB38g/
XZLP//Cn88zDsG09e0JIa8gFQktF28bZ79JnU5ymWX4F7jF/LBJPzjrt7qi++Zna8HqYoz3WDaAK
I4sTeNLQFuA8QdaGxdXACrgEDOPHl9RqicbCcVBPGtMxRn28vjmRpLuV5736Uu9rBdWhQCjuC4hZ
7l7t0o4g6+OLw213pdM8RH+9WFxIiDH4jNSuRmNWgAVLxahLLWpMrqPD66KZwTbP6wVkTEePPNRJ
qp9g3sxwuDNiLymri0Ip8YlcYJECgYEAyxC/Tg7X01nZhwhufgtyzbPJwXjv1PR2GUfm0rIThveM
nAKzyYXt+u3fk3XtLJnectrKtC6EBBk620qQT0gG4SPArhtuciZ7bI3ZmjBjKUEHUMuTnQCyhd1i
YWZ5wA5nyYAXi6fGybfeeGTcmpbAb/DMOeVUKGoZuO6VxJNEikUCgYEAx83WIS8HNMvPhRMYGk7v
/nVRu8cb3ulMVEPSxGAVyvaT8+iVFBU9L52VOxmheoF7jmOWN352Q75hyec8t7UPb05UVsZhZ3C4
krobFX9WoZyf61Z7CCM4p8SxuZoOu5eJObH+FwdjYUrEwgMbEIK+eUAca087k7Y019rL/r0ELrMC
gYA5sNFY4NiqP/2P4nJZtvDvxeNM5wnkC2u99PJ764Gmt4+oBxCC8VzSDGCXaUpvgGt1X/l0xT5W
V8Cj6oQjMghaUCj+jeaL4ajxBz/KEXMqlkH4z01prngJlgLMPyvZx33u/kgyMgFE78rxk14lQSz8
4IF09VU6giI6qvW7ukcfrQKBgQC+y4osyfHBstYJp4Aerz5x6KoR/EJbDME8vj9oErD8zZXfFjw1
n0p8S6iTdRhEGZ1ZDTQG7hYU/pn26X+LlbSVf2D+NBYTZwp54om2b5DUZvI3ErANx0R0wFlOeRSU
glIh7BxM9VsrLvDQq5KOo6srsdLxjgnANgAkF+Uw7mIuDQKBgAa45VKlpxaUgtpdYSAfR5mFbdFy
vEjjnvP/zWSn+Jo1IjAf+GrkPLwCaVCkGDl4WsUJzWtHAKgj35bZTWisxYv3C4xhEEm1MO0vNgXG
pg/s1vuuJYH3M4Mqc3D9uIKQYp+lKmzMSu8x3nZqObZDnW1PnR/NOYH7EEI8VgS9s7Qy"
}

resource "aws_security_group" "terra1" {
    name = "terra1"
    description = "Allow SSH and HTTP"
    vpc_id = "vpc-35e1fc5d"

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port   = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

    tags={
        Name="mydeepak"
    }
}




resource "aws_instance" "mydeepak" {
    ami= "ami-08706cb5f68222d09"
    instance_type = "t2.micro"
    key_name = "mykey111"
    security_groups = ["terra1"]
    user_data = <<-EOF
        #!/bin/bash
        sudo yum install httpd-y
        sudo systemctl start httpd
        sudo systemctl enable httpd
        sudo yum install git -y
        mkfs.ext4/dev/df1
        mount/dev/df1/var/www/html
        cd/var/www/html

    git clone https://github.com/jaiswaldj/Hybridmulticloud_task.git

    EOF
    tags = {
        Name="mydeepak"
    }    
}

resource "aws_ebs_volume" "my_lw_pendrive" {
    availability_zone = aws_instance.mydeepak.availability_zone
    size = 1

    tags = {
        Name= "my_lw_pendrive"
    }
}

resource "aws_volume_attachment" "ebs_att" {
    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.my_lw_pendrive.id
    instance_id = aws_instance.mydeepak.id
    force_detach = true
}

resource "aws_s3_bucket" "terra-s1" {
    bucket= "terra-s1"
}

resource "aws_s3_bucket_public_access_block" "access" {
    bucket = "${aws_s3_bucket.terra-s1.id}"
    block_public_acls = true
    block_public_policy = true

}