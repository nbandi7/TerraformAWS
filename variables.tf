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
  description = "RHEL AMI ID for region us-east-1"
  default     = "ami-098f16afa9edf40be"
}

variable "instance_type" {
  description = "Instance type for EC2"
  default     = "t2.micro"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnets_cidr_public" {
  type    = list
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "azs_public" {
  type    = list
  default = ["us-east-1a", "us-east-1c"]
}

variable "subnets_cidr_private" {
  type    = list
  default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "azs_private" {
  type    = list
  default = ["us-east-1b", "us-east-1d"]
}