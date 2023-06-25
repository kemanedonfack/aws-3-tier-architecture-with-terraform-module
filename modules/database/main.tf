resource "aws_db_subnet_group" "database_subnet" {
  name       = var.db_subnet_name
  subnet_ids = var.subnet_ids #private subnets ids
}

resource "aws_db_instance" "rds_master" {
  identifier              = var.db_identifier
  allocated_storage       = 10
  engine                  = var.db_engine
  engine_version          = var.db_version
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password
  backup_retention_period = 7
  multi_az                = false
  availability_zone       = var.availability_zones[0]
  db_subnet_group_name    = aws_db_subnet_group.database_subnet.id
  skip_final_snapshot     = true
  vpc_security_group_ids  = [var.database_sg_id]
  storage_encrypted       = true

  tags = {
    Name = "${var.db_name}-${var.db_identifier}"
  }
}

# resource "aws_db_instance" "rds_replica" {
#   replicate_source_db    = aws_db_instance.rds_master.identifier
#   instance_class         = var.db_instance_class
#   identifier             = "replica-${var.db_name}"
#   allocated_storage      = 10
#   skip_final_snapshot    = true
#   multi_az               = false
#   availability_zone      = var.availability_zones[1]
#   vpc_security_group_ids = var.database_sg_id
#   storage_encrypted      = true

#   tags = {
#     Name = "${var.db_name}-${var.db_identifier}-replica"
#   }

# }
