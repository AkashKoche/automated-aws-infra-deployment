#!/bin/bash

echo "=== Infrastructure Validation Script ==="


command -v terraform >/dev/null 2>&1 || { echo "Terraform not found"; exit 1; }
command -v aws >/dev/null 2>&1 || { echo "AWS CLI not found"; exit 1; }


echo "Validating Terraform syntax..."
terraform validate


echo "Testing AWS connectivity..."
aws sts get-caller-identity


echo "Generating Terraform plan for validation..."
terraform plan -out=tfplan

echo "Validation complete!"
