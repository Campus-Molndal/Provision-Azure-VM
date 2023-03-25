#!/bin/bash

IP=$(az vm show -d -g $RESOURCE_GRP -n $SERVER_NAME --query publicIps -o tsv)
ssh -i $KEY -o StrictHostKeyChecking=no $USR@$IP

