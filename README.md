# Provision-Azure-VM
Scripts using AZ CLI commands to provision an Azure VM (Ubuntu) with Cloud Init

## Usage

```bash
provision_vm_cli.sh <cloud-init-file> <port-to-open>
```

Example
```bash
. ./provision_vm_cli.sh cloud_init_nginx.yaml 80
./ssh_to_vm.sh
```

> Note the space between the dots in the the first command. It's used to export some variables to the calling shell. This makes it possible to use these variables in the consecutive calls, such as the ssh_to_vm.sh in this example.



