provider "aws" {
  region = "us-east-1"  # Modify this to your desired AWS region
}

# Security Group to allow HTTP (80) traffic
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# AWS EC2 Instance (Ubuntu) with Docker, Git, and Nginx installation
resource "aws_instance" "nginx_instance" {
  ami           = "ami-005fc0f236362e99f"  # Ubuntu 20.04 LTS AMI ID (update for your region)
  instance_type = "t2.micro"  # Instance type for free tier
  key_name      = "ubuntuorg"  # SSH key pair for accessing the instance

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io git nginx  # Install Docker, Git, and Nginx
              systemctl enable docker
              systemctl start docker
              git clone https://github.com/buddy.git /home/ubuntu/nginx-config
              docker run -d -p 80:80 --name nginx-container -v /home/ubuntu/nginx-config:/etc/nginx/conf.d nginx
              EOF

  security_groups = [aws_security_group.nginx_sg.name]

  tags = {
    Name = "nginx-instance"
  }

  # Provisioners to install software and run Docker
  provisioner "remote-exec" {
    inline = [
      "git clone https://github.com/buddy.git /home/ubuntu/nginx-config",
      "docker run -d -p 80:80 --name nginx-container -v /home/ubuntu/nginx-config:/etc/nginx/conf.d nginx"
    ]
  }
}

# Output the public IP of the EC2 instance
output "nginx_instance_public_ip" {
  value = aws_instance.nginx_instance.public_ip
}
