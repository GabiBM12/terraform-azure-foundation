# Security Module (NSG Baseline)

Creates baseline Network Security Groups (NSGs) for the foundation network and
associates them to `public` and `private` subnets.

## Resources
- 2x NSGs: public, private
- Subnet-to-NSG associations for both subnets
- Optional SSH allow rule on the public NSG

## Inputs
- `subnet_ids`: map with keys `public` and `private`
- `allowed_ssh_source_cidrs`: list of CIDRs allowed to SSH into public subnet