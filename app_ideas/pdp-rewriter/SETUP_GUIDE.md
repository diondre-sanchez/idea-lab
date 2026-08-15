# PDP Copy — Setup & Deployment Guide

## 🚀 Quick Start (30 minutes)

### Prerequisites
- n8n instance (self-hosted or cloud)
- Shopify store with Admin API access
- OpenAI API key (or Claude API key)
- Basic understanding of webhooks

---

## 1. Deploy n8n

### Option A: n8n Cloud (Easiest)
1. Go to [n8n.io](https://n8n.io) → Sign up → Start free trial
2. Create new instance (US/EU region)
3. Create workspace for PDP Copy
4. Note your **Instance URL** (e.g., `https://your-workspace.n8n.cloud`)

**Cost**: Free tier includes 100 workflow executions/month. Scale up as needed.

### Option B: Self-Hosted (AWS EC2)

#### Step 1: Spin up EC2 Instance
```bash
# Launch Ubuntu 22.04 LTS instance (t3.medium recommended)
# Open ports: 22 (SSH), 80 (HTTP), 443 (HTTPS)
```

#### Step 2: Install Docker
```bash
sudo apt update && sudo apt install -y docker.io docker-compose

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

#### Step 3: Deploy n8n with Docker
```bash
# Create n8n directory
mkdir -p ~/n8n && cd ~/n8n

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  n8n:
    image: n8nio/n8n:latest
    container_name: n8n
    ports:
      - "80:3000"
    environment:
      - N8N_HOST=your-domain.com
      - N8N_PROTOCOL=https
      - N8N_PORT=443
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=postgres
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=secure_password_here
      - WEBHOOK_TUNNEL_URL=https://your-domain.com/
    volumes:
      - n8n_data:/home/node/.n8n
    depends_on:
      - postgres
    networks:
      - n8n_network
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    container_name: n8n-postgres
    environment:
      - POSTGRES_DB=n8n
      - POSTGRES_USER=n8n
      - POSTGRES_PASSWORD=secure_password_here
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - n8n_network
    restart: unless-stopped

volumes:
  n8n_data:
  postgres_data:

networks:
  n8n_network:
    driver: bridge
EOF

# Start services
docker-compose up -d

# Verify running
docker ps
```

#### Step 4: Set up HTTPS with Let's Encrypt
```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get certificate
sudo certbot certonly --standalone -d your-domain.com

# Auto-renew (cron job)
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

#### Step 5: Configure Nginx Reverse Proxy
```bash
sudo apt install -y nginx

# Create config
sudo tee /etc/nginx/sites-available/n8n > /dev/null << 'EOF'
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}
EOF

# Enable site
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

**Cost**: AWS t3.medium ~$25-35/month + data transfer

---

## 2. Configure Credentials in n8n

### Step 1: Add Shopify OAuth
1. In n8n, go to **Settings** → **Credentials**
2. Click **Create New** → Select **Shopify**
3. Fill in:
   - **API Key**: From your Shopify private app
   - **API Password**: From your Shopify private app
   - **Shop**: `yourstore.myshopify.com`
4. Click **Save**

### Step 2: Add OpenAI Credential
1. Click **Create New** → Select **OpenAI**
2. Fill in:
   - **API Key**: From [platform.openai.com](https://platform.openai.com)
   - **Model**: `gpt-4o`
3. Click **Save**

### Step 3: Add Claude Credential (Optional)
1. Click **Create New** → Select **Anthropic**
2. Fill in:
   - **API Key**: From [console.anthropic.com](https://console.anthropic.com)
3. Click **Save**

---

## 3. Import n8n Workflows

### Step 1: Import Single Product Workflow
1. In n8n, go to **Workflows** → **Create New**
2. Click **Menu** → **Import**
3. Upload file: `pdp-copy-single-product.json`
4. Review connections, update any missing credentials
5. Click **Save**

### Step 2: Import Bulk CSV Workflow
1. Repeat for `pdp-copy-bulk-csv.json`

### Step 3: Import Voice Training Workflow
1. Repeat for `voice-training-setup.json`

---

## 4. Set Up Environment Variables

Create `.env` file in n8n container:

```bash
# In n8n container or docker-compose environment section
SHOPIFY_DOMAIN=your-store.myshopify.com
SHOPIFY_API_KEY=your_api_key_here
SHOPIFY_API_PASSWORD=your_api_password_here

OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o

CLAUDE_API_KEY=sk-ant-...
CLAUDE_MODEL=claude-3-5-sonnet-20241022

WEBHOOK_ID=unique_webhook_id
WEBHOOK_URL=https://your-domain.com/webhook

# Database
DB_HOST=postgres
DB_PORT=5432
DB_NAME=n8n
DB_USER=n8n
DB_PASSWORD=secure_password

# n8n Settings
N8N_ENCRYPTION_KEY=your_random_encryption_key
GENERIC_TIMEZONE=UTC
```

---

## 5. Test Workflows

### Test 1: Single Product Rewrite
```bash
curl -X POST https://your-domain.com/webhook/pdp-copy/rewrite \
  -H "Content-Type: application/json" \
  -d '{
    "productId": "gid://shopify/Product/123456",
    "aiProvider": "openai",
    "brandVoice": "Professional",
    "keywords": "blue ceramic mug, coffee",
    "length": "Medium"
  }'
