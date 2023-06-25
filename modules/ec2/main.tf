resource "aws_launch_template" "instances_configuration" {
  name_prefix            = var.template_name
  image_id               = var.ami
  key_name               = var.key_name
  instance_type          = var.instance_type
  user_data              = base64encode(templatefile("${path.module}/userdata.tpl", { dbname = var.dbname, dbuser = var.dbuser, dbendpoint = var.dbendpoint, dbpassword = var.dbpassword }))
  vpc_security_group_ids = [var.ec2_sg_id]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = var.template_name
  }

}

resource "aws_autoscaling_group" "asg" {
  name                      = var.asg_name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 150
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.public_subnet_ids
  launch_template {
    id      = aws_launch_template.instances_configuration.id
    version = "$Latest"
  }

}

resource "aws_autoscaling_policy" "avg_cpu_policy_greater" {
  name                   = "avg-cpu-policy-greater"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.id
  # CPU Utilization is above 50
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }

}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn    = var.alb_target_group_arn
}

