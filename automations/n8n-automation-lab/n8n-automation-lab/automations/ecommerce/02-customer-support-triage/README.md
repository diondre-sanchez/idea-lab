# Customer Support Triage

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** E-commerce merchants  
**Recurring-revenue potential:** High

## Business problem
Classify inbound support requests, extract order context, prioritize urgent issues, and route tickets.

## MVP workflow

```text
Inbox/helpdesk trigger
  ↓
Extract customer/order identifiers
  ↓
Fetch order context
  ↓
Classify intent + urgency
  ↓
Route / tag / draft response
  ↓
Escalate high-risk cases
```

## Likely integrations
- Email/helpdesk
- Shopify
- AI model (optional)
- Slack/Teams

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
