# Productization Guide

A workflow becomes a business when it can be deployed repeatedly without rebuilding it from scratch.

## Productization test

A strong candidate should have:

- A specific buyer.
- A painful recurring problem.
- A measurable result.
- A mostly repeatable workflow.
- Limited per-client customization.
- A reason for ongoing monitoring/support.

## Convert a custom workflow into a product

### Step 1 — Build once
Solve the problem manually for one environment.

### Step 2 — Identify variables
Separate customer-specific values from logic.

Typical variables:
- company name
- API credentials
- CRM stage IDs
- notification channels
- phone numbers
- escalation thresholds
- email templates

### Step 3 — Standardize onboarding
Create a deployment checklist that a future technician could follow.

### Step 4 — Add monitoring
A monthly service fee is easier to justify when you provide:
- uptime/failure monitoring
- workflow fixes
- API compatibility maintenance
- monthly execution summary
- optimization

### Step 5 — Define tiers
Example structure:

```text
STARTER
One workflow + basic notifications

PRO
Workflow + follow-up logic + reporting

MANAGED
Multiple workflows + monitoring + monthly optimization
```

## Track these metrics

- setup hours per customer
- monthly support hours per customer
- executions per month
- error rate
- customer business outcome
- gross margin
- churn
- feature requests shared by multiple customers

The goal is for **setup hours and support hours to decline** as customer count increases.
