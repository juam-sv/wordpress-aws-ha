resource "aws_launch_configuration" "lc_wordpress" { #web
  name_prefix                 = "wordpress-"
  image_id                    = "ami-087c17d1fe0178315"
  instance_type               = "t2.micro"
  key_name                    = "madra"
  security_groups             = ["${aws_security_group.sg_http_and_ssh.id}"]
  associate_public_ip_address = true
  user_data                   = file("data.sh")
  lifecycle {
    create_before_destroy = true
  }
}