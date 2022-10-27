resource "aws_launch_configuration" "lc_wordpress" { #web
  name_prefix                 = var.lc_name_prefix
  image_id                    = var.lc_name_prefix
  instance_type               = var.lc_instance_type
  key_name                    = var.lc_key_name
  security_groups             = ["${aws_security_group.sg_http_and_ssh.id}"]
  associate_public_ip_address = true
  user_data                   = file("data.sh")
  lifecycle {
    create_before_destroy = true
  }
}