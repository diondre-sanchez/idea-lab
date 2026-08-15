# Missed-Call Text-Back

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** Local service businesses  
**Recurring-revenue potential:** High

## Business problem
Turn missed inbound calls into text conversations before the prospect calls a competitor.

## MVP workflow

```text
Phone event/webhook
  ↓
Was call missed?
  ↓ yes
Check business hours + dedupe
  ↓
Send SMS
  ↓
Log lead
  ↓
Notify staff if customer replies
```

## Likely integrations
- Phone/SMS provider
- CRM
- Slack/Teams/Email

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $750–$2,000 setup + $99–$299/mo

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
