# PDP Copy — Product Specification

## Product Overview

**Name**: PDP Copy (Product Description Page Copy)  
**Category**: SaaS + Done-For-You Automation  
**Target Users**: E-commerce store owners (Shopify primary, 100-10k products)  
**Deployment Model**: Hosted n8n + Custom dashboard  

---

## 1. Core Use Cases

### UC1: Single Product Rewrite
**User**: Store owner wants to improve a specific product's description  
**Flow**:
1. Select product in Shopify
2. System pulls current description + basic metadata
3. AI rewrites description in brand voice + generates SEO metas
4. User reviews changes
5. Auto-publishes to Shopify

**Time Saved**: 5-10 min/product → 30 seconds

---

### UC2: Bulk CSV Rewrite
**User**: Store owner with 500+ products needs batch rewriting  
**Flow**:
1. Upload CSV with product IDs or titles
2. System fetches all Shopify data for those products
3. Process each product through voice-trained AI
4. Generate spreadsheet with before/after
5. One-click publish all changes

**Time Saved**: 40+ hours of manual copywriting

---

### UC3: Voice Training
**User**: Store owner uploads 10-20 existing product descriptions  
**Flow**:
1. Owner provides best-performing descriptions (high conversion)
2. System analyzes for: tone, length, keyword density, structure
3. Creates "brand voice" profile in n8n
4. All future rewrites use this profile

**Result**: AI learns store's unique selling approach

---

### UC4: SEO Meta Generation
**User**: Need optimized meta titles & descriptions for Google/social  
**Flow**:
1. System extracts product info (name, features, price)
2. AI generates:
   - Meta Title (50-60 chars, includes primary keyword)
   - Meta Description (150-160 chars, call-to-action)
3. Automatically publishes to Shopify metafields
4. Tracks CTR improvements in dashboard

---

## 2. User Personas

### Persona A: Busy E-Commerce Owner (Primary)
- **Background**: Runs 500-5k product Shopify store
- **Pain Point**: No time to write product copy; current descriptions are thin/keyword-stuffed
- **Need**: Fast, professional descriptions that convert
- **Budget**: $200-500/month for the right tool
- **Success Metric**: 15-30% increase in conversion rate

### Persona B: Marketing Agency
- **Background**: Manages multiple client Shopify stores
- **Pain Point**: Copywriting is expensive; clients want custom copy fast
- **Need**: Scalable solution to handle 50+ store rewrites/month
- **Budget**: Enterprise tier ($600+)
- **Success Metric**: Deliver client work 10x faster

### Persona C: SEO/Content Specialist
- **Background**: Works for e-commerce brand, owns SEO strategy
- **Pain Point**: Product descriptions aren't optimized; meta tags are missing
- **Need**: Bulk SEO optimization + learning analytics
- **Budget**: $200-300/month
- **Success Metric**: Measurable SEO traffic lift

---

## 3. Feature Set (MVP + Roadmap)

### MVP (Phase 1 — Months 1-3)

#### Feature: AI Description Rewriting
- **Inputs**: Current product description + optional category/keywords
- **Outputs**: Rewritten description (150-300 words)
- **Process**:
  1. AI analyzes current description for: tone, structure, keyword density
  2. Generates 3 variations using selected AI model (OpenAI/Claude)
  3. User selects best or regenerates
  4. Publishes directly to Shopify

**Technical Details**:
```
Prompt Template:
---
You are a professional e-commerce copywriter. Rewrite this product description 
in a [BRAND_VOICE] tone. Keep it [LENGTH] words. Include these keywords: [KEYWORDS].
Focus on benefits, not features. Make it conversion-focused.

Current Description:
[EXISTING_DESCRIPTION]

Brand Voice Sample:
[VOICE_SAMPLE_1]
[VOICE_SAMPLE_2]
---
```

**UI Flow**:
1. Shopify product page → "Rewrite with PDP Copy" button
2. Modal opens with options:
   - Tone: Professional/Casual/Luxury/Technical
   - Length: Short/Medium/Long
   - Keywords: (optional)
