#!/bin/bash
# Bruk: ./destroy.sh <environment>
# Eksempel: ./destroy.sh dev

#Denne kommandoen vil stoppe skriptet hvis en kommando feiler
set -e

ENV=$1
if [ -z "$ENV" ]; then
  echo "Usage: $0 <environment>"
  exit 1
fi

TFVARS_FILE="${ENV}.tfvars"

cd "environments/${ENV}"

echo "=== Destroying resources for $ENV ==="
terraform destroy -var-file="$TFVARS_FILE" -auto-approve
echo "=== Destroying complete for $ENV ==="