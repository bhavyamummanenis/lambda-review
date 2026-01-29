#!/usr/bin/env bash
set -euo pipefail

# Navigate to project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# Define variables
LAMBDA_FILE="lambda_code/lambda_function.py"
ZIP_FILE="deployment_package.zip"

# Check if Lambda code exists
if [[ ! -f "$LAMBDA_FILE" ]]; then
  echo "Lambda function not found: $LAMBDA_FILE"
  exit 1
fi

# Remove existing zip
rm -f "$ZIP_FILE"

# Create deployment package
echo "Packaging Lambda function into $ZIP_FILE"
zip -r "$ZIP_FILE" "$LAMBDA_FILE" > /dev/null
echo "Package created:"
ls -lh "$ZIP_FILE"