3. Show 3 variations side-by-side
4. One-click publish

---

#### Feature: SEO Meta Title/Description
- **Inputs**: Product name + primary keyword
- **Outputs**:
  - Meta Title (max 60 chars, includes primary keyword)
  - Meta Description (max 160 chars, includes CTA)

**Example**:
```
Product: Blue Ceramic Coffee Mug, 12oz
Keyword: ceramic mug

Generated Meta Title:
"Blue Ceramic Coffee Mug 12oz | Handmade Coffee Cups"

Generated Meta Description:
"Shop beautiful handmade ceramic coffee mugs. BPA-free, microwave-safe, 
and perfect for daily use. Free shipping over $50. Buy now!"
```

---

#### Feature: One-Click Shopify Publishing
- **Flow**:
  1. User clicks "Publish to Shopify"
  2. System updates via Shopify Admin API:
     - `product.body_html` (main description)
     - `metafield.seo.title` (meta title)
     - `metafield.seo.description` (meta description)
  3. Confirmation email sent
  4. Change logged in dashboard

---

### Phase 2 (Months 4-6)

- **Voice Training**: Upload 10-20 existing descriptions → AI learns brand tone
- **Bulk CSV Import**: Upload CSV → batch process 100+ products
- **Review Mode**: Queue changes for manual approval before publishing
- **Analytics Dashboard**: 
  - Products rewritten (this month)
  - Publish success rate
  - Upcoming: CTR tracking (Google Search Console integration)

---

### Phase 3 (Months 7-12)

- **A/B Testing**: Generate 3 variations, rotate through customers, track CTR
- **Social Media Copy**: Auto-generate Instagram/Facebook captions
- **Competitor Analysis**: Analyze competitor descriptions → suggest improvements
- **WooCommerce & BigCommerce Support**
- **Multi-language**: Rewrite in Spanish, French, German, etc.

---

## 4. Technical Architecture

### Components

#### 1. n8n Workflows (Core Engine)
- **Workflow A**: `pdp-copy-single-product.json`
  - Trigger: HTTP webhook or Shopify private app
  - Steps:
    1. Receive product ID
    2. Fetch product data via Shopify API
    3. Call OpenAI or Claude API for rewrite
    4. Format response
    5. Publish back to Shopify
    6. Log result

- **Workflow B**: `pdp-copy-bulk-csv.json`
  - Trigger: CSV file upload
  - Steps:
    1. Parse CSV (product IDs/titles)
    2. Loop through each row
    3. Run rewrite sub-workflow for each
    4. Aggregate results
    5. Generate output CSV + publish report

#### 2. n8n Database
- Store: Rewrite history, voice training data, API keys, user settings
- Retention: 12 months of execution logs

#### 3. Shopify Integration
- **OAuth Flow**: User authorizes PDP Copy to access their store
- **Scopes**:
  - `write_products` — Update descriptions
  - `read_products` — Fetch product data
  - `write_metafields` — Store SEO data
  - `read_metafields` — Retrieve existing metadata

#### 4. Dashboard (Next.js)
- Simple UI for:
  - Connecting Shopify store
  - Uploading voice training samples
  - Viewing rewrite history
  - Managing subscription/billing

---

## 5. Content Quality Standards

### Description Rewriting Rules
1. **Length**: 150-300 words (user-configurable)
2. **Structure**:
   - Hook (first 1-2 sentences): Benefit-focused
   - Features: 3-5 key features with benefits
   - Social Proof: (if available) "Trusted by X customers"
   - CTA: "Add to Cart" or "Learn More"

3. **Tone Options**:
   - **Professional**: Formal, detailed, authority-driven
   - **Casual**: Friendly, conversational, approachable
   - **Luxury**: Aspirational, premium, exclusive
   - **Technical**: Detailed specs, performance-focused
   - **Brand Voice**: Learned from uploaded samples

