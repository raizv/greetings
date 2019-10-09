terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket         = "greetings-tf-state"
    dynamodb_table = "greetings-tf-state"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-west-2"
  }
}

provider "aws" {
  version = "~> 2.31"
  region  = "us-west-2"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "${var.tf_state_name}"
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name = "${var.tf_state_name}"
  }
}

resource "aws_dynamodb_table" "tf_state" {
  name         = "${var.tf_state_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.tf_state_name}"
  }
}

resource "aws_ecr_repository" "app_name" {
  name = "${var.app_name}"
}