# Security Alert Enrichment

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** Security teams / MSPs  
**Recurring-revenue potential:** Very High

## Business problem
Reduce analyst triage time by enriching security alerts with threat context before creating/escalating a case.

## MVP workflow

```text
Security alert webhook/API
  ↓
Normalize entities
  ↓
Extract IP/domain/hash/user
  ↓
Threat-intel enrichment
  ↓
Risk scoring / rules
  ↓
Create/update ticket
  ↓
Notify analyst
  ↓
Audit log
```

## Likely integrations
- SIEM/EDR API
- Threat-intel APIs
- Ticketing
- Teams/Slack/Email

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $2,000–$7,500 setup + $299–$999/mo

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
