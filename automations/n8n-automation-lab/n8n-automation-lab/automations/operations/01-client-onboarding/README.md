# Client Onboarding Orchestrator

**Status:** IDEA  
**Version:** v0.1  
**Target buyer:** Agencies / MSPs / consultants  
**Recurring-revenue potential:** High

## Business problem
Create a repeatable client onboarding process across CRM, project management, folders, communication, and reminders.

## MVP workflow

```text
Deal marked Won
  ↓
Validate client data
  ↓
Create project/tasks
  ↓
Create client folder
  ↓
Send welcome email
  ↓
Schedule kickoff / reminders
  ↓
Notify internal team
```

## Likely integrations
- CRM
- Project management
- Cloud storage
- Email
- Calendar

## MVP success metric
Define one measurable metric before building, such as response time, analyst minutes saved, conversion rate, exception handling time, or number of manual touches eliminated.

## Productization questions
- What changes for every customer?
- Which values can become configuration variables?
- Which credentials are customer-specific?
- What failure requires human intervention?
- What can be monitored centrally?

## Monetization hypothesis
**Starting experiment:** $1,000–$3,500 setup + $99–$299/mo

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