4. **SEO Compliance**:
   - Primary keyword appears in first 50 words (for descriptions)
   - Meta title includes primary keyword
   - Meta description includes secondary keyword + CTA
   - No keyword stuffing (max 2% keyword density)

---

## 6. Pricing Tiers

### Starter — $99/month
- ✅ Up to 100 products/month
- ✅ Basic AI rewriting (OpenAI GPT-4o)
- ✅ Auto-publish to Shopify
- ✅ Email support
- ❌ Voice training
- ❌ SEO meta generation
- ❌ Bulk CSV import

### Professional — $249/month
- ✅ Up to 500 products/month
- ✅ OpenAI + Claude (choose per rewrite)
- ✅ Voice training (brand tone learning)
- ✅ SEO meta title/description generation
- ✅ Bulk CSV import
- ✅ Review mode (before publishing)
- ✅ Rewrite history dashboard
- ✅ Email + chat support

### Enterprise — $599/month
- ✅ Unlimited products/month
- ✅ All Professional features
- ✅ Custom AI model training
- ✅ Dedicated account manager
- ✅ Webhook integrations
- ✅ Priority support (24h response)
- ✅ Advanced analytics

### Overages
- Starter tier: $5/product for usage beyond 100

---

## 7. Success Metrics & Analytics

### Dashboard Metrics
- **Products Rewritten**: Total count (this month + cumulative)
- **Publish Rate**: % of rewrites published to Shopify
- **AI Provider Used**: OpenAI vs Claude breakdown
- **Avg Rewrite Time**: Time from trigger → published
- **Failed Rewrites**: Count + reasons (API errors, content issues)

### Future Metrics (Phase 2+)
- **Google Search Console Integration**: Track CTR lift for rewritten descriptions
- **Conversion Impact**: A/B test tracking (SEO + conversion data)
- **Sentiment Analysis**: Did tone change align with brand voice?

---

## 8. API & Integrations

### Shopify Integration
- **API Version**: 2024-01 (current stable)
- **Custom App Setup**: Required (OAuth + API scopes)

### AI Providers
**OpenAI**:
- Model: `gpt-4o`
- Pricing: $0.03 per 1K input tokens, $0.06 per 1K output tokens
- Cost per rewrite: ~$0.10-0.20

**Claude 3.5 Sonnet**:
- Pricing: $3 per 1M input tokens, $15 per 1M output tokens
- Cost per rewrite: ~$0.08-0.15

### Future Integrations
- Google Search Console (CTR tracking)
- Google Sheets (CSV upload alternative)
- Slack (notifications, approvals)
- Email (rewrite notifications)

---

## 9. Risk Mitigation

**Risk: AI generates poor quality copy**
- Mitigation: Human review mode in Professional tier; voice training improves quality

**Risk: Shopify API rate limits**
- Mitigation: Queue system in n8n; batch processes at off-peak hours

**Risk: Users accidentally overwrite live descriptions**
- Mitigation: Review mode enabled by default; undo functionality (24h rollback)

**Risk: AI bias in certain categories (beauty, luxury)**
- Mitigation: Voice training; allow manual tone customization

---

## 10. Competitive Positioning

| Feature | PDP Copy | Copysmith | Copy.ai | WriterAccess |
|---------|----------|-----------|---------|--------------|
| Shopify Native Integration | ✅ | ❌ | ❌ | ❌ |
| Voice Training | ✅ | ❌ | Basic | ❌ |
| SEO Meta Gen | ✅ | ✅ | ✅ | ❌ |
| Bulk CSV Import | ✅ | ✅ | ✅ | ✅ |
| Auto-Publish | ✅ | ❌ | ❌ | ❌ |
| Dual AI Models | ✅ | ❌ | ❌ | ✅ |
| Price | $99-599 | $49-249 | $49-499 | $500+ (human) |

**Key Win**: Native Shopify integration + auto-publish = Zero manual handoff

---

**Document Version**: 1.0  
**Last Updated**: 2026-08-15  
**Status**: MVP Spec Ready for Development
