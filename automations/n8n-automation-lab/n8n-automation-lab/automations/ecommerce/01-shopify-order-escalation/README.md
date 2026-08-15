# Shopify Order Exception Escalation

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** Shopify merchants  
**Recurring-revenue potential:** High

## Business problem
Detect high-risk or operationally important orders and route them to the right person quickly.

## MVP workflow

```text
Shopify order trigger
  ↓
Enrich order/customer
  ↓
Evaluate rules
  ├── VIP/high-value → priority notification
  ├── fulfillment issue → ops ticket
  ├── risk condition → review queue
  └── normal → log only
```

## Likely integrations
- Shopify
- Slack/Teams/Email
- Ticketing/Task platform

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $750–$2,500 setup + $99–$299/mo

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
