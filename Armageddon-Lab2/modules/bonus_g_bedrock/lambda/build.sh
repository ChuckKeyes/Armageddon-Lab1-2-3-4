#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

rm -f lambda_ir_reporter.zip

pip install -r requirements.txt -t .

zip -r lambda_ir_reporter.zip handler.py *.py */ -x "*__pycache__*"
