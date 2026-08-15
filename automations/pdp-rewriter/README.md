# PDP Copy — AI-Powered Product Description Rewriter

**Status**: DFY Automation App Concept (n8n-based)

## 🎯 What is PDP Copy?

PDP Copy is a **Done-For-You (DFY)** automation service that rewrites Shopify product descriptions in the store's own voice, while generating optimized SEO meta titles and descriptions. It's designed for e-commerce businesses that want professional, conversion-optimized product listings without hiring a copywriter.

## ✨ Core Features

- **Smart Description Rewriting** — Analyzes existing product descriptions and rewrites them in a consistent, branded voice
- **Voice Training** — Learns from your best-performing product descriptions to match your unique brand tone
- **SEO Meta Generation** — Auto-generates SEO-optimized meta titles (50-60 chars) and meta descriptions (150-160 chars)
- **Bulk CSV Import** — Upload a CSV with product data; get all copy rewritten in one workflow
- **Auto-Publish to Shopify** — Directly update Shopify products with zero manual handoff
- **Dual AI Provider Support** — Choose between OpenAI (GPT-4o) or Claude 3.5 Sonnet
- **Quality Review Mode** — Review before publishing (optional)

## 💰 Business Model

**Monthly Subscription Tiers:**

| Tier | Monthly | Products/Month | Features |
|------|---------|---|----------|
| **Starter** | $99 | 100 | Rewrite only, auto-publish |
| **Professional** | $249 | 500 | + Voice training, SEO metas, bulk CSV |
| **Enterprise** | $599 | Unlimited | + Priority support, custom workflows |

**Additional:** $5 per product overages for Starter tier

## 🏗️ Technical Architecture

- **Workflow Orchestration**: n8n (hosted instance)
- **AI Providers**: OpenAI + Claude API (configurable per workflow)
- **Storage**: n8n database + Shopify metafields
- **Integration**: Shopify Admin API
- **Auth**: Shopify OAuth + API keys

## 📂 Project Structure

```
pdp-rewriter/
├── README.md (this file)
├── PRODUCT_SPEC.md (detailed feature spec)
├── BUSINESS_MODEL.md (pricing, positioning, GTM)
├── n8n-workflows/
│   ├── pdp-copy-single-product.json (workflow template)
│   ├── pdp-copy-bulk-csv.json (bulk workflow)
│   └── voice-training-setup.json (tone learning workflow)
├── SETUP_GUIDE.md (how to deploy n8n + configure)
├── SHOPIFY_INTEGRATION.md (API setup instructions)
├── DEPLOYMENT.md (hosting, scaling, monitoring)
└── API_REFERENCE.md (custom endpoints, webhooks)
```

## 🚀 Quick Start

1. **Deploy n8n** — Set up a hosted n8n instance (self-managed cloud)
2. **Import Workflow** — Load `pdp-copy-single-product.json`
3. **Configure APIs** — Connect Shopify + AI provider credentials
4. **Train Voice** — Upload sample descriptions to teach the AI your brand tone
5. **Launch** — Create Shopify private app and start rewriting

See [SETUP_GUIDE.md](./SETUP_GUIDE.md) for detailed steps.

## 📊 Go-to-Market Strategy

**Phase 1**: Beta with 20-30 Shopify store owners (manual onboarding)
- Collect case studies (% increase in conversions, time saved)
- Refine pricing based on feedback

**Phase 2**: Self-serve Shopify app (Shopify App Store listing)
- Simplified onboarding flow
- Freemium trial (50 products free)

**Phase 3**: Expand to WooCommerce, BigCommerce, custom platforms

## 🔐 Key Differentiators

- **Voice Training**: Most competitors don't learn your brand tone
- **SEO Optimized**: Includes meta title/description generation (not just descriptions)
- **True DFY**: Shopify integration means zero manual copy-paste
- **Flexible AI**: Choose your AI provider (cost optimization)
- **Privacy-First**: No data retention—only workflow execution logs

---

**Next Steps**: Review [PRODUCT_SPEC.md](./PRODUCT_SPEC.md) and [BUSINESS_MODEL.md](./BUSINESS_MODEL.md) for deeper details. Then set up [SETUP_GUIDE.md](./SETUP_GUIDE.md) to deploy your first instance.
