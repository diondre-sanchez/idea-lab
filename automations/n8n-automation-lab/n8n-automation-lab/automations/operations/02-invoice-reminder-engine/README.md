# Invoice Reminder Engine

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** SMBs / agencies  
**Recurring-revenue potential:** High

## Business problem
Automate polite payment reminders and internal escalation around unpaid invoices.

## MVP workflow

```text
Scheduled trigger
  ↓
Fetch unpaid invoices
  ↓
Calculate aging
  ↓
Select reminder stage
  ↓
Send customer reminder
  ↓
Escalate severe aging internally
  ↓
Log contact
```

## Likely integrations
- Accounting platform
- Email
- CRM/Slack/Teams

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $750–$2,000 setup + $99–$249/mo

Pricing is a hypothesis to validate, not a market guarantee. Tie pricing to customer value and support burden.

## Build checklist
- [ ] Copy and complete `templates/AUTOMATION_SPEC.md`.
- [ ] Define sample input payload.
- [ ] Build happy path.
- [ ] Add duplicate protection.
- [ ] Add error workflow / alerting.
- [ ] Run test plan.
- [ ] Export sanitized JSON to `workflow/`.
- [ ] Record a short demo.
- [ ] Deploy to a pilot environment.
- [ ] Capture lessons learned.
