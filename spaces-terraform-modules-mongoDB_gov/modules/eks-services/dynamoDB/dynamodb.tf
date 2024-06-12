module dynamdodb_creation {
    source = "../modules/dynamodb"
    hashkey = var.hashkey
    dynamodb_name = var.dynamodb_name
    range_key = var.range_key
}