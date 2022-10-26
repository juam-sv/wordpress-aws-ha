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

