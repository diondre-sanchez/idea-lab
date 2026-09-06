# Home Digital Twin

> Working names: **DwellOS** / **HouseMind**

## Product thesis

Give every physical asset in a home its own digital identity and AI expert, grounded in the exact documentation, warranty information, maintenance history, and lifecycle of that item.

This is not intended to be another generic home-maintenance checklist. The long-term goal is to create a **digital operating system for the home**: a persistent, structured record of the home's systems and assets with an intelligence layer that can answer questions, surface maintenance, preserve history, and help homeowners make better repair/replacement decisions.

## Problem

Homeowners typically have appliance manuals, receipts, warranty records, installer information, model numbers, service notes, and maintenance schedules scattered across paper files, email, manufacturer websites, photo libraries, calendars, and memory.

When something fails, the homeowner often has to:

1. Find the make/model or serial number.
2. Locate the correct manual.
3. Search through dozens or hundreds of pages.
4. Determine whether the issue is covered by warranty.
5. Remember whether the same problem happened before.
6. Find the correct replacement part or service provider.
7. Reconstruct the maintenance history.

Most of this information already exists. The problem is that it is fragmented and difficult to use when it matters.

## Core experience

A homeowner creates a home, adds rooms/systems, and registers assets such as:

- HVAC equipment
- Water heaters
- Refrigerators
- Dishwashers
- Washers and dryers
- Microwaves and ovens
- Garage doors/openers
- Plumbing fixtures
- Electrical equipment
- Generators
- Lawn equipment
- Networking/smart-home equipment
- TVs and electronics
- Roofing/flooring/paint information
- Other serviceable household assets

Each asset becomes a persistent record containing its identity, documents, maintenance, warranty, service history, and AI context.

### Example asset record

**Samsung Washer**

- Manufacturer
- Model
- Serial number
- Room/location
- Purchase date
- Purchase price
- Retailer
- Installer
- Warranty start/end dates
- Owner's manual
- Installation guide
- Service documentation
- Receipt
- Photos
- Replacement parts
- Maintenance schedule
- Completed maintenance
- Repair/service history
- Notes
- Lifecycle status

## AI manual intelligence

The flagship capability is not simply storing a manual. It is making the manual conversational.

A user should be able to open an asset and ask questions such as:

- "What does error E24 mean?"
- "How do I clean this filter?"
- "What clearance does this model require?"
- "Can I use aluminum foil in this microwave?"
- "What replacement filter does this unit need?"
- "How do I reset this appliance?"
- "What maintenance does the manufacturer recommend this year?"
- "Does the manual say I can repair this myself?"

The AI should retrieve information from the **exact documentation associated with that asset**, rather than answering generically.

### Response requirements

Whenever possible, AI answers should:

- Ground responses in the asset's exact documentation.
- Cite the manual/document and page or section used.
- Distinguish manufacturer guidance from general advice.
- Incorporate the home's maintenance/service history when relevant.
- Identify warranty implications.
- Avoid improvising hazardous repair procedures.
- Clearly recommend qualified service when documentation indicates professional service is required.

### Example

Instead of:

> E24 usually indicates a drainage problem.

The application could provide:

> Your Bosch dishwasher model XYZ lists E24 as a drainage-system fault. The manufacturer recommends checking the filter, drain hose, and pump cover in that order. Your service history shows the drain hose was replaced eight months ago, so the filter and pump cover are reasonable first checks. See Owner's Manual, p. 42.

That combination of **manufacturer documentation + exact asset identity + homeowner history** is a primary differentiator.

## MVP

The first useful version should remain intentionally narrow.

### Core hierarchy

`User → Home → Room/System → Asset`

### MVP capabilities

1. **Authentication and household creation**
   - Create an account.
   - Create a home.
   - Create rooms/locations or home systems.

2. **Asset inventory**
   - Add/edit/archive an asset.
   - Manufacturer, model, serial number, location, purchase information, warranty dates, and notes.

3. **Document storage**
   - Upload manuals, receipts, warranty documents, installation guides, photos, and related files.
   - Associate documents with the correct asset.

4. **Manual/document ingestion**
   - Extract text from supported documents.
   - Preserve document/page metadata.
   - Chunk and index content for retrieval.

5. **Asset-specific AI Q&A**
   - Ask questions about an asset.
   - Retrieve relevant documentation.
   - Generate grounded answers.
   - Provide document/page citations when available.

