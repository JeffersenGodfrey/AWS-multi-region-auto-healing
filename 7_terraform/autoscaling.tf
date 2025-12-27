################################
# Launch Template
################################
resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = "ami-0c02fb55956c7d316" # Amazon Linux 2 (us-east-1)
  instance_type = "t2.micro"
  key_name      = "defo"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Auto Scaling Web App - Terraform</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-asg-instance"
    }
  }
}

resource "aws_launch_template" "web_lt_secondary" {
  provider      = aws.secondary
  name_prefix   = "web-lt-secondary-"
  image_id      = data.aws_ami.amazon_linux_2_secondary.id
  instance_type = "t2.micro"
  key_name      = "defo"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg_secondary.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Auto Scaling Web App - Terraform (Secondary)</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-asg-instance-secondary"
    }
  }
}

################################
# Auto Scaling Group
################################
resource "aws_autoscaling_group" "web_asg" {
  name             = "web-asg"
  desired_capacity = 2
  max_size         = 3
  min_size         = 1
  vpc_zone_identifier = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = true
  }
}

################################
# Attach ASG to Target Group
################################
resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  lb_target_group_arn    = aws_lb_target_group.web_tg.arn
}

resource "aws_autoscaling_group" "secondary_asg" {
  provider         = aws.secondary
  name             = "secondary-asg"
  desired_capacity = 2
  max_size         = 3
  min_size         = 1
  vpc_zone_identifier = [
    aws_subnet.secondary_public_1.id,
    aws_subnet.secondary_public_2.id
  ]

  launch_template {
    id      = aws_launch_template.web_lt_secondary.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "secondary-asg"
    propagate_at_launch = true
  }
}
