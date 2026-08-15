# VIP Customer Alert

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** Shopify merchants  
**Recurring-revenue potential:** Medium

## Business problem
Detect valuable customers/orders and notify staff for high-touch fulfillment or retention actions.

## MVP workflow

```text
Shopify order
  ↓
Calculate customer value signals
  ↓
VIP threshold?
  ├── Yes → tag customer + notify + create task
  └── No → end
```

## Likely integrations
- Shopify
- Slack/Email
- CRM (optional)

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $300–$1,000 setup + $49–$149/mo

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
