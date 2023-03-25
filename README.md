# Provision-Azure-VM

This repository contains scripts and templates for provisioning virtual machines (Ubuntu VMs) in Microsoft Azure using Azure CLI (az commands) and Bash scripts. These scripts can be used to automate the deployment of VMs, configure networking, and install software through cloud-init on the VMs.

## Usage

### Quick Start
To use these scripts to provision a VM in Azure, follow these steps:

1. Clone or download the repository to your local machine.

2. Open a Bash terminal and navigate to the Provision-Azure-VM directory.

3. Set up an Azure service principal with the necessary permissions to create and manage Azure resources. You can use the Azure CLI command _az login_.

4. Run the provision_vm_cli.sh script to create a new Azure resource group and provision the VM.

5. Wait for the script to complete. Once it's finished, you should see the new VM listed in the Azure portal.

### The Scripts

```bash
provision_vm_cli.sh <cloud-init-file> <port-to-open>
```

Example
```bash
. ./provision_vm_cli.sh cloud_init_nginx.yaml 80
./ssh_to_vm.sh
```

> Note the space between the dots in the the first command. It's used to export some variables to the calling shell. This makes it possible to use these variables in the consecutive calls, such as the ssh_to_vm.sh in this example.


## Notes

These scripts are provided as-is, without any warranty or support. Use them at your own risk.

Before using these scripts in a production environment, be sure to review and customize the configuration to meet your specific needs.

For more information on Azure CLI and Bash scripting in Azure, see the Azure documentation.