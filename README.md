# HomeLab Proxmox Setup

## Description

Ansible resource to configure HomeLab server. It's designed to serve my needs, however you may find it useful for your individual application.

## Getting Started

### Prerequisites

- Python 3.11+

### Setting up a Python Virtual Environment

```bash
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r requirements.txt
```

### Using ssh keys for Proxmox host

```bash
# Create ssh key
ssh-keygen -t ed25519 -C "MyMacBookPro"

# Deploy ssh key to server (review IP address)
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@10.0.0.2
```

### Reviewing Ansible settings

Review `hosts.ini` file. Ensure that proxmox host IP is correct and alias matches the one used in the playbook.

`ansible-lint` lints Ansible yaml files in the project.

### Running configuration playbook

```bash
# -v provides verbose output
ansible-playbook playbooks/proxmox-setup.yml
```

## Virtualization

```bash
# Verify IOMMU is enabled
dmesg | grep  -i -e DMAR -e IOMMU

# Verify IOMMU interrupt remapping is enabled
dmesg | grep 'remapping'

# Verify IOMMU isolation
pvesh get /nodes/silverstone/hardware/pci --pci-class-blacklist ""
iommu-check.sh

# Check CPU frequency manager and governor
cpupower frequency-info
```
