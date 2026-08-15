# PDP Copy — Shopify Integration Guide

## Overview

This guide covers the complete Shopify API integration for PDP Copy, including custom app setup, OAuth flow, API scopes, and webhook configuration.

---

## 1. Create Shopify Private App

### Step 1: Access Shopify Admin Settings
1. Log in to Shopify store → **Settings** (bottom-left)
2. Go to **Apps and Integrations** → **Develop apps**
3. Click **Create an app**

### Step 2: App Configuration
**App Name**: `PDP Copy Rewriter`

**Configuration**:
- **Admin API access scopes** (required):
  - `write_products` — Update product descriptions
  - `read_products` — Fetch product data
  - `write_metafields` — Write SEO meta data
  - `read_metafields` — Read existing metafields
  - `write_orders` — (Optional) For future upsells tracking
  
**Optional Scopes**:
- `read_inventory` — Track product stock
- `read_product_listings` — SEO data

### Step 3: Retrieve API Credentials
1. Click **Configuration** tab
2. Under **Admin API access tokens**, click **Reveal token** (once only!)
3. Copy and securely store:
   - **Access Token** → `SHOPIFY_API_PASSWORD`
   - **API Key** → `SHOPIFY_API_KEY`
4. Note your **API Credentials URL**: Save for reference

### Step 4: Activate App
1. Click **Install app** (bottom of page)
2. Your app is now active and can make API calls

**Security Note**: Never commit API credentials to Git. Use environment variables.

---

## 2. Shopify GraphQL API Reference

### 2.1 Fetch Product Data

**Query**:
```graphql
query GetProduct($id: ID!) {
  product(id: $id) {
    id
    title
    bodyHtml
    handle
    category {
      name
    }
    collections(first: 5) {
      edges {
        node {
          title
        }
      }
    }
    metafields(namespace: "custom", first: 10) {
      edges {
        node {
          key
          value
        }
      }
    }
    images(first: 1) {
      edges {
        node {
          url
        }
      }
    }
    variants(first: 1) {
      edges {
        node {
          price
        }
      }
    }
    publishedAt
    createdAt
  }
}
```

**Variables**:
```json
{
  "id": "gid://shopify/Product/123456789"
}
```

**cURL Example**:
```bash
curl -X POST "https://your-store.myshopify.com/admin/api/2024-01/graphql.json" \
  -H "X-Shopify-Access-Token: your_access_token" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "query GetProduct($id: ID!) { product(id: $id) { id title bodyHtml } }",
    "variables": { "id": "gid://shopify/Product/123456789" }
  }'
```

---

### 2.2 Update Product Description

**Mutation**:
```graphql
mutation UpdateProduct($input: ProductInput!) {
  productUpdate(input: $input) {
    product {
      id
      title
      bodyHtml
      updatedAt
    }
    userErrors {
      field
      message
    }
  }
}
```

**Input Variables**:
```json
{
  "input": {
    "id": "gid://shopify/Product/123456789",
    "descriptionHtml": "<p>Your new product description here...</p>",
    "title": "Product Title (optional to update)"
  }
}
```

**Example Response**:
```json
{
  "data": {
    "productUpdate": {
      "product": {
        "id": "gid://shopify/Product/123456789",
        "title": "Blue Ceramic Mug",
        "bodyHtml": "<p>Beautiful handmade ceramic mug...</p>",
        "updatedAt": "2026-08-15T10:30:00Z"
      },
      "userErrors": []
    }
  }
}
```

---

### 2.3 Write Metafields (SEO Data)

**Mutation**:
```graphql
mutation UpdateMetafields($input: ProductInput!) {
  productUpdate(input: $input) {
    product {
      id
      metafields(first: 10) {
        edges {
          node {
            key
            value
          }
        }
      }
    }
    userErrors {
      field
      message
    }
  }
}
```

**Input**:
```json
{
  "input": {
    "id": "gid://shopify/Product/123456789",
    "metafields": [
      {
        "namespace": "custom",
        "key": "seo_title",
        "value": "Blue Ceramic Coffee Mug 12oz | Handmade",
        "type": "single_line_text_field"
      },
      {
        "namespace": "custom",
        "key": "seo_description",
        "value": "Shop handmade ceramic mugs. BPA-free, microwave-safe. Free shipping over $50.",
        "type": "single_line_text_field"
      },
      {
        "namespace": "custom",
        "key": "rewrite_version",
        "value": "1",
        "type": "number_integer"
      },
      {
        "namespace": "custom",
        "key": "rewrite_date",
        "value": "2026-08-15",
        "type": "date"
      }
    ]
  }
}
```

**Metafield Types**:
- `single_line_text_field` — Text up to 255 chars
- `multi_line_text_field` — Text up to 262,144 chars
- `number_integer` — Integer values
- `date` — Date format (YYYY-MM-DD)
- `json` — JSON object (for storing complex data)

---

### 2.4 List Products (Batch Processing)

**Query**:
```graphql
query ListProducts($first: Int!, $after: String) {
  products(first: $first, after: $after) {
    pageInfo {
      hasNextPage
      endCursor
    }
    edges {
      node {
        id
        title
        bodyHtml
      }
    }
  }
}
```

**Variables**:
```json
{
  "first": 50,
  "after": null
}
```

**Note**: Shopify returns max 250 products per query. Use pagination cursors for larger catalogs.

---

## 3. Webhook Setup (Optional)

### Set Up n8n Webhook for Product Events

**Use Case**: Automatically rewrite descriptions when products are created/updated

