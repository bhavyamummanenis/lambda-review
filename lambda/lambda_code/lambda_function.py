import os
import logging
from datetime import datetime, timezone, timedelta

import boto3
from botocore.exceptions import ClientError

# Setup logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Environment Variables
REGION = os.getenv("REGION") or boto3.session.Session().region_name
AGE_DAYS = int(os.getenv("AGE_DAYS", "365"))
DRY_RUN = os.getenv("DRY_RUN", "false").lower() == "true"
EXCLUDED_TAG = "do-not-delete"

def lambda_handler(event, context):
    logger.info(f"Starting snapshot cleanup in region: {REGION}, age threshold: {AGE_DAYS} days, dry-run: {DRY_RUN}")
    
    ec2 = boto3.client("ec2", region_name=REGION)
    cutoff = datetime.now(timezone.utc) - timedelta(days=AGE_DAYS)
    logger.info(f"Deleting snapshots older than: {cutoff.isoformat()}")

    try:
        paginator = ec2.get_paginator("describe_snapshots")
        pages = paginator.paginate(OwnerIds=["self"])

        to_delete = []

        for page in pages:
            for snap in page.get("Snapshots", []):
                snap_id = snap.get("SnapshotId")
                start_time = snap.get("StartTime")
                tags = {t["Key"]: t["Value"] for t in snap.get("Tags", [])}

                if not snap_id or not start_time:
                    continue

                if start_time >= cutoff:
                    continue

                if EXCLUDED_TAG in tags:
                    logger.info(f"Skipping snapshot {snap_id} (tagged with '{EXCLUDED_TAG}')")
                    continue

                to_delete.append(snap_id)

        logger.info(f"Found {len(to_delete)} snapshots to delete")

        deleted = 0
        for snap_id in to_delete:
            try:
                if DRY_RUN:
                    logger.info(f"[DryRun] Would delete snapshot: {snap_id}")
                else:
                    logger.info(f"Deleting snapshot: {snap_id}")
                    ec2.delete_snapshot(SnapshotId=snap_id)
                    logger.info(f"Deleted snapshot: {snap_id}")
                    deleted += 1
            except ClientError as e:
                logger.error(f"Error deleting snapshot {snap_id}: {e}")

    except ClientError as e:
        logger.error(f"Failed to retrieve snapshots: {e}")
        raise

    return {
        "statusCode": 200,
        "body": f"Snapshot cleanup complete. Deleted: {deleted}, Skipped: {len(to_delete) - deleted}, Dry-run: {DRY_RUN}"
    }