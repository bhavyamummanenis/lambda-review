Schedule module will create an EventBridge rule that triggers the snapshot‑cleanup Lambda on a daily configured schedule and we can also modify the cron job according to our requirement for removing the snapshots.

module "schedule_snapshot_cleanup" {
  source        = "../../modules/schedule"
  environment   = var.environment
  lambda_arn    = module.lambda_snapshot_cleanup.function_arn
  cron_schedule = "cron(0 3 * * ? *)" 
}