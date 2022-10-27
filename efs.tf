# ------------------------- EFS ------------------------------------
resource "aws_efs_file_system" "wordpress_fs" {
  creation_token   = "${var.company}-${var.project}-${var.enviroment}"
  performance_mode = "generalPurpose"

  lifecycle_policy {
    transition_to_ia = "AFTER_60_DAYS"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "efs"
    }
  )
}

# ------------------------- EFS MOUNT TARGET -------------------------
resource "aws_efs_mount_target" "wordpress_mount_targets" {
  for_each = toset(local.subnets_app)

  file_system_id  = aws_efs_file_system.wordpress_fs.id
  subnet_id       = aws_subnet.this[local.subnet_pairs[each.value]].id
  security_groups = [aws_security_group.efs_sg.id]
}