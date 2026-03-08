variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances (Amazon Linux 2)"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins server"
  type        = string
  default     = "t2.micro"
}

variable "app_instance_type" {
  description = "Instance type for app servers"
  type        = string
  default     = "t2.micro"
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for EC2 instances"
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for ASG"
  type        = string
}

variable "asg_desired" {
  description = "Desired number of app instances"
  type        = number
  default     = 1
}

variable "asg_min" {
  description = "Minimum number of app instances"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "Maximum number of app instances"
  type        = number
  default     = 2
}
