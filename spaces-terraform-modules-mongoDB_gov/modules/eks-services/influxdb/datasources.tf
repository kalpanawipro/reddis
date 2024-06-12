data "aws_availability_zones" "ads" {
  state = "available"
  filter {
    name = "zone-name"
    values = ["us-gov-west-1a","us-gov-west-1b","us-gov-west-1c"]
  }
}

# data "aws_subnet" "network_subnet" {
#   id = "subnet-09bc3d2deb8f01877"
# }