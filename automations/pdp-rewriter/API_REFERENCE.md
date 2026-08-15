# PDP Copy — API Reference

## Overview

Complete API reference for PDP Copy webhooks and integration points. All endpoints require authentication and use JSON request/response format.

---

## 1. Authentication

### API Key Authentication (Header-based)

All requests must include:
```bash
X-API-Key: your_pdp_copy_api_key
Content-Type: application/json
```

**Obtain API Key**:
1. Sign up for PDP Copy account
2. Go to **Dashboard** → **API Keys**
3. Click **Generate Key**
4. Copy and store securely (shown once only)

---

## 2. Base URL

**Production**:
```
https://pdp-copy.api.example.com/v1
```

**Development/Self-Hosted**:
```
https://your-n8n-instance.com/webhook
```

---

## 3. API Endpoints

### 3.1 Rewrite Single Product

**Endpoint**: `POST /pdp-copy/rewrite`

**Description**: Rewrites a single product description and generates SEO meta tags

**Request**:
```json
{
  "productId": "gid://shopify/Product/123456789",
  "aiProvider": "openai",
  "brandVoice": "Professional",
  "keywords": "ceramic mug, coffee",
  "length": "Medium",
  "storeId": "gid://shopify/Shop/123456789",
  "autoPublish": true,
  "reviewMode": false
}
```

**Parameters**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `productId` | string (GraphQL ID) | Yes | Shopify product ID |
| `aiProvider` | string | Yes | `openai` or `claude` |
| `brandVoice` | string | Yes | `Professional`, `Casual`, `Luxury`, `Technical`, or custom profile ID |
| `keywords` | string | No | Comma-separated keywords for SEO optimization |
| `length` | string | No | `Short` (100-150 words), `Medium` (200-300), `Long` (400-500). Default: `Medium` |
| `storeId` | string | Yes | Shopify store ID (usually your main shop) |
| `autoPublish` | boolean | No | Auto-publish to Shopify. Default: `true` |
| `reviewMode` | boolean | No | Require manual review before publishing. Default: `false` |

**Response (Success)**:
```json
{
  "success": true,
  "data": {
    "productId": "gid://shopify/Product/123456789",
    "handle": "blue-ceramic-mug",
    "title": "Blue Ceramic Coffee Mug",
    "rewrittenDescription": "<p>Beautiful handmade ceramic mug...</p>",
    "seo": {
      "metaTitle": "Blue Ceramic Coffee Mug 12oz | Handmade",
      "metaDescription": "Shop beautiful handmade ceramic mugs. BPA-free, microwave-safe. Free shipping over $50."
    },
    "publishedAt": "2026-08-15T10:30:00Z",
    "executionId": "n8n-execution-uuid-12345"
  }
}
```

**Response (Review Mode)**:
```json
{
  "success": true,
  "data": {
    "productId": "gid://shopify/Product/123456789",
    "status": "pending_review",
    "rewrittenDescription": "...",
    "seo": { ... },
    "reviewUrl": "https://pdp-copy-dashboard.com/reviews/review-id-12345",
    "expiresAt": "2026-08-16T10:30:00Z"
  }
}
```

**Response (Error)**:
```json
{
  "success": false,
  "error": {
    "code": "INVALID_PRODUCT_ID",
    "message": "Product not found or invalid ID format",
    "details": {
      "productId": "gid://shopify/Product/123456789",
      "suggestion": "Verify product ID is in GraphQL format"
    }
  }
}
```

**Error Codes**:
| Code | Status | Description |
|------|--------|-------------|
| `INVALID_PRODUCT_ID` | 400 | Product ID invalid or not found |
| `INSUFFICIENT_CREDITS` | 402 | Account out of credits |
| `AI_API_ERROR` | 500 | OpenAI/Claude API error |
| `SHOPIFY_API_ERROR` | 502 | Shopify API error |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `UNAUTHORIZED` | 401 | Invalid API key |

