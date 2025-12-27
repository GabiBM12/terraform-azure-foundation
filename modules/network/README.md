# Network Module

Creates the core networking components for the Azure foundation.

---

## Resources Created

- Virtual Network
- Subnets (public / private)
- Subnet policy configuration

---

## Design Notes

- CIDR ranges are provided as inputs
- Subnets are created dynamically
- No security rules are defined here
- Network security is handled by the security module