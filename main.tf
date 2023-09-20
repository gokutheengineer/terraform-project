provider "aws" {
    region = "us-east-1"
}

provider "aws" {
    alias = "ohio"
    region = "us-east-2"
} 

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "my_security_group" {
    name = "Example Security Group"
    description = "Allow HTTP and SSH inbound traffic"
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_security_group_rule" "tls_in" {
    protocol = "tcp"
    security_group_id = aws_security_group.my_security_group.id
    from_port = 443
    to_port = 443
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_in"{
    protocol = "tcp"
    security_group_id = aws_security_group.my_security_group.id
    from_port = 80
    to_port = 80
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
}