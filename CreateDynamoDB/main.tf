# Creating DynamoDB table
resource "aws_dynamodb_table" "DemoTB" {
	name = "DemoTB"
	hash_key = "ID"
	billing_mode = "PAY_PER_REQUEST"
	attribute {
	name = "ID"
	type = "N"
}
}

# Inserting Value to DemoTB
resource "aws_dynamodb_table_item" "DemoItem" {
	table_name = aws_dynamodb_table.DemoTB.name
	hash_key = aws_dynamodb_table.DemoTB.hash_key
	item = <<EOF
	{
		"ID":{"N":"1"},
		"NAME":{"S":"Madhup"}
}
EOF
depends_on = [
	aws_dynamodb_table.DemoTB
]
}
