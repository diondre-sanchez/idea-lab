# Build Standards

## Design principles

### 1. Business outcome first
Every workflow must answer:
- What manual task disappears?
- What revenue, time, or risk metric improves?
- Who notices when the workflow succeeds?
- Who notices when it fails?

### 2. Configuration over customization
Prefer reusable settings over editing workflow logic for each customer.

Examples:
- business name
- notification destination
- SLA threshold
- CRM pipeline ID
- escalation contacts
- AI prompt configuration

### 3. Idempotency
Where possible, rerunning the same event should not create duplicate tickets, messages, invoices, or CRM records.

### 4. Error paths are required
Production workflows should have explicit behavior for:
- API timeout
- rate limit
- invalid input
- authentication failure
- downstream service failure
- duplicate event
- partial completion

### 5. Observability
Record at minimum:
- workflow execution ID
- source event ID
- timestamp
- status
- failure reason
- customer/tenant identifier when applicable

### 6. Human approval for risky actions
Do not automatically perform destructive, financial, account-changing, or high-impact security actions without appropriate safeguards and authorization.

## Node organization

Use visual sections such as:

```text
01 INPUT
02 VALIDATION
03 ENRICHMENT
04 DECISION
05 ACTION
06 NOTIFICATION
07 LOGGING
08 ERROR HANDLING
```

## Workflow versioning

Use semantic-ish versions for meaningful releases:

```text
v0.1 - proof of concept
v0.5 - functional pilot
v1.0 - customer ready
v1.1 - backward-compatible improvement
v2.0 - breaking workflow redesign
```

Record material changes in the automation README.
