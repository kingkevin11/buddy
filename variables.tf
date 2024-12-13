variable "aws_region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-2"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu"
  default     = "ami-005fc0f236362e99f"  # Ubuntu 20.04 LTS (update this for your region)
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"  # Free tier instance
}

variable "git_repo_url" {
  description = "Git repository URL for Nginx configurations"
  default     = "https://github.com/buddy.git"
}

variable "key_name" {
  description = "AWS Key Pair name for SSH access"
  default     = "ubuntuorg"
}
