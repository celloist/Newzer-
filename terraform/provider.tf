terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }

 backend "s3" {
   region = "eu-central-1"
   key    = "terraform.tfstate"
 }
}

provider "aws" {
 region = "eu-central-1"
}

resource "aws_instance" "tf_instance" {
 ami           = "ami-830c94e3"
 instance_type = "t2.nano"
 tags = {
   Name = "tf_instance"
 }
}