**n8n Webhook Configuration**:
1. In workflow, add **Webhook** node
2. Configure:
   - **Path**: `/webhooks/shopify-product`
   - **Authentication**: None (Shopify doesn't support)
   - **HTTP Method**: POST

3. Get webhook URL: `https://your-n8n-instance.com/webhook/shopify-product`

### Configure Shopify Webhook

**In Shopify Admin**:
1. Settings → **Notifications**
2. Scroll to **Webhooks**
3. Click **Create webhook**

**Configuration**:
- **Event**: `products/create` or `products/update`
- **Format**: JSON
- **Endpoint**: `https://your-n8n-instance.com/webhook/shopify-product`
- **API version**: 2024-01

**Test**:
```bash
# Shopify will send test webhook
# Check n8n execution history for incoming payload
```

---

## 4. API Rate Limits & Best Practices

### Shopify Rate Limits

- **REST API**: 2 calls/second (with burst to 40)
- **GraphQL API**: 10 queries/second (measured by query complexity)
- **Leaky Bucket Algorithm**: Rate resets every second

### Best Practices

1. **Batch Operations**:
   - Process max 100 products/batch
   - Add 1-2 second delay between batches
   - Use cursor-based pagination for large catalogs

2. **Query Optimization**:
   - Only request fields you need (reduces query cost)
   - Use GraphQL aliases for parallel queries
   - Cache frequently accessed data

3. **Error Handling**:
   ```javascript
   // Retry failed calls with exponential backoff
   async function retryWithBackoff(fn, maxRetries = 3) {
     for (let i = 0; i < maxRetries; i++) {
       try {
         return await fn();
       } catch (error) {
         if (error.status === 429) { // Rate limited
           const delay = Math.pow(2, i) * 1000; // 1s, 2s, 4s
           await new Promise(resolve => setTimeout(resolve, delay));
         } else {
           throw error;
         }
       }
     }
   }
   ```

---

## 5. Testing the Integration

### Test 1: Verify API Connection
```bash
curl -X POST "https://your-store.myshopify.com/admin/api/2024-01/graphql.json" \
  -H "X-Shopify-Access-Token: your_access_token" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ appInstallation { accessScopes { handle } } }"
  }'
```

**Expected Response**:
```json
{
  "data": {
    "appInstallation": {
      "accessScopes": [
        { "handle": "write_products" },
        { "handle": "read_products" },
        { "handle": "write_metafields" }
      ]
    }
  }
}
```

### Test 2: Fetch a Real Product
```bash
curl -X POST "https://your-store.myshopify.com/admin/api/2024-01/graphql.json" \
  -H "X-Shopify-Access-Token: your_access_token" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "{ products(first: 1) { edges { node { id title } } } }"
  }'
```

### Test 3: Update Product via n8n
1. Trigger rewrite workflow manually in n8n
2. Monitor execution in n8n dashboard
3. Verify in Shopify: Product → Description updated

---

## 6. Troubleshooting

### Error: "Invalid access token"
- **Cause**: API token invalid, revoked, or wrong
- **Fix**: Regenerate token in Shopify Admin → Apps → PDP Copy → Regenerate

### Error: "Insufficient permissions"
- **Cause**: Missing API scope
- **Fix**: 
  1. Add scope in app config
  2. Reinstall app (old token invalid after scope change)
  3. Get new token

### Error: "Rate limit exceeded" (HTTP 429)
- **Cause**: Too many API calls
- **Fix**: Add delays between requests (500ms-1s)

### Error: "Product not found"
- **Cause**: Invalid product ID format
- **Fix**: Use full GraphQL ID: `gid://shopify/Product/123456` (not just `123456`)

---

## 7. Security Best Practices

1. **Never commit API credentials** to version control
2. **Use environment variables** for all tokens
3. **Rotate API tokens** every 90 days
4. **Use HTTPS only** for all API requests
5. **Audit API usage**: Check Shopify Admin → Apps → PDP Copy → Activity
6. **Limit API scope** to minimum required permissions
7. **Monitor for suspicious activity**: Set up alerts for unusual API patterns

---

## 8. Advanced: Custom Shopify App Customization

### Extend Metafields for PDP Copy
Store additional metadata for tracking rewrites:

```json
{
  "metafields": [
    {
      "namespace": "pdp_copy",
      "key": "rewrite_count",
      "value": "5",
      "type": "number_integer"
    },
    {
      "namespace": "pdp_copy",
      "key": "last_rewrite_date",
      "value": "2026-08-15",
      "type": "date"
    },
    {
      "namespace": "pdp_copy",
      "key": "ai_provider_used",
      "value": "openai",
      "type": "single_line_text_field"
    },
    {
      "namespace": "pdp_copy",
      "key": "voice_profile_applied",
      "value": "{\"tone\":\"professional\",\"avgLength\":200}",
      "type": "json"
    }
  ]
}
```

---

## 9. API Endpoint Summary

| Operation | Method | Endpoint |
|-----------|--------|----------|
| Fetch Product | POST | `/admin/api/2024-01/graphql.json` |
| Update Product | POST | `/admin/api/2024-01/graphql.json` |
| Write Metafields | POST | `/admin/api/2024-01/graphql.json` |
| List Products | POST | `/admin/api/2024-01/graphql.json` |
| Webhooks | N/A | Settings → Notifications → Webhooks |

---

**For more**: Shopify GraphQL API docs: https://shopify.dev/api/admin-graphql

**Next Steps**: See [API_REFERENCE.md](./API_REFERENCE.md) for PDP Copy API endpoints and usage.