**cURL Example**:
```bash
curl -X POST https://pdp-copy.api.example.com/v1/pdp-copy/rewrite \
  -H "X-API-Key: your_api_key" \
  -H "Content-Type: application/json" \
  -d '{
    "productId": "gid://shopify/Product/123456789",
    "aiProvider": "openai",
    "brandVoice": "Professional",
    "keywords": "ceramic mug, coffee",
    "length": "Medium",
    "storeId": "gid://shopify/Shop/123456789",
    "autoPublish": true
  }'
```

---

### 3.2 Bulk Import & Rewrite

**Endpoint**: `POST /pdp-copy/bulk-import`

**Description**: Rewrite multiple products from CSV file

**Request**:
```json
{
  "csvUrl": "https://example.com/products.csv",
  "aiProvider": "openai",
  "brandVoice": "Professional",
  "storeId": "gid://shopify/Shop/123456789",
  "autoPublish": true,
  "batchSize": 10,
  "webhookUrl": "https://your-app.com/webhooks/pdp-copy-complete"
}
```

**Parameters**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `csvUrl` | string (URL) | Yes | Direct URL to CSV file |
| `aiProvider` | string | Yes | `openai` or `claude` |
| `brandVoice` | string | Yes | Brand voice profile |
| `storeId` | string | Yes | Shopify store ID |
| `autoPublish` | boolean | No | Auto-publish all rewrites. Default: `false` (review mode) |
| `batchSize` | integer | No | Products per batch (1-100). Default: 10 |
| `webhookUrl` | string | No | Callback URL when completed (async) |

**CSV Format** (required columns):
```csv
productId,title,description,category,keywords
gid://shopify/Product/123456,Blue Mug,A ceramic mug,Kitchen,ceramic mug
gid://shopify/Product/123457,Red Mug,A red ceramic mug,Kitchen,ceramic mug
```

**Required CSV Columns**:
- `productId` — Shopify GraphQL product ID
- `title` — Product name (for context)
- `description` — Current description (optional but recommended)
- `category` — Product category (optional)
- `keywords` — SEO keywords (optional, comma-separated)

**Response (Async)**:
```json
{
  "success": true,
  "data": {
    "batchId": "batch-uuid-12345",
    "status": "processing",
    "totalProducts": 50,
    "estimatedDuration": "5-10 minutes",
    "progress": {
      "processed": 0,
      "succeeded": 0,
      "failed": 0,
      "pending": 50
    },
    "statusUrl": "https://pdp-copy.api.example.com/v1/batch/batch-uuid-12345",
    "webhookCallback": "https://your-app.com/webhooks/pdp-copy-complete"
  }
}
```

**Polling for Status**:
```bash
curl -X GET https://pdp-copy.api.example.com/v1/batch/batch-uuid-12345 \
  -H "X-API-Key: your_api_key"
```

**Response (Complete)**:
```json
{
  "success": true,
  "data": {
    "batchId": "batch-uuid-12345",
    "status": "completed",
    "summary": {
      "totalProducts": 50,
      "succeeded": 48,
      "failed": 2,
      "successRate": "96%"
    },
    "results": [
      {
        "productId": "gid://shopify/Product/123456",
        "status": "published",
        "rewriteTime": "2.5s"
      }
    ],
    "reportUrl": "https://pdp-copy-dashboard.com/reports/batch-uuid-12345",
    "completedAt": "2026-08-15T11:45:00Z"
  }
}
```

---

### 3.3 Voice Training

**Endpoint**: `POST /pdp-copy/voice-training`

**Description**: Train AI to match your store's brand voice

**Request**:
```json
{
  "storeId": "gid://shopify/Shop/123456789",
  "descriptions": [
    "Premium, handcrafted ceramic mugs perfect for daily use...",
    "Luxury coffee vessels made from sustainably sourced clay...",
    "Artisanal mugs that tell a story with every cup..."
  ],
  "minSamples": 5,
  "maxSamples": 20
}
```

