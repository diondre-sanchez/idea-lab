# Automation Spec — <Name>

## Status
`IDEA | DESIGN | BUILDING | TESTING | PILOT | PRODUCTION`

## Version
`v0.1`

## Category
`Local Business | E-commerce | Security/IT | Operations`

## Problem
Describe the manual process or business problem in 2–4 sentences.

## Buyer / User
Who would pay for or operate this automation?

## Desired business outcome
What measurable result should improve?

Examples:
- response time
- booked appointments
- recovered revenue
- analyst minutes per alert
- ticket resolution time
- review conversion rate

## Trigger
What starts the automation?

## Inputs
| Input | Source | Required | Sensitive? |
|---|---|---:|---:|
| | | | |

## Integrations
- [ ] Integration 1
- [ ] Integration 2
- [ ] Integration 3

## Workflow map

```text
TRIGGER
  ↓
VALIDATE
  ↓
ENRICH
  ↓
DECIDE
  ├── PATH A → ACTION → LOG
  └── PATH B → ACTION → LOG
                       ↓
                   NOTIFY
```

## Business rules
1. 
2. 
3. 

## Configuration variables
| Variable | Purpose | Example placeholder |
|---|---|---|
| | | |

## Credentials required
Document credential *types*, not actual values.

## Error handling
| Failure | Desired behavior |
|---|---|
| API timeout | |
| Rate limit | |
| Authentication error | |
| Invalid input | |
| Duplicate event | |

## Logging / observability
What should be logged and where?

## MVP definition
The smallest version that provides real value.

## V2 ideas
- 
- 

## Security considerations
- 
- 

## Monetization hypothesis
**Setup:** $

**Monthly:** $

**Value proposition:**

## Definition of done
- [ ] Happy path works.
- [ ] Invalid input tested.
- [ ] Failure path tested.
- [ ] Duplicate behavior tested.
- [ ] Secrets removed from export.
- [ ] README updated.
- [ ] Demo evidence captured.
