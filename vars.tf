variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "az_qty" {
  description = "Number of zones into region"
  default     = "2"
}

