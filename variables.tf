variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "us-east-1a"

}

variable "instance_name" {
  description = "Name of instance"
  type        = string
  default     = "my_server"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "keys"
}

variable "efs_name" {
  description = "Name of EFS"
  type        = string
  default     = "my_efs_storage"

}

variable "allow_ssh_ip" {
  description = "IP address allowed to SSH"
  type        = string
  default     = "0.0.0.0./0"

}