**Parameters**:
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `storeId` | string | Yes | Shopify store ID |
| `descriptions` | array | Yes | Array of 5-20 product descriptions |
| `minSamples` | integer | No | Minimum descriptions. Default: 5 |
| `maxSamples` | integer | No | Maximum descriptions. Default: 20 |

**Response**:
```json
{
  "success": true,
  "data": {
    "voiceProfileId": "voice-uuid-12345",
    "storeId": "gid://shopify/Shop/123456789",
    "status": "active",
    "analysis": {
      "tone": "Professional yet approachable",
      "avgWordCount": 185,
      "avgSentenceLength": 12,
      "commonPhrases": [
        "premium quality",
        "handcrafted",
        "sustainability",
        "perfect for"
      ],
      "callToActionStyle": "Subtle, benefit-focused",
      "keywordFocus": [
        "ceramic",
        "artisanal",
        "sustainable",
        "handmade"
      ]
    },
    "createdAt": "2026-08-15T10:00:00Z",
    "readyForUse": true
  }
}
```

**Using Voice Profile in Rewrites**:
```json
{
  "productId": "gid://shopify/Product/123456789",
  "aiProvider": "openai",
  "brandVoice": "voice-uuid-12345",
  "autoPublish": true
}
```

---

### 3.4 Review & Approve Changes

**Endpoint**: `POST /pdp-copy/review/{reviewId}/approve`

**Description**: Approve a pending product rewrite for publishing

**Request**:
```json
{
  "approved": true,
  "notes": "Looks good, approved by Sarah",
  "changes": {
    "description": "approved",
    "metaTitle": "approved",
    "metaDescription": "approved"
  }
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "reviewId": "review-uuid-12345",
    "productId": "gid://shopify/Product/123456789",
    "status": "approved",
    "publishedAt": "2026-08-15T10:35:00Z",
    "approvedBy": "user-email@example.com"
  }
}
```

**Endpoint**: `POST /pdp-copy/review/{reviewId}/reject`

**Description**: Reject a pending rewrite

**Request**:
```json
{
  "reason": "Description too casual for this product",
  "feedback": "Please revise with more professional tone"
}
```

---

### 3.5 Get Account Usage

**Endpoint**: `GET /pdp-copy/usage`

**Description**: Get current subscription usage and credits

**Response**:
```json
{
  "success": true,
  "data": {
    "accountId": "account-uuid-12345",
    "subscription": {
      "tier": "Professional",
      "billingCycle": "monthly",
      "renewalDate": "2026-09-15",
      "status": "active"
    },
    "usage": {
      "thisMonth": {
        "productsRewritten": 342,
        "limit": 500,
        "percentUsed": "68%"
      },
      "thisYear": {
        "totalCost": "$1,992",
        "averageCost": "$249/month"
      }
    },
    "credits": {
      "current": 1250,
      "costPerRewrite": 10
    },
    "breakdown": {
      "singleProduct": 100,
      "bulkImports": 5,
      "voiceTrainings": 2
    }
  }
}
```

---

### 3.6 Get Rewrite History

**Endpoint**: `GET /pdp-copy/history?limit=50&offset=0`

**Description**: Get history of all rewrites

**Query Parameters**:
| Param | Type | Description |
|-------|------|-------------|
| `limit` | integer | Max results (1-100). Default: 50 |
| `offset` | integer | Pagination offset. Default: 0 |
| `status` | string | Filter by status: `published`, `pending`, `failed` |
| `from` | date | Start date (YYYY-MM-DD) |
| `to` | date | End date (YYYY-MM-DD) |

**Response**:
```json
{
  "success": true,
  "data": {
    "total": 342,
    "limit": 50,
    "offset": 0,
    "items": [
      {
        "id": "rewrite-uuid-123",
        "productId": "gid://shopify/Product/123456",
        "title": "Blue Ceramic Mug",
        "status": "published",
        "aiProvider": "openai",
        "brandVoice": "Professional",
        "createdAt": "2026-08-15T10:30:00Z",
        "publishedAt": "2026-08-15T10:35:00Z",
        "duration": "5.2s",
        "cost": 10
      }
    ]
  }
}
```

