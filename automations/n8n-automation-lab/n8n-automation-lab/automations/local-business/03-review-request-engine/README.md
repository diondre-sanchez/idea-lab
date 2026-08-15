# Review Request Engine

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** Local service businesses  
**Recurring-revenue potential:** Medium-High

## Business problem
Automatically request reviews after a completed job while suppressing duplicates and respecting customer contact preferences.

## MVP workflow

```text
Job completed event
  ↓
Validate customer + consent
  ↓
Delay
  ↓
Send review request
  ↓
Optional reminder
  ↓
Record status
```

## Likely integrations
- CRM/field-service platform
- SMS/Email
- Data store

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $500–$1,500 setup + $79–$199/mo

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
