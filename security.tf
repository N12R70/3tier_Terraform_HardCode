# 🌐 External ALB Security Group
resource "aws_security_group" "external_alb_sg" {
  name        = "external-alb-sg"
  description = "Allow HTTP from public internet"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "external-alb-sg" }
}

# 🔧 Web Tier EC2 Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-tier-sg"
  description = "Allow HTTP from external ALB and SSH from admin"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow HTTP from external ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.external_alb_sg.id]
  }

  ingress {
    description = "Allow SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ✅ Use for dev/test; restrict in prod
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "web-tier-sg" }
}

# 🔒 Internal ALB Security Group
resource "aws_security_group" "internal_alb_sg" {
  name        = "internal-alb-sg"
  description = "Allow traffic from Web Tier to App Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow app traffic from Web Tier"
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "internal-alb-sg" }
}

# ⚙️ App Tier EC2 Security Group
resource "aws_security_group" "app_sg" {
  name        = "app-tier-sg"
  description = "Allow traffic from internal ALB and SSH from Web Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow app traffic from internal ALB"
    from_port       = 4000
    to_port         = 4000
    protocol        = "tcp"
    security_groups = [aws_security_group.internal_alb_sg.id]
  }

  ingress {
    description     = "Allow SSH from Web Tier EC2"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "app-tier-sg" }
}

# 🗄️ RDS MySQL Security Group
resource "aws_security_group" "db_sg" {
  name        = "db-tier-sg"
  description = "Allow MySQL access from App Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow MySQL from App Tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "db-tier-sg" }
}