---

## 4. Webhook Events

### Incoming Webhooks (Your App Receives)

When `webhookUrl` is provided in bulk import, PDP Copy will POST events:

**Event: Batch Completed**
```json
{
  "event": "batch.completed",
  "data": {
    "batchId": "batch-uuid-12345",
    "status": "completed",
    "summary": {
      "totalProducts": 50,
      "succeeded": 48,
      "failed": 2
    },
    "completedAt": "2026-08-15T11:45:00Z"
  },
  "timestamp": "2026-08-15T11:45:00Z"
}
```

**Event: Product Rewrite Failed**
```json
{
  "event": "product.rewrite.failed",
  "data": {
    "batchId": "batch-uuid-12345",
    "productId": "gid://shopify/Product/123456",
    "error": {
      "code": "SHOPIFY_API_ERROR",
      "message": "Product not found"
    }
  }
}
```

---

## 5. Rate Limiting

**Limits**:
- **Starter**: 100 requests/hour
- **Professional**: 1,000 requests/hour
- **Enterprise**: Unlimited

**Headers**:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 987
X-RateLimit-Reset: 1692086400
```

**When Limit Exceeded** (HTTP 429):
```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests",
    "retryAfter": 60
  }
}
```

**Recommendation**: Implement exponential backoff for retries

---

## 6. Best Practices

### 1. Error Handling
```javascript
async function callPdpCopyAPI(endpoint, payload) {
  let retries = 3;
  while (retries > 0) {
    try {
      const response = await fetch(`https://pdp-copy.api.example.com/v1${endpoint}`, {
        method: 'POST',
        headers: {
          'X-API-Key': process.env.PDP_COPY_API_KEY,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(payload)
      });

      if (response.status === 429) {
        const retryAfter = response.headers.get('Retry-After') || 60;
        await new Promise(r => setTimeout(r, retryAfter * 1000));
        retries--;
      } else if (!response.ok) {
        throw new Error(`API Error: ${response.status}`);
      } else {
        return await response.json();
      }
    } catch (error) {
      console.error('API call failed:', error);
      retries--;
    }
  }
}
```

### 2. Async Batch Processing
```javascript
// Start bulk import
const batchResponse = await callPdpCopyAPI('/pdp-copy/bulk-import', {
  csvUrl: 'https://example.com/products.csv',
  aiProvider: 'openai',
  brandVoice: 'Professional'
});

const batchId = batchResponse.data.batchId;

// Poll for completion
let completed = false;
while (!completed) {
  const status = await fetch(`https://pdp-copy.api.example.com/v1/batch/${batchId}`, {
    headers: { 'X-API-Key': process.env.PDP_COPY_API_KEY }
  }).then(r => r.json());

  if (status.data.status === 'completed') {
    completed = true;
    console.log('Batch complete:', status.data.summary);
  } else {
    console.log('Progress:', status.data.progress);
    await new Promise(r => setTimeout(r, 5000)); // Check every 5 seconds
  }
}
```

### 3. Secure Credential Storage
```javascript
// Use environment variables, NOT hardcoded keys
const apiKey = process.env.PDP_COPY_API_KEY;

// Or use a secrets manager
const apiKey = await secretsManager.getSecret('pdp-copy-api-key');
```

---

## 7. Testing

### Sandbox/Dev Environment
```
https://sandbox-pdp-copy.api.example.com/v1
```

Use sandbox for testing before production calls.

---

## 8. Support

- **Documentation**: https://docs.pdp-copy.com
- **API Status**: https://status.pdp-copy.com
- **Support Email**: support@pdp-copy.com
- **Slack Community**: https://slack.pdp-copy.com

---

**API Version**: 1.0  
**Last Updated**: 2026-08-15  
**Status**: Production Ready