```

**Expected Response**:
```json
{
  "success": true,
  "message": "Product description rewritten and published successfully",
  "details": {
    "productId": "gid://shopify/Product/123456",
    "timestamp": "2026-08-15T10:30:00Z",
    "changes": {
      "description": "Updated",
      "metaTitle": "Blue Ceramic Coffee Mug | Handmade 12oz...",
      "metaDescription": "Shop beautiful handmade ceramic mugs..."
    }
  }
}
```

### Test 2: Bulk CSV Import
```bash
# Create test CSV
cat > test.csv << 'EOF'
productId,title,description,category,keywords
gid://shopify/Product/123456,Blue Ceramic Mug,A beautiful blue mug,Kitchen,ceramic mug
gid://shopify/Product/123457,Red Ceramic Mug,A beautiful red mug,Kitchen,ceramic mug
EOF

# Upload
curl -X POST https://your-domain.com/webhook/pdp-copy/bulk-import \
  -H "Content-Type: application/json" \
  -d '{
    "csvUrl": "https://example.com/test.csv",
    "aiProvider": "openai",
    "brandVoice": "Professional"
  }'
```

### Test 3: Voice Training
```bash
curl -X POST https://your-domain.com/webhook/pdp-copy/voice-training \
  -H "Content-Type: application/json" \
  -d '{
    "storeId": "gid://shopify/Shop/123456",
    "descriptions": [
      "Premium, handcrafted ceramic mugs perfect for daily use...",
      "Luxury coffee vessels made from sustainably sourced clay...",
      "Artisanal mugs that tell a story with every cup..."
    ]
  }'
```

---

## 6. Monitor & Logging

### n8n Built-in Monitoring
1. Go to **Workflow** → **Execution History**
2. View all runs: success/failure, duration, logs
3. Set up **Webhook** for errors:
   - Workflow → **Settings** → **On Error**
   - Send notification to Slack/Email

### Logging Best Practices
```javascript
// In code nodes, use:
console.log('Custom log:', $json.data);

// View in Execution History
```

### Error Handling
1. Set retry policy in workflow nodes
2. Add fallback email notifications
3. Log to database for debugging

---

## 7. Performance Optimization

### API Rate Limiting
- **Shopify**: 2 calls/second (burst to 40)
- **OpenAI**: ~60 requests/minute (based on plan)
- **Claude**: ~100 requests/minute

**Solution**: Add delays between batch operations
```javascript
// In loop node:
await new Promise(resolve => setTimeout(resolve, 500)); // 500ms delay
```

### Database Optimization
- Archive old execution logs monthly
- Index frequently queried fields
- Use database backups

### Caching
- Cache voice profiles in memory
- Cache Shopify product metadata (24h TTL)

---

## 8. Scaling Checklist

- [ ] n8n instance CPU/RAM adequate for expected volume
- [ ] Database backups automated (daily)
- [ ] HTTPS/SSL properly configured
- [ ] API credentials rotated every 90 days
- [ ] Rate limiting configured
- [ ] Error notifications set up
- [ ] Usage monitoring dashboard created
- [ ] Load testing completed (test 100 concurrent requests)

---

## 9. Troubleshooting

### Issue: Shopify API Authorization Failed
**Solution**:
1. Verify Shopify private app created in settings
2. Check scopes: `write_products`, `read_products`, `write_metafields`
3. Regenerate API key/password
4. Update credentials in n8n

### Issue: OpenAI API Rate Limit Exceeded
**Solution**:
1. Reduce batch size in bulk workflows
2. Add delay between API calls (500ms-1s)
3. Upgrade OpenAI plan for higher limits
4. Switch to Claude for some workflows

### Issue: n8n Webhook Not Triggering
**Solution**:
1. Verify webhook URL is publicly accessible
2. Check firewall rules (ports 80/443 open)
3. Verify SSL certificate valid (HTTPS)
4. Check n8n logs: `docker logs n8n`

### Issue: Database Connection Issues
**Solution**:
```bash
# Check Postgres is running
docker exec n8n-postgres pg_isready

# Check n8n can connect
docker exec n8n psql -h postgres -U n8n -d n8n -c "SELECT 1"

# Restart services
docker-compose restart
```

---

## 10. Security Checklist

- [ ] HTTPS enabled with valid SSL certificate
- [ ] API keys never logged in plain text
- [ ] Environment variables used for secrets
- [ ] n8n behind reverse proxy (nginx)
- [ ] Regular database backups (automated)
- [ ] IP whitelisting for webhook access (optional)
- [ ] Regular security audits (monthly)

---

**Setup Completion**: After completing these steps, all workflows should be ready for production use.

**Next Steps**: See [SHOPIFY_INTEGRATION.md](./SHOPIFY_INTEGRATION.md) for advanced Shopify setup and [API_REFERENCE.md](./API_REFERENCE.md) for API usage details.
