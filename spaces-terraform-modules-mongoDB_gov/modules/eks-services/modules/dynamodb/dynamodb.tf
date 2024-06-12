resource "aws_dynamodb_table" "dynamoDb_creation" {
  for_each = toset(var.dynamodb_name)
  attribute {
    name = "customerKey"
    type = "S"
  }

  attribute {
    name = "reportKey"
    type = "S"
  }

  billing_mode = "PROVISIONED"
  hash_key     = var.hashkey #"reportKey"
  name         = each.key #"SGAnalyticsQueries"

  point_in_time_recovery {
    enabled = "false"
  }

  range_key      = var.range_key #"customerKey"
  read_capacity  = "5"
  stream_enabled = "false"
  write_capacity = "5"
}
