resource "aws_launch_template" "lt_bastion" {
  name          = var.lc_bastion_name_prefix
  description   = "Launch Template for the Bastion instances"
  image_id      = var.lc_image_id
  instance_type = var.lc_bastion_instance_type
  key_name      = var.lc_bastion_key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg_bastion.id]
  }
}

resource "aws_autoscaling_group" "bastion_asg" {
  name             = var.asg_bastion_name
  desired_capacity = var.asg_bastion_desired_capacity
  min_size         = var.asg_bastion_min_size
  max_size         = var.asg_bastion_max_size
  vpc_zone_identifier = [
    "${aws_subnet.this["public-a"].id}",
    "${aws_subnet.this["public-b"].id}"
  ]

  launch_template {
    id      = aws_launch_template.lt_bastion.id
    version = "$Latest"
  }
}