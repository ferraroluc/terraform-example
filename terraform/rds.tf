resource "aws_db_subnet_group" "prod-example-dbg" {
  name       = "prod-example-dbg"
  subnet_ids = module.example-vpc.public_subnets
}
resource "aws_security_group" "example-sg-db" {
  name        = "example-sg-db"
  vpc_id      = module.example-vpc.vpc_id
  ingress {
    description      = "MySQL from VPC"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = module.example-vpc.public_subnets_cidr_blocks
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "prod-example-db" {
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.dbName
  username               = var.dbUser
  password               = var.dbPass
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.prod-example-dbg.name
  vpc_security_group_ids = [aws_security_group.example-sg-db.id]
  # lifecycle {
  #   prevent_destroy = true
  # }
}