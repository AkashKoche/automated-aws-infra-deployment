data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_key_pair" "app" {
  key_name   = "${var.environment}-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")

  tags = {
    Name        = "${var.environment}-key-pair"
    Environment = var.environment
  }
}

resource "aws_instance" "jenkins" {

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.jenkins_instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.jenkins_security_group_id]
  key_name               = aws_key_pair.app.key_name

  user_data = file("${path.module}/jenkins-userdata.sh")

  tags = {
    Name        = "${var.environment}-jenkins-server"
    Environment = var.environment 
    ManagedBy   = "Terraform" 
  }
}
