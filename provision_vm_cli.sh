#!/bin/bash

set -a

# --------------------------------
# Set default values
# --------------------------------

export RESOURCE_GRP='DemoRG'
LOCATION='northeurope'

export SERVER_NAME='DemoServer'
export USR='azureuser'
SERVER_SIZE='Standard_B1ls'
export OPEN_PORT=""
CLOUD_INIT_FILE=""

# --------------------------------
# Check arguments
# --------------------------------

# Only these cloud init files are allowed. Add here if new ones are developed
allowed_files=(cloud_init_dotnet.yaml cloud_init_docker.yaml cloud_init_nginx.yaml)

function usage {
  echo "Usage: $0 [-f <cloud_init_file>] [-n <server_name>] [-p <port>] [-g <resource_group>] [-h]"
  echo "Options:"
  echo "  -f  <cloud_init_file>   The cloud-init file to use"
  echo "  -n  <server_name>       The name of the server"
  echo "  -p  <port>              The port to use"
  echo "  -g  <resource_group>    The name of the resource group"
  echo "  -h                      Display this help message"
}

while getopts ":f:n:p:g:h" opt; do
  case $opt in
    f)
      if [[ " ${allowed_files[@]} " =~ " $OPTARG " ]]; then
        cloud_init_file="$OPTARG"
      else
        echo "Invalid cloud init file specified. Allowed files: ${allowed_files[*]}" >&2
        usage
        exit 1
      fi
      ;;
    n)
      server_name="$OPTARG"
      ;;
    p)
      port="$OPTARG"
      # Check if the port option (-p) is a valid port number
      if [[ $port =~ ^[0-9]+$ ]] && ((port >= 1 && port <= 65535)); then
        echo "Valid port number: $port"
      else
        echo "Invalid port number: $port" >&2
        exit 1
      fi
      ;;
    g)
      resource_group="$OPTARG"
      RESOURCE_GRP=$resource_group
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
  esac
done

if [ -z "$cloud_init_file" ]; then
  echo "No cloud init file specified with -f option"
fi

if [ -n "$server_name" ]; then
  SERVER_NAME=$server_name
fi
echo "Server name specified: $SERVER_NAME"

if [ -n "$port" ]; then
  OPEN_PORT=$port
  echo "Port specified: $OPEN_PORT"
else
  echo "No port specified with -p option"
fi

echo "Resource group specified: $RESOURCE_GRP"

# --------------------------------
# Provision Resource Group
# --------------------------------

# Create a resource group
az group create --name $RESOURCE_GRP --location $LOCATION

# --------------------------------
# Create SSH Keys
# --------------------------------

# Create SSH keys
KEYPATH="$(pwd)/keys"
export KEY="$KEYPATH/$SERVER_NAME"

mkdir -p $KEYPATH
ssh-keygen -q -t rsa -N '' -f $KEY <<<y
chmod 400 $KEY

# --------------------------------
# Provision Virtual Machine
# --------------------------------

# Create the Azure VM (An Ubuntu VM with Public IP)
az vm create --resource-group $RESOURCE_GRP --name $SERVER_NAME \
    --image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest \
    --admin-username $USR \
    --ssh-key-values $KEY.pub \
    --size $SERVER_SIZE \
    --public-ip-sku Standard \
    --custom-data @$cloud_init_file

if [ -n "$OPEN_PORT" ]; then
  # Open a port to the VM
  echo "Opening port $OPEN_PORT ..."
  az vm open-port --resource-group $RESOURCE_GRP --name $SERVER_NAME --port $OPEN_PORT > /dev/null
fi

