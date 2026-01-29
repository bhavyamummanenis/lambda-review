output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "lambda_sg_id" {
  description = "Security Group ID for the Lambda function"
  value       = aws_security_group.lambda_sg.id
}