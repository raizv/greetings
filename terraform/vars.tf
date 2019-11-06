
variable "region" {
  description = "Default AWS region"
  default     = "us-west-2"
}

variable "app_name" {
  description = "Application name"
  default     = "greetings"
}

variable "tf_state_name" {
  description = "S3 bucket and DynamoDB table names to store terraform state"
  default     = "greetings-tf-state"
}