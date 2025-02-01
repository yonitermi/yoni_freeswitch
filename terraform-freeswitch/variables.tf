variable "aws_region" {
  description = "AWS region to deploy FreeSWITCH"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type for FreeSWITCH"
  default     = "t3.medium"
}

variable "key_name" {
  description = "SSH key pair name for EC2"
}

variable "security_group_name" {
  description = "Name of the security group"
  default     = "freeswitch_sg"
}

variable "ami_id" {
  description = "AMI ID for the base OS (Ubuntu/Debian recommended)"
}

variable "vpc_id" {
  description = "VPC ID to associate security groups"
}

variable "subnet_id" {
  description = "Subnet ID for EC2 placement"
}
