#################################
# Resources
#################################

# Resource key pair
resource "aws_key_pair" "deployer" {
  key_name   = var.ec2-instance-key
  public_key = file("/home/ubuntu/.ssh/id_ed25519.pub")
}

# Resource default VPC
resource "aws_default_vpc" "default" {

}

##################################
# Networking
##################################

resource "aws_security_group" "allow_user_to_connect" {
  name        = "Allow TLS"
  description = "Allow user to connect"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    description = "port 22 allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = " allow all outgoing traffic "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 80 allow"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "port 443 allow"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.ec2-security-tag
  }
}

###############################
# EC2 Instance
###############################

resource "aws_instance" "testinstance" {
  ami             = var.ec2-instance-ami
  instance_type   = var.ec2-instance-type
  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.allow_user_to_connect.name]
  tags = {
    Name = var.aws-ec2-instance-tag
  }
  user_data = file("/home/ubuntu/Terraform-Mastery/CreateEC2/init.sh")
}
