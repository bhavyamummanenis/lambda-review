output "function_name" {
  description = "The name of the snapshot cleanup Lambda function"
  value       = aws_lambda_function.snapshot_cleanup.function_name
}

output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.snapshot_cleanup.arn
}

output "role_arn" {
  description = "The IAM Role ARN for the Lambda function"
  value       = aws_iam_role.lambda_exec_role.arn
}