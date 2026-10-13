# SAP BTP Infrastructure as Code & Management Workspace

This workspace is fully equipped to manage **SAP Business Technology Platform (SAP BTP)** resources using **Terraform** and native SAP tools directly through this prompt.

---

## 🛠️ Installed & Configured Tooling

| Tool | Version | Purpose |
| :--- | :--- | :--- |
| **Terraform** | `1.16.5` | Infrastructure as Code orchestration |
| **SAP BTP Provider** | `~> 1.27.0` | Official Terraform provider (`SAP/btp`) |
| **SAP BTP CLI (`btp`)** | `2.116.3` | Account & global administration CLI |
| **Cloud Foundry CLI (`cf`)**| `8.19.0` | Cloud Foundry runtime management |
| **Multiapps Plugin** | `3.11.1` | MTA application deployment plugin (`cf deploy`) |
| **jq** | `1.6` | JSON stream processing & parsing |

---

## 📁 Workspace Layout

```text
.
├── env.sh.example           # Template for authentication credentials
├── scripts/
│   ├── btp-login.sh         # Helper to authenticate with SAP BTP CLI
│   ├── btp-status.sh        # Queries current target, subaccounts, and status
│   ├── cf-login.sh          # Helper to log in to Cloud Foundry
│   └── tf-run.sh            # Runs Terraform with loaded BTP environment
├── terraform/
│   ├── versions.tf          # Terraform & provider requirements
│   ├── main.tf              # Subaccounts, entitlements, CF, destinations, roles
│   ├── variables.tf         # Input variable declarations
│   ├── outputs.tf           # Output values (GUIDs, endpoints, etc.)
│   └── terraform.tfvars.example # Sample variable configurations
└── README.md
```

---

## 🚀 Quickstart: Connecting Your SAP BTP Account

### 1. Configure Authentication
Copy `env.sh.example` to `env.sh` and set your credentials:

```bash
cp env.sh.example env.sh
chmod 600 env.sh
```

Edit `env.sh` with:
- `BTP_GLOBALACCOUNT`: Your global account subdomain (e.g., `user123trial` for trial accounts).
- `BTP_USERNAME`: Your SAP Universal ID / email address.
- `BTP_PASSWORD`: Your SAP BTP account password.

### 2. Log in with BTP CLI
Run:
```bash
./scripts/btp-login.sh
```
Or simply tell me in the prompt:
> *"Log in to BTP using my credentials in env.sh"*

### 3. Check Subaccounts & Environments
Run:
```bash
./scripts/btp-status.sh
```
Or tell me:
> *"Show my current BTP subaccounts and environments."*

---

## 🏗️ Managing Resources with Terraform

### Running Terraform
You can run Terraform using the helper script:
```bash
./scripts/tf-run.sh plan
./scripts/tf-run.sh apply
```

### SAP BTP Trial Account Specifics
Trial accounts come with a pre-created subaccount named `trial`.
In [`terraform.tfvars`](file:///home/atlan/AI_folder/terraform/terraform.tfvars.example):
- Set `create_subaccount = false`
- Set `subaccount_name = "trial"` (or specify `subaccount_id` GUID directly)
- Terraform will query your existing subaccount and manage its services, destinations, and roles without attempting to create an extra subaccount.

### Supported Terraform Resources in this Project
- **Subaccounts**: Lookup existing or create new subaccounts (`btp_subaccount`).
- **Entitlements**: Provision service plans and quotas (`btp_subaccount_entitlement`).
- **Cloud Foundry**: Spin up Cloud Foundry environments and assign org managers (`btp_subaccount_environment_instance`).
- **Destinations**: Configure HTTP/RFC internet or on-premise destinations (`btp_subaccount_destination_generic`).
- **Security**: Manage custom role collections (`btp_subaccount_role_collection`) and assign them to users (`btp_subaccount_role_collection_assignment`).

---

## 💬 Actions You Can Ask in this Prompt

You can manage your BTP infrastructure entirely via natural language prompts here:

- **Check status**: *"Check if my BTP session is active and list my subaccounts."*
- **Plan infrastructure**: *"Run a terraform plan for the current configuration."*
- **Add entitlements**: *"Add an entitlement for the Destination service (lite plan) in my trial subaccount."*
- **Create destinations**: *"Configure a destination named Northwind pointing to https://services.odata.org/v4/northwind/northwind.svc/"*
- **Manage CF & apps**: *"Deploy this MTA project using cf deploy."*
- **Assign permissions**: *"Assign the Subaccount Administrator role collection to my email."*
