resource "aws_security_group" "sg_http_and_ssh" {
  name        = "http_and_ssh"
  description = "Open http, https and ssh ports"
  vpc_id      = aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.ec2_sg_ingress_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["${var.vpc_configuration.cidr_block}"] #verificar
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------- EFS SECURITY GROUP --------------------

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "Opening EFS port"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_http_and_ssh.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------- RDS SECURITY GROUP --------------------
resource "aws_security_group" "sg_db_cluster" {
  name        = "sg_db_cluster"
  description = "Open MySQL port 3306 for EC2 instances"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port = var.db_port
    to_port   = var.db_port
    protocol  = "tcp"
    cidr_blocks = ["${aws_subnet.this["app-a"].cidr_block}", "${aws_subnet.this["app-b"].cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------- ELASTICACHE SECURITY GROUP --------------------
resource "aws_security_group" "sg_memcached" {
  name        = "sg_memcached"
  description = "Opening memcached port for wordpress autoscaling group security group"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = var.ec_memcached_port
    to_port     = var.ec_memcached_port
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.this["app-a"].cidr_block}", "${aws_subnet.this["app-b"].cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}