# n8n Local Setup - Next Steps

Your n8n instance is running! Here's how to access it and set up PDP Copy workflows.

## ✅ Access n8n

**URL**: http://localhost:5678

**Status**: 
- ✅ n8n Application: Running on port 5678
- ✅ PostgreSQL Database: Running on port 5432
- ✅ Ready for workflows

## 🔐 First-Time Setup

1. **Open browser**: Navigate to http://localhost:5678
2. **Create account**: 
   - Email: `your-email@example.com`
   - Password: Create a strong password
   - This becomes your owner account
3. **Click "Create account"**

After account creation, you're ready to import workflows!

---

## 📥 Import PDP Copy Workflows

### Option 1: Import via Web UI (Easiest)

1. In n8n, click **Workflows** → **Create New**
2. Click **Menu** (three dots) → **Import**
3. Upload workflow JSON files from:
   - `/workspaces/idea-lab/app_ideas/pdp-rewriter/n8n-workflows/pdp-copy-single-product.json`
   - `/workspaces/idea-lab/app_ideas/pdp-rewriter/n8n-workflows/pdp-copy-bulk-csv.json`
   - `/workspaces/idea-lab/app_ideas/pdp-rewriter/n8n-workflows/voice-training-setup.json`

4. Save each workflow
5. Connect credentials (Shopify, OpenAI/Claude)

### Option 2: Import via Folder

Files placed in the `workflows/` directory are auto-loaded:

```bash
# Copy workflows to n8n volume
cp /workspaces/idea-lab/app_ideas/pdp-rewriter/n8n-workflows/*.json \
   /workspaces/idea-lab/n8n-local/workflows/

# Restart n8n to load them
docker-compose restart n8n
```

---

## 🔧 Configure Credentials

### Shopify Credentials

1. In n8n, click **Settings** → **Credentials**
2. Click **Create New** → Select **Shopify**
3. Fill in:
   - **API Key**: From your Shopify private app
   - **API Password**: From your Shopify private app
   - **Shop**: `yourstore.myshopify.com`
4. Click **Save**

See `/workspaces/idea-lab/app_ideas/pdp-rewriter/SHOPIFY_INTEGRATION.md` for detailed Shopify setup.

### OpenAI Credentials

1. Click **Create New** → Select **OpenAI**
2. Fill in:
   - **API Key**: From platform.openai.com
   - **Model**: `gpt-4o`
3. Click **Save**

### Claude Credentials (Optional)

1. Click **Create New** → Select **Anthropic**
2. Fill in:
   - **API Key**: From console.anthropic.com
3. Click **Save**

---

## 🧪 Test a Workflow

### Single Product Rewrite Test

```bash
# Send test request to webhook
curl -X POST http://localhost:5678/webhook/pdp-copy/rewrite \
  -H "Content-Type: application/json" \
  -d '{
    "productId": "gid://shopify/Product/123456789",
    "aiProvider": "openai",
    "brandVoice": "Professional",
    "keywords": "ceramic mug, coffee",
    "length": "Medium",
    "storeId": "gid://shopify/Shop/123456789",
    "autoPublish": false
  }'
```

**View Results**:
1. In n8n UI, open the workflow
2. Click **Execution History**
3. View logs and output

---

## 📚 Documentation Location

All detailed documentation is in:
```
/workspaces/idea-lab/app_ideas/pdp-rewriter/
├── README.md                    (Product overview)
├── PRODUCT_SPEC.md             (Detailed specs)
├── BUSINESS_MODEL.md           (Pricing & GTM)
├── SETUP_GUIDE.md              (Full deployment guide)
├── SHOPIFY_INTEGRATION.md      (Shopify API setup)
├── API_REFERENCE.md            (API endpoints)
└── n8n-workflows/              (Workflow templates)
```

---

## 🎮 Common Tasks

### View n8n Logs
```bash
cd /workspaces/idea-lab/n8n-local
docker logs -f n8n
```

### View Database Logs
```bash
docker logs n8n-postgres
```

### Backup Database
```bash
cd /workspaces/idea-lab/n8n-local
./backup.sh
```

### Check Status
```bash
cd /workspaces/idea-lab/n8n-local
./status.sh
```

### Stop n8n
```bash
cd /workspaces/idea-lab/n8n-local
./stop.sh
```

### Restart n8n
```bash
cd /workspaces/idea-lab/n8n-local
docker-compose restart n8n
```

---

## 🔐 Update Encryption Key (Recommended)

Default encryption key is not secure. Update it:

```bash
# Generate random 32-char key
openssl rand -base64 32

# Update .env
nano /workspaces/idea-lab/n8n-local/.env

# Change: N8N_ENCRYPTION_KEY=your_encryption_key_here_minimum_32_chars_long
# To: N8N_ENCRYPTION_KEY=<paste_generated_key>

# Restart n8n
cd /workspaces/idea-lab/n8n-local
docker-compose restart n8n
```

---

## 🚀 Next Steps

1. ✅ Access http://localhost:5678
2. ✅ Create your account
3. 📥 Import PDP Copy workflows
4. 🔑 Configure Shopify & AI credentials
5. 🧪 Test with sample products
6. 📖 Review `/workspaces/idea-lab/app_ideas/pdp-rewriter/SETUP_GUIDE.md` for full details

---

## 💡 Tips

- **n8n Docs**: https://docs.n8n.io
- **n8n Community**: https://community.n8n.io
- **Keep backups**: Run `./backup.sh` regularly
- **Monitor costs**: Track OpenAI/Claude API usage in your provider dashboards
- **Save workflows**: Export workflows before major changes

---

**Ready to build? Let's go! 🚀**
