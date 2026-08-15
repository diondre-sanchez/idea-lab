# n8n Automation Lab

A GitHub-ready workspace for designing, building, testing, and productizing n8n automations.

The goal is not to collect random workflows. The goal is to build **repeatable automation products** that can be deployed for multiple clients with minimal customization.

## Repository goals

1. Build useful n8n workflows.
2. Document the business problem each workflow solves.
3. Make workflows reusable across customers.
4. Separate secrets and customer-specific settings from workflow logic.
5. Track testing, failure handling, and support requirements.
6. Identify workflows that can become recurring-revenue services.

## Priority tracks

| Track | Why build it | Monetization potential |
|---|---|---|
| Local Business | Direct link to leads, appointments, reviews, and revenue | High |
| E-commerce / Shopify | Repeatable across many stores | High |
| Security / IT | Higher technical barrier and higher-value buyers | High |
| Internal Operations | Easy to demonstrate and useful across industries | Medium-High |

## Repository structure

```text
n8n-automation-lab/
├── .github/
│   └── ISSUE_TEMPLATE/
├── docs/
│   ├── BACKLOG.md
│   ├── BUILD_STANDARDS.md
│   ├── SECURITY_CHECKLIST.md
│   └── PRODUCTIZATION.md
├── templates/
│   ├── AUTOMATION_SPEC.md
│   ├── TEST_PLAN.md
│   ├── CLIENT_DEPLOYMENT.md
│   └── .env.example
├── automations/
│   ├── local-business/
│   ├── ecommerce/
│   ├── security-it/
│   └── operations/
└── README.md
```

## Workflow lifecycle

```text
IDEA
  ↓
SPEC
  ↓
BUILD
  ↓
LOCAL TEST
  ↓
FAILURE / RETRY TEST
  ↓
SANITIZE EXPORT
  ↓
COMMIT TO GIT
  ↓
PILOT CUSTOMER
  ↓
STANDARDIZE
  ↓
PRODUCTIZE
```

## Recommended naming convention

Use:

```text
<category>-<business-process>-<version>
```

Examples:

```text
local-lead-followup-v1
ecom-order-escalation-v1
sec-alert-enrichment-v1
ops-client-onboarding-v1
```

## Working on an automation

1. Copy `templates/AUTOMATION_SPEC.md` into the automation folder.
2. Define the business outcome before opening n8n.
3. Build the smallest useful version.
4. Export the workflow JSON into that project's `workflow/` directory.
5. Sanitize the export before committing it.
6. Complete the test plan.
7. Add screenshots/demo notes when the workflow works.
8. Record what must change for a second customer.

## Important: secrets and exported workflows

Never commit API keys, tokens, passwords, webhook secrets, customer data, or private URLs.

n8n workflow exports can contain credential references such as credential names and IDs. Review exported JSON before committing it, especially to a public repository.

Use `.env.example` for variable names only. Store actual secrets in n8n credentials, environment variables, or an external secrets system.

## First builds I recommend

Start with these three:

1. `local-business/01-lead-intake-followup`
2. `ecommerce/01-shopify-order-escalation`
3. `security-it/01-security-alert-enrichment`

They give you three different portfolio pieces while teaching the same core n8n skills: triggers, APIs, branching, state, notifications, retries, and observability.
