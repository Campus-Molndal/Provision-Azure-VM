#!/bin/bash

set -a

# --------------------------------
# Provision Resource Group
# --------------------------------

export RESOURCE_GRP='DevRG'
LOCATION='northeurope'

# Create a resource group
az group create --name $RESOURCE_GRP --location $LOCATION

# --------------------------------
# Provision Virtual Machine
# --------------------------------

export SERVER_NAME='DevServer'
export USR='azureuser'
SERVER_SIZE='Standard_B1ls'
export OPEN_PORT=$2
CLOUD_INIT_FILE=$1

# Create SSH keys
KEYPATH="$(pwd)/keys"
export KEY="$KEYPATH/$SERVER_NAME"

mkdir -p $KEYPATH
ssh-keygen -q -t rsa -N '' -f $KEY <<<y
chmod 400 $KEY

# Create the Azure VM (An Ubuntu VM with Public IP)
az vm create --resource-group $RESOURCE_GRP --name $SERVER_NAME \
    --image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
    --admin-username $USR \
    --ssh-key-values $KEY.pub \
    --size $SERVER_SIZE \
    --public-ip-sku Standard \
    --custom-data $CLOUD_INIT_FILE

# Open a port to the VM
az vm open-port --resource-group $RESOURCE_GRP --name $SERVER_NAME --port $OPEN_PORT
