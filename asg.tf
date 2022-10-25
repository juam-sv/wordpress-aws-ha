resource "aws_autoscaling_group" "asg_wordpress" {
  name             = "${aws_launch_configuration.lc_wordpress.name}-asg"
  min_size         = 1
  desired_capacity = 1
  max_size         = 2

  health_check_type = "ELB"
  load_balancers = [
    "${aws_elb.lb_wordpress.id}"
  ]
  launch_configuration = aws_launch_configuration.lc_wordpress.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = [
    "${aws_subnet.this["public-a"].id}",
    "${aws_subnet.this["public-b"].id}"
  ]
  lifecycle {
    create_before_destroy = true
  }
}