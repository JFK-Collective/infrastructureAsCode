#!/bin/bash
# checkDeployedRG.sh
# Lists all Azure resource groups containing 'jfk' in their name

PREFIX="jfk"

echo "Checking active resource groups containing prefix '$PREFIX'..."

RG_LIST=$(az group list --query "[?contains(name, '$PREFIX')].name" -o tsv)

if [ -n "$RG_LIST" ]; then
    echo "Found the following resource groups:"
    echo "$RG_LIST"
else
    echo "No resource groups found with prefix '$PREFIX'"
fi
