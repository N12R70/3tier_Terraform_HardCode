# Subnet Group for RDS (must be in private subnets)
resource "aws_db_subnet_group" "db_subnet" {
  name       = "three-tier-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_db_1.id,
    aws_subnet.private_db_2.id
  ]

  tags = {
    Name = "three-tier-db-subnet-group"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  identifier              = "three-tier-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"                 # Free Tier eligible
  allocated_storage       = 20                            # Minimum required
  storage_type            = "gp2"
  username                = "admin"
  password                = "StrongPassword123"           # ✅ Hardcoded password
  db_name                 = "webappdb"
  multi_az                = true                          # High availability
  publicly_accessible     = false                         # Private access only
  skip_final_snapshot     = true                          # No snapshot on destroy
  deletion_protection     = false                         # Allow deletion
  db_subnet_group_name    = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]

  tags = {
    Name = "three-tier-rds-mysql"
  }
}

