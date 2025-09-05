resource "aws_instance" "app_1" {
  ami           = "ami-0861f4e788f5069dd"         # Amazon Linux 2
  instance_type = "t3.micro"                      # Free Tier eligible burstable instance
  subnet_id     = aws_subnet.private_app_1.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]   # ✅ FIXED
  key_name      = "nariiin"                       # 👈 Your PEM key pair name

  tags = {
    Name = "AppTier-EC2"
  }
}

