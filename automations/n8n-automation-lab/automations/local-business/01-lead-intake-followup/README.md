# Lead Intake + Follow-Up

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** Local service businesses  
**Recurring-revenue potential:** High

## Business problem
Capture a new lead, respond immediately, create/update the CRM record, schedule follow-up, and notify the owner.

## MVP workflow

```text
Webhook / lead form
  ↓
Validate + normalize lead
  ↓
Deduplicate
  ↓
Create/update CRM contact
  ↓
Send immediate SMS/email
  ↓
Wait / check response
  ├── Responded → update CRM + notify owner
  └── No response → follow-up sequence
```

## Likely integrations
- Webhook/Form
- CRM
- SMS provider
- Email
- Calendar (optional)

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $1,000–$3,000 setup + $149–$399/mo

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
