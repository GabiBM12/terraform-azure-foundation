# Compute Module (Private Linux VM)

Deploys a Linux VM intended to run in a **private subnet** (no public IP).
Azure Monitor Agent (AMA) installed as a VM extension.
DCR Association linking VM → DCR.

## What it creates
- Network Interface (NIC) in the provided subnet
- Ubuntu 22.04 LTS Gen2 Linux VM (SSH key only)

## Inputs
- `subnet_id` should be the **private subnet** for Option A
- `ssh_public_key` should be the key **contents** (use `file()` in the environment)

## Outputs
- `vm_id`
- `nic_id`
- `private_ip`

## Notes
This module intentionally does **not** create a Public IP.
Access is expected via Bastion (Developer SKU) or a private connectivity method.