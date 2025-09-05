resource "aws_instance" "web_1" {
  ami           = "ami-0861f4e788f5069dd"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]   # ✅ FIXED
  key_name      = "nariiin"  # 👈 Add this line
  tags = {
    Name = "WebTier-EC2"
  }
}

