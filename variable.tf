#================================================================
#======================NETWORK VARIABLES====================
#================================================================

variable "region" {
  default =  "us-east-1"
}

variable "my_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
  default = "10.0.0.0/20"
}

variable "private_subnet_az" {
  default = "us-east-1a"
}

variable "public_subnet_cidr" {
  default = "10.0.16.0/20"
}

variable "public_subnet_az" {
  default = "us-east-1b"
}

variable "igw-cidr" {
  default = "0.0.0.0/0"
}

#================================================================
#======================Ec2 VARIABLES====================
#================================================================

variable "my_ami" {
  default = "ami-068c0051b15cdb816"
}

variable "my_instance_type" {
  default = "t3.micro"
}

variable "my_key" {
  default = "global_key"
}