6. **Maintenance scheduling**
   - Create recurring maintenance activities.
   - Support manufacturer-recommended and user-defined schedules.
   - Mark maintenance complete and calculate next due date.

7. **Service history**
   - Record repair/service date, provider, notes, cost, documents, and outcome.

8. **Warranty tracking**
   - Store warranty terms and expiration dates.
   - Surface upcoming expiration dates.

## Initial data model

### Home

- ID
- Owner/household ID
- Name
- Address (optional / privacy-sensitive)
- Build year
- Home type
- Notes

### Room / Location

- ID
- Home ID
- Name
- Type
- Notes

### Asset

- ID
- Home ID
- Room/location ID
- Category
- Manufacturer
- Product name
- Model number
- Serial number
- Purchase date
- Purchase price
- Retailer
- Installer
- Installation date
- Warranty start
- Warranty expiration
- Expected service life
- Lifecycle status
- Notes

### Document

- ID
- Asset ID
- Document type
- Original filename
- Storage location
- Source
- Upload date
- Parsed/indexed status
- Page count
- Metadata

### Maintenance plan

- ID
- Asset ID
- Task
- Interval
- Source (manufacturer/user/system)
- Source document/page
- Last completed
- Next due
- Notes

### Service event

- ID
- Asset ID
- Date
- Service provider
- Problem
- Resolution
- Cost
- Warranty claim status
- Parts replaced
- Notes
- Attachments

## High-level architecture

A likely architecture will include:

```text
Web / Mobile Client
        |
        v
Application API
        |
        +-------------------+
        |                   |
        v                   v
Relational Database     Object Storage
(Home / Assets /        (Manuals / Receipts /
 Maintenance / History)  Photos / Warranties)
        |                   |
        |                   v
        |             Document Ingestion
        |                   |
        |             Parse / Chunk / Index
        |                   |
        +-----------> Retrieval Layer
                            |
                            v
                       AI Orchestration
                            |
                            v
                  Grounded Asset Answers
```

Technology choices are intentionally undecided at this stage. Selection should occur after the MVP requirements and deployment goals are finalized.

## Product differentiation

The product should avoid competing primarily as a reminder/checklist application.

The stronger positioning is:

### 1. Every asset has a digital identity

The application knows exactly which equipment belongs to the home rather than providing generic maintenance recommendations.

### 2. Every asset has an AI expert

The assistant understands documentation associated with the exact make/model.

### 3. The home has memory

Repairs, maintenance, parts, contractors, costs, warranty claims, and recurring issues remain attached to the asset for its lifetime.

### 4. Manufacturer-grounded responses

Answers should show their sources and distinguish manufacturer instructions from general AI reasoning.

### 5. Lifecycle intelligence

Over time the platform can reason about age, repair frequency, warranty status, maintenance, costs, and expected life to help answer questions such as:

- Is this worth repairing again?
- Which appliances are approaching end of life?
- What major household expenses may be approaching?

## Competitive landscape

Products already exist across portions of this space, including home inventory, maintenance, manuals, warranties, and emerging AI features. Examples identified during initial research include:

- HearthIQ
- Homer
- HomeAlmanac
- Homvio
- Hasset
- HomeNog
- Dwelluno

Before significant development, perform a structured competitive teardown covering:

- Asset inventory
- Manual discovery/storage
- Warranty tracking
- Maintenance reminders
- AI/manual Q&A
- Source citations
- Service history
- Parts intelligence
- Home sharing
- Home-sale transfer
- Integrations
- Pricing/business model
- Mobile experience
- Data portability

The key validation question is whether **deep manual-grounded AI combined with household-specific asset history and lifecycle intelligence** creates enough differentiation from existing products.

## Future capabilities / backlog

### Model and serial label scanning

Photograph an equipment label and automatically extract:

- Manufacturer
- Model
- Serial number
- Other identifiers

Potentially use the identified model to locate the correct manufacturer documentation.

### Automated manual discovery

Given manufacturer/model information, find the correct official manual or installation documentation and allow the user to confirm it before attaching it to the asset.

### Receipt intelligence

Upload or photograph a receipt and extract:

- Product
- Retailer
- Purchase date
- Price
- Model information
- Warranty-relevant dates

### Warranty intelligence

- Warranty expiration reminders
- Warranty document Q&A
- Identify whether a reported issue may still be covered
- Preserve warranty claim history

### Recall notifications

Match registered products against authoritative manufacturer/government recall information.

### Replacement-part intelligence

