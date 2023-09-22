provider "aws" {
    region = "us-east-1"
}

variable "bucket_name" {
    description = "name of the bucket will be created"
}

variable "instance_map" {}
variable "environment_type" {}

resource "aws_iam_policy" "bucket_policy" {
    name = "list_buckets_policy"
    policy = file("./policy.iam")
}

resource "aws_s3_bucket" "my_vled_bucket" {
    bucket = var.bucket_name
}

resource "aws_security_group" "group_1" {
    name = "security group 1"
}

resource "aws_security_group" "group_2" {
    name = "security group 2"
}

resource "aws_security_group" "group_3" {
    name = "security group 3"
}

module "cross_talk_groups" {
    source = "./cross-talk-3-way"
    security_group_1 = aws_security_group.group_1
    security_group_2 = aws_security_group.group_2
    security_group_3 = aws_security_group.group_3
    protocol = "tcp"
    port = 8500
}

variable "a" {
    type = list(string)
    // type = set(string) // contains only unique elements
    default = ["foo", "bar", "baz"]
}

variable "my_tuple" {
    type = tuple([string, number, bool])
    default = ["foo", 42, false]
}

variable "my_map" {
    type = map(string)
    default = {
        foo = "bar"
        baz = "qux"
    }
}

variable "person_with_address" {
    type = object({ name = string, age = number,
                    address = object({ line1 = string, line2 = string, 
                                       county = string, postcode = string }) 
                })
    default = {
        name = "Jim"
        age = 21
        address = {
            line1 = "1 the road"
            line2 = "St Ives"
            county = "Cambridgeshire"
            postcode = "CB1 2GB"
        }
    }
}

variable "any_example" {
    type = any
    default = {
        field1 = "foo"
        field2 = "bar"
    }
}

output "a" {
    value = element(var.a, 1)
}

output "my_tuple" {
    value = var.my_tuple[1]
}

output "my_map" {
    value = var.my_map["foo"]
}

output "person_with_address" {
    value = var.person_with_address.address.county
}

output "any_example" {
    value = var.any_example.field1
}


# data "aws_s3_bucket" "my_vled_bucket" {
#     bucket = var.bucket_name
# }

locals {
    first_part = "Hello"
    second_part = "${local.first_part} World"
    rendered = templatefile("./templateFile.tpl", { name = "Gokhan", number = 10 })
    backend = templatefile("./backendTemplate.tpl", { ip_addrs = ["10.0.0.1", "10.0.0.2"], port = 80 })

}

module "work_queue" {
    source = "./sqs-with-backoff"
    queue_name = "work-queue"
}

# module "work_queue" {
#     source = "github.com/kevholditch/sqs-with-backoff?ref=0.0.2"
#     queue_name = "work-queue"
# }

# output "bucket_name" {
#     value = aws_s3_bucket.my_vled_bucket.id
# }

# output "bucket_arn" {
#     value = aws_s3_bucket.my_vled_bucket.arn
# }

# output "bucket_information" {
#     value = "bucket name: ${aws_s3_bucket.my_vled_bucket.id}, bucket arn: ${aws_s3_bucket.my_vled_bucket.arn}"
# }

# output "bucket_all" {
#   value = aws_s3_bucket.my_vled_bucket
# }

output "selected_instace" {
    value = var.instance_map[var.environment_type]  
}

output "rendered_template" {
    value = local.rendered
}

output "backend_template" {
    value = local.backend
}

output "work_queue_name" {
    value = module.work_queue.queue_name
}
  
output "work_queue_dead_letter_name" {
    value = module.work_queue.dead_letter_queue_name
}

# provider "aws" {
#     alias = "ohio"
#     region = "us-east-2"
# } 

# resource "aws_vpc" "my_vpc" {
#     cidr_block = "10.0.0.0/16"
# }

# resource "aws_security_group" "my_security_group" {
#     name = "Example Security Group"
#     description = "Allow HTTP and SSH inbound traffic"
#     vpc_id = aws_vpc.my_vpc.id
# }

# resource "aws_security_group_rule" "tls_in" {
#     protocol = "tcp"
#     security_group_id = aws_security_group.my_security_group.id
#     from_port = 443
#     to_port = 443
#     type = "ingress"
#     cidr_blocks = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "http_in"{
#     protocol = "tcp"
#     security_group_id = aws_security_group.my_security_group.id
#     from_port = 80
#     to_port = 80
#     type = "ingress"
#     cidr_blocks = ["0.0.0.0/0"]
# }

# resource "aws_iam_policy" "my_bucket_policy" {
#     name = "my_bucket_policy"
#     policy = <<EOF
# {
#         "Version": "2012-10-17",
#         "Statement": [
#             {
#                 "Action": [
#                     "s3:ListBucket"
#                 ],
#                 "Effect": "Allow",
#                 "Resource": [
#                     "${data.aws_s3_bucket.my_vled_bucket.arn}"
#                 ]
#             }
#         ]
# }
# EOF
# }

# managing VPC generated outside of the terraform. terraform import aws_vpc.example VPC_ID
resource "aws_vpc" "example" {  
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "example"
    }
}

# uses state.tf defined S3 remote state backend. Count 
resource "aws_sqs_queue" "new_queue" {
    name = "new_queue"
    count = 4
}

# locals are the variables of tf
locals {
    fruit = toset(["apple", "banana", "orange"])
}

resource "aws_sqs_queue" "queues" {
    for_each = local.fruit
    name = "queue_${each.key}"
    lifecycle {
      #prevent_destroy = true
    }
}