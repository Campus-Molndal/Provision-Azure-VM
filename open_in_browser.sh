#!/bin/bash

IP=$(az vm show -d -g $RESOURCE_GRP -n $SERVER_NAME --query publicIps -o tsv)
URL="http://$IP:$OPEN_PORT"

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  open -a firefox $URL
elif [[ "$OSTYPE" == "msys" ]]; then
  # Windows
  start "" $URL
else
  echo "Unsupported operating system: $OSTYPE"
fi
