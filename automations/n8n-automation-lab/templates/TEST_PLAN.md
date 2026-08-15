# Test Plan — <Automation Name>

## Test environment
- n8n environment:
- workflow version:
- test integrations:
- test date:

## Functional tests

| ID | Scenario | Input | Expected | Result |
|---|---|---|---|---|
| T01 | Happy path | | | |
| T02 | Missing required field | | | |
| T03 | Invalid value | | | |
| T04 | Duplicate event | | | |
| T05 | Downstream API unavailable | | | |
| T06 | Authentication failure | | | |
| T07 | Rate limit / retry | | | |

## Data validation
- [ ] Correct fields mapped.
- [ ] Dates/time zones correct.
- [ ] IDs preserved.
- [ ] Sensitive fields excluded from unnecessary logs.

## Recovery validation
- [ ] Failed execution is visible.
- [ ] Failure notification is sent.
- [ ] Retry does not duplicate side effects.
- [ ] Manual recovery procedure documented.

## Acceptance criteria
- [ ] Meets business outcome.
- [ ] No known critical defects.
- [ ] Error handling behaves as designed.
- [ ] Export sanitized before Git commit.
