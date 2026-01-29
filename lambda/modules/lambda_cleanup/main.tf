resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.environment}-lambda-snapshot-cleanup-role"

  assume_role_policy = jsonencode({
    Version = "2012‑10‑17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = { Service = "lambda.amazonaws.com" }
        Effect    = "Allow"
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-lambda-snapshot-cleanup-role"
    Environment = var.environment
    Service     = "snapshot-cleanup"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.environment}-lambda-snapshot-cleanup-policy"
  description = "Policy for snapshot cleanup Lambda in ${var.environment}"

  policy = jsonencode({
    Version = "2012‑10‑17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:DescribeSnapshots",
          "ec2:DeleteSnapshot"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-lambda-snapshot-cleanup-policy"
    Environment = var.environment
    Service     = "snapshot-cleanup"
  }
}

resource "aws_iam_role_policy_attachment" "attach_custom" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_vpc_access" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_lambda_function" "snapshot_cleanup" {
  function_name = "${var.environment}-snapshot-cleanup"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  filename      = var.deployment_package
  source_code_hash = filebase64sha256(var.deployment_package)

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  environment {
    variables = {
      REGION   = var.region
      AGE_DAYS = tostring(var.age_days)
    }
  }

  memory_size = var.memory_size
  timeout     = var.timeout

  tags = {
    Name        = "${var.environment}-snapshot-cleanup-lambda"
    Environment = var.environment
    Service     = "snapshot-cleanup"
  }
}