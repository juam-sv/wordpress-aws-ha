#------------------- AUTO SCALING GROUP -------------------------------------- 
resource "aws_autoscaling_group" "asg_wordpress" {
  name             = "${aws_launch_configuration.lc_wordpress.name}-asg"
  min_size         = 1
  desired_capacity = 2
  max_size         = 4

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

#------------------- AUTO SCALING POLICY-----------------------------------------
resource "aws_autoscaling_policy" "wordpress_asg_up" {
  name                   = "wordpress_asg_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg_wordpress.name
}
resource "aws_cloudwatch_metric_alarm" "wordpress_cpu_alarm_up" {
  alarm_name          = "wordpress_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg_wordpress.name}"
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.wordpress_asg_up.arn}"]
}
resource "aws_autoscaling_policy" "wordpress_asg_down" {
  name                   = "wordpress_asg_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg_wordpress.name
}
resource "aws_cloudwatch_metric_alarm" "wordpress_cpu_alarm_down" {
  alarm_name          = "wordpress_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg_wordpress.name}"
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = ["${aws_autoscaling_policy.wordpress_asg_down.arn}"]
}