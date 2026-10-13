# SAP BTP & Terraform Assistant Runbook

Keep this cheat sheet handy. Whenever you start a new conversation or session with me, you can use the prompts below.

---

## 🔑 1. The One-Time Setup (Your Only Action Item)

Before running BTP or Terraform commands, create your local `env.sh` file:

```bash
cp /home/atlan/AI_folder/env.sh.example /home/atlan/AI_folder/env.sh
chmod 600 /home/atlan/AI_folder/env.sh
```

Open `env.sh` and fill in:
- `BTP_GLOBALACCOUNT`: Your global account subdomain (e.g. `yourname-trial` from the BTP Cockpit).
- `BTP_USERNAME`: Your SAP Universal ID / email.
- `BTP_PASSWORD`: Your SAP password.

*(Note: `env.sh` is in `.gitignore`, so your credentials will never be pushed to GitHub.)*

---

## 💬 2. Kickoff Prompts (What to Tell Me in a New Session)

Whenever you open a new session, you can paste any of these kickoff prompts:

### 🟢 Option A: "Warm up & check status"
> *"Hi Antigravity! I'm ready to work on my SAP BTP project. Can you verify my credentials in `env.sh`, log me in with the BTP CLI, and show my current subaccounts and entitlements?"*

### 🟡 Option B: "Review infrastructure & plan changes"
> *"Please run `terraform init` and `terraform plan` on my BTP configuration and tell me what resources are currently managed."*

### 🔵 Option C: "Add a new service or destination"
> *"I want to add an entitlement for the Destination service (`lite` plan) and create an HTTP destination named `Northwind`. Please create a new feature branch, update the Terraform code, and run a plan."*

---

## 📋 3. Menu of Everyday Prompts

Here are examples of natural language commands you can give me at any time:

### Account & Exploration
| What you want | What to say to me |
| :--- | :--- |
| **Check BTP status** | *"Run `btp-status.sh` and list all subaccounts."* |
| **Check active target** | *"What is my current active BTP target context?"* |
| **Check available services** | *"List available service offerings in my trial subaccount."* |

### Infrastructure Changes (Terraform)
| What you want | What to say to me |
| :--- | :--- |
| **Add a destination** | *"Add a destination named `ERP_Mock` pointing to `https://api.example.com`."* |
| **Add an entitlement** | *"Add the `xsuaa` service with plan `application` to my entitlements."* |
| **Assign role collection** | *"Assign the `Subaccount Administrator` role to my email address."* |
| **Preview changes** | *"Run a dry-run `terraform plan` and explain what will be created."* |
| **Apply changes** | *"Apply the Terraform changes to my SAP BTP account."* |

### Cloud Foundry & Deployments
| What you want | What to say to me |
| :--- | :--- |
| **Log in to CF** | *"Log me in to Cloud Foundry using `cf-login.sh`."* |
| **List CF apps** | *"Show all running Cloud Foundry applications and spaces."* |
| **Deploy MTA package** | *"Deploy the MTA archive in this folder using `cf deploy`."* |

### Git & GitHub (Pro Workflow)
| What you want | What to say to me |
| :--- | :--- |
| **New feature branch** | *"Create a new branch `feat/add-destination` for our next change."* |
| **Commit & Push** | *"Commit my changes with a clean message and push to GitHub."* |
| **Check CI status** | *"Check if the GitHub Actions CI passed on my latest commit."* |

---

## 🔄 4. The Standard 5-Step Pro Cycle

```text
1. Tell me what you want to add/change (e.g. "Add a destination")
2. I create a feature branch and update Terraform
3. We run `terraform plan` to preview the change safely
4. We run `terraform apply` to provision it in BTP
5. I push the branch to GitHub for Pull Request review (CI tests run automatically)
```
