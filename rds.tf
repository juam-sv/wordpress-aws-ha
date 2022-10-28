resource "aws_db_subnet_group" "wordpress_db_subnets" {
  name       = "wordpress_db_subnets"
  subnet_ids = [aws_subnet.this_data["data-a"].id, aws_subnet.this_data["data-b"].id]

  tags = merge(
    local.common_tags,
    {
      Name = "wordpress_db_subnets"
    }
  )
}

resource "aws_rds_cluster" "wordpress_db_cluster" {
  cluster_identifier = var.cluster_identifier
  engine             = var.db_engine
  engine_version     = var.db_engine_version
  port               = var.db_port
  database_name      = var.db_name
  master_username    = var.db_master_username
  master_password    = var.db_master_password

  db_subnet_group_name    = aws_db_subnet_group.wordpress_db_subnets.name
  vpc_security_group_ids  = [aws_security_group.sg_db_cluster.id]
  backup_retention_period = 5
  preferred_backup_window = "04:00-06:00"
  skip_final_snapshot     = var.skip_final_snapshot

  storage_type              = var.db_storage_type
  allocated_storage         = var.db_allocated_storage
  db_cluster_instance_class = var.db_instance_class

  tags = merge(
    local.common_tags,
    {
      Name = "wordpress_db_cluster"
    }
  )
}

resource "aws_rds_cluster_instance" "wordpress_cluster_instances" {
  count                = 2
  identifier           = "${var.cluster_identifier}-${count.index}"
  cluster_identifier   = aws_rds_cluster.wordpress_db_cluster.id
  instance_class       = var.db_instance_class
  engine               = aws_rds_cluster.wordpress_db_cluster.engine
  engine_version       = aws_rds_cluster.wordpress_db_cluster.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_rds_cluster.wordpress_db_cluster.db_subnet_group_name

  tags = merge(
    local.common_tags,
    {
      Name = "wordpress_cluster_instances"
    }
  )
}

