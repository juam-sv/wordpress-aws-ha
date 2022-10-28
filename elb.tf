resource "aws_elb" "lb_wordpress" {
  name = "lb-wordpress"
  security_groups = [
    "${aws_security_group.sg_http_and_ssh.id}"
  ]
  subnets = [
    "${aws_subnet.this["public-a"].id}",
    "${aws_subnet.this["public-b"].id}"
  ]
  cross_zone_load_balancing = true
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "lb_wordpress"
    }
  )
}