Identify compatible filters, consumables, and replacement parts for the exact asset.

### Maintenance generation from manuals

Extract maintenance recommendations directly from manufacturer documentation and suggest recurring schedules for user approval.

### Todoist / calendar integrations

The application remains the **system of record** while external tools act as execution/reminder layers.

Example:

```text
Home platform: HVAC filter due Sept 15
        ↓
Todoist: Replace upstairs HVAC filter
        ↓
User completes task
        ↓
Home platform: Maintenance recorded Sept 14
        ↓
Next maintenance date calculated
```

### Contractor/service-provider history

Associate contractors and technicians with prior service events so homeowners can quickly answer:

- Who serviced this last time?
- What did it cost?
- What did they replace?
- Would I use them again?

### Repair-vs-replace intelligence

Combine:

- Asset age
- Expected lifespan
- Repair history
- Repair cost
- Warranty status
- Maintenance history
- Estimated replacement cost

Provide decision support rather than simply another repair log.

### Home transfer package

Allow a homeowner to transfer selected home records to a buyer when the property is sold:

- Manuals
- Warranties
- Asset inventory
- Service history
- Major improvements
- Contractor information
- Maintenance schedules

This creates a persistent **digital record of the home**, not merely an account owned by one person.

### Household sharing

Support multiple members of a household with appropriate roles and permissions.

### Smart-home integrations

Longer term, ingest telemetry or device status from supported smart-home ecosystems where useful and privacy-appropriate.

## Safety and privacy considerations

The platform may eventually store unusually detailed information about a person's residence. Security and privacy therefore need to be first-class product requirements.

Important areas include:

- Encryption in transit and at rest
- Strong authentication
- Household membership/authorization controls
- Secure object storage
- Signed/expiring document URLs
- Data minimization
- Auditability for shared access
- Secure account/home transfer
- Protection of addresses, serial numbers, receipts, contractor records, and home-system details
- Clear AI grounding and source attribution
- Guardrails around electrical, gas, refrigerant, structural, and other hazardous work

## Potential product positioning

### DwellOS

**The operating system for your home.**

Broad enough to support inventory, maintenance, documents, AI, lifecycle management, and future integrations.

### HouseMind

**Your home. Now it remembers.**

Stronger emphasis on the AI and persistent-memory aspects of the product.

### Possible brand architecture

A future option is to separate the platform from the AI assistant identity:

- **DwellOS** — home platform / operating system
- **Domi** — conversational AI assistant

Example:

> "Domi, what size filter does the upstairs HVAC need?"

The assistant already knows which HVAC asset the user means and can answer from that equipment's documentation and history.

No final name should be adopted until basic domain, trademark, App Store, and competitive-name screening is completed.

## Development sequence

### Phase 0 — Validate

- [ ] Select a working product name
- [ ] Finalize problem statement and product thesis
- [ ] Complete competitor teardown
- [ ] Validate differentiation
- [ ] Define MVP acceptance criteria

### Phase 1 — Foundation

- [ ] Create local VS Code workspace
- [ ] Choose initial technology stack
- [ ] Define repository structure and development conventions
- [ ] Design system architecture
- [ ] Define core database schema

### Phase 2 — Asset platform

- [ ] Authentication
- [ ] Home management
- [ ] Room/location management
- [ ] Asset CRUD
- [ ] Document upload/storage
- [ ] Warranty data
- [ ] Maintenance records
- [ ] Service history

### Phase 3 — Intelligence layer

- [ ] PDF/document extraction
- [ ] Chunking and metadata preservation
- [ ] Retrieval/indexing
- [ ] Asset-scoped RAG
- [ ] AI answers with citations
- [ ] Safety/grounding rules

### Phase 4 — Automation

- [ ] Maintenance reminders
- [ ] Warranty reminders
- [ ] Manual-derived maintenance suggestions
- [ ] Todoist/calendar integration

### Phase 5 — Advanced intelligence

- [ ] Model/serial label scanning
- [ ] Automated manual discovery
- [ ] Receipt extraction
- [ ] Recall monitoring
- [ ] Parts intelligence
- [ ] Repair-vs-replace recommendations
- [ ] Home-transfer workflow

## Immediate next step

Create the local development workspace from this repository and decide the initial technology stack before generating application code.

The first vertical slice should demonstrate the core thesis:

> **Create a home → add an asset → attach its manual → ask a question → receive a grounded answer with a source citation.**

If that experience is useful and reliable, the rest of the home-management platform can grow around it.
