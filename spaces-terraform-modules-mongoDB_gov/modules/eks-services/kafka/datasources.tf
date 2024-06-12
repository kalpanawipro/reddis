data "aws_availability_zones" "ads" {
  state = "available"
  filter {
    name = "zone-name"
    values = ["ap-southeast-1a","ap-southeast-1b", "ap-southeast-1c"]
  }
}