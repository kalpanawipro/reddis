/*
 * InfluxDB application load balancer configuration
 */

data "aws_subnet" "subnets" {
  count = length(var.subnet_id)
  id = var.subnet_id[count.index]
}

resource "aws_alb_listener_rule" "query" {
  count = var.total_count
  listener_arn = "${var.listener_arn}"
  # priority = "5"
  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.query.arn}"
  }
  condition {
    path_pattern {
      values = ["/query*"]
    }
  }
  condition {
    host_header {
        values = [var.endpoint_influx ] #["${local.influxdb_names[count.index]}"]
    }
  }
}

resource "aws_alb_listener_rule" "query_path" {
  count = var.total_count
  listener_arn = "${var.listener_arn}"
  # priority = "6"
  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.query.arn}"
  }
  condition {
    path_pattern {
      values = ["/api/v2/query*"]
    }
    }
  condition {
    host_header {
        values = [var.endpoint_influx]
    }
  }
}

resource "aws_alb_listener_rule" "write_host" {
  count = var.total_count
  listener_arn = "${var.listener_arn}"
  # priority = "7"
  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.query.arn}"
  }
  condition {
    path_pattern {
    values = ["/write*"]
  }
  }
  condition {
  host_header {
        values = [var.endpoint_influx] 
    }
}
}

resource "aws_alb_listener_rule" "write" {
  count = var.total_count
  listener_arn = "${var.listener_arn}"
  # priority = "8"
  action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.query.arn}"
  }
  condition {
    path_pattern {
    values = ["/api/v2/write*"]
  }
  }
  condition {
  host_header {
        values = [var.endpoint_influx] #["${var.environment}-relay-${format("%02d", count.index+1)}"]
    }
}
}

resource "aws_alb_target_group" "query" {
  name = var.targetGroup_name
  protocol = "HTTP"
  port = 8086
  vpc_id = "${element(data.aws_subnet.subnets.*.vpc_id, 0)}"
  health_check {
    path = "/ping"
    matcher = 204
  }
}

resource "aws_alb_target_group_attachment" "query" {
  count = 2 #aws_instance.influxdb-nodes.count
  target_group_arn = "${aws_alb_target_group.query.arn}"
  target_id = "${element(aws_instance.influxdb-nodes.*.id, count.index)}"
  port = 8086
}