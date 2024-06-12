resource "aws_security_group" "govcloud-sg" {
  description = "Security Groups through terragrunt"

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    from_port        = "0"
    ipv6_cidr_blocks = ["::/0"]
    protocol         = "-1"
    self             = "false"
    to_port          = "0"
  }

  ingress {
    cidr_blocks     = ["10.20.0.0/28"]
    from_port       = "22"
    protocol        = "tcp"
    self            = "false"
    to_port         = "22"
  }

  ingress {
    cidr_blocks = ["10.20.0.0/28"]
    from_port   = "8080"
    protocol    = "tcp"
    self        = "false"
    to_port     = "8080"
  }

  name = "opsstack-sg"

  tags = {
    Name = "OpsStack-SG-Fedramp"
  }

  tags_all = {
    Name = "OpsStack-SG-Fedramp"
  }

  vpc_id = var.vpc_id
}

