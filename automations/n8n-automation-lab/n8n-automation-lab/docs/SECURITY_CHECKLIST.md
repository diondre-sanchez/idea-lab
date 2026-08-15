# Security Checklist

Complete before publishing or deploying a workflow.

## Secrets
- [ ] No API keys in workflow JSON.
- [ ] No passwords in workflow JSON.
- [ ] No bearer tokens in workflow JSON.
- [ ] No webhook secrets committed to Git.
- [ ] `.env` is ignored by Git.
- [ ] Credentials use least privilege.

## Data handling
- [ ] PII collected only when required.
- [ ] Logs do not expose sensitive payloads unnecessarily.
- [ ] Customer data is not copied into test fixtures without sanitization.
- [ ] Retention requirements are documented.
- [ ] External AI/API providers receive only necessary fields.

## Workflow behavior
- [ ] Input is validated.
- [ ] External URLs are constrained where appropriate.
- [ ] Duplicate-event handling exists.
- [ ] Destructive actions require safeguards.
- [ ] Administrative/security actions have an audit trail.

## GitHub publishing
- [ ] Exported n8n JSON manually reviewed.
- [ ] Credential names/identifiers reviewed and sanitized when appropriate.
- [ ] Customer names/domains removed.
- [ ] Internal IPs/hostnames removed.
- [ ] Screenshots contain no secrets or private data.
