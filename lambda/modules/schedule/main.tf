resource "aws_cloudwatch_event_rule" "daily" {
  name                = "${var.environment}-snapshot-cleanup-schedule"
  schedule_expression = var.cron_schedule
  description         = "Daily schedule rule for snapshot cleanup in ${var.environment}"

  tags = {
    Name        = "${var.environment}-snapshot-cleanup-rule"
    Environment = var.environment
    Service     = "snapshot-cleanup"
  }
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.daily.name
  target_id = "SnapshotCleanupLambdaTarget"
  arn       = var.lambda_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily.arn
}