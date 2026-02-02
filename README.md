# Terraform AWS Multi-Environment Web Platform

This project demonstrates a production-style, multi-environment AWS web platform built using Terraform.

## Architecture
- VPC with public subnets across multiple AZs
- Application Load Balancer (HTTP)
- Auto Scaling Group running Apache
- Workspace-based environment isolation (dev / integration / prod)
- Modular Terraform design

## Environments
Environments are managed using Terraform workspaces:
- `dev`
- `integration`
- `prod`

Each environment has isolated state and environment-specific configuration.

## How to Deploy

### Bootstrap remote state
```bash
cd bootstrap
terraform init
terraform apply

cd live
terraform init
terraform workspace new dev
terraform apply

Notes

Terraform state is stored remotely in S3 with DynamoDB locking

No secrets or state files are committed to GitHub

Next Enhancements

HTTPS via ACM + Route53

Private subnets and RDS

AWS Config integration

Observability (Datadog / Prometheus)
---

## 3️⃣ First commit (clean baseline)
From repo root:

```powershell
git add .
git commit -m "Initial Terraform AWS multi-environment web platform"