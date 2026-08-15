# Phishing / Domain Triage

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** Security teams / MSPs  
**Recurring-revenue potential:** High

## Business problem
Enrich suspicious URLs/domains and produce a consistent triage record for analyst review.

## MVP workflow

```text
Submission webhook/email
  ↓
Parse URLs/domains
  ↓
Normalize + validate
  ↓
Threat-intel lookups
  ↓
Score evidence
  ↓
Generate triage summary
  ↓
Ticket + analyst notification
```

## Likely integrations
- Email/Webhook
- Threat-intel APIs
- Ticketing
- Teams/Slack

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $1,500–$5,000 setup + $199–$699/mo

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
