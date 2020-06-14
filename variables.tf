variable "region" {
  default = "us-east-1"
}
variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "availability_zone" {
  description = "Availabilty zone for subnet"
  default     = "us-east-1b"
}

variable "instance_ami" {
  description = "AMI ID for region us-east-1"
  default     = "ami-098f16afa9edf40be"
}

variable "instance_type" {
  description = "Instance type for EC2"
  default     = "t2.micro"
}