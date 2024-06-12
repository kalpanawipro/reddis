resource "aws_launch_template" "custom_launch_template" {
  name = "${var.environment}-eks-custom-launch-template"
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 50
    }
  }
  user_data = filebase64("${path.module}/configs/custom_userdata.tmpl")
}
