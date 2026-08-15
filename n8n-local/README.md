# n8n Local Deployment Guide

Local n8n instance with PostgreSQL database for development and testing of PDP Copy workflows.

## 🚀 Quick Start

### 1. Start n8n
```bash
docker-compose up -d
```

### 2. Access n8n
- **URL**: http://localhost:5678
- **Default User**: Create on first access
- **Status**: Check with `docker ps`

### 3. Stop n8n
```bash
docker-compose down
```

---

## 📋 Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- 2GB RAM available
- Port 5678 (n8n) and 5432 (PostgreSQL) available

---

## 🔧 Configuration

### Environment Variables (.env)
Edit `.env` to configure:

```bash
# Database credentials
DB_POSTGRESDB_PASSWORD=n8n_password_change_me

# n8n host/port
N8N_HOST=localhost
N8N_PORT=5678

# Security: Generate encryption key
N8N_ENCRYPTION_KEY=your_encryption_key_here_minimum_32_chars_long
```

**Generate a secure encryption key**:
```bash
# Generate random 32-char key
openssl rand -base64 32
```

### Add API Credentials
Update `.env` with your API keys:

```bash
# For PDP Copy workflows
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
SHOPIFY_API_KEY=your_key
SHOPIFY_API_PASSWORD=your_password
```

---

## 📦 Services

### PostgreSQL Database
- **Container**: n8n-postgres
- **Port**: 5432
- **Database**: n8n
- **User**: n8n
- **Password**: Check `.env`
- **Volume**: `postgres_data/`

### n8n Application
- **Container**: n8n
- **Port**: 5678
- **URL**: http://localhost:5678
- **Volume**: `n8n_data/` (workflows, credentials, execution logs)
- **Network**: n8n_network (internal Docker network)

---

## 🔍 Common Commands

### Check Status
```bash
docker ps
docker logs n8n
docker logs n8n-postgres
```

### Enter Container
```bash
# Access n8n container
docker exec -it n8n bash

# Access PostgreSQL
docker exec -it n8n-postgres psql -U n8n -d n8n
```

### Backup Database
```bash
docker exec n8n-postgres pg_dump -U n8n n8n > backup-$(date +%Y%m%d-%H%M%S).sql
```

### Restore Database
```bash
docker exec -i n8n-postgres psql -U n8n n8n < backup-20260815-120000.sql
```

### View Logs
```bash
docker logs -f n8n              # Follow n8n logs
docker logs n8n-postgres        # PostgreSQL logs
```

### Reset Everything
```bash
# WARNING: This deletes all data!
docker-compose down -v
docker-compose up -d
```

---

## 🔐 Security Notes

1. **Change default password** in `.env`
2. **Generate encryption key**: `openssl rand -base64 32`
3. **Never commit `.env` file** to Git (already in .gitignore)
4. **Rotate API keys** regularly
5. **For production**: Use HTTPS, reverse proxy (nginx), and SSL certificates

---

## 📥 Importing Workflows

### Method 1: Web UI
1. Open http://localhost:5678
2. Click **Workflows** → **Create New**
3. Click menu → **Import**
4. Upload JSON workflow file

### Method 2: API
```bash
curl -X POST http://localhost:5678/api/v1/workflows \
  -H "Content-Type: application/json" \
  -d @workflow.json
```

### Method 3: File Volume
1. Copy workflow JSON to `./workflows/` directory
2. It will appear in n8n UI
3. Reload n8n: `docker-compose restart n8n`

---

## 🧪 Testing PDP Copy Workflows

### Test Single Product Rewrite
```bash
curl -X POST http://localhost:5678/webhook/pdp-copy/rewrite \
  -H "Content-Type: application/json" \
  -d '{
    "productId": "gid://shopify/Product/123456789",
    "aiProvider": "openai",
    "brandVoice": "Professional",
    "keywords": "ceramic mug, coffee",
    "length": "Medium"
  }'
```

### View Execution
1. Open n8n → Workflows
2. Select workflow
3. Click **Execution History**
4. View logs and output

---

## 🆘 Troubleshooting

### Issue: Port Already in Use
```bash
# Find what's using port 5678
lsof -i :5678

# Use different port in docker-compose.yml
# Change: - "5678:5678" to - "5679:5678"
```

### Issue: PostgreSQL Connection Failed
```bash
# Check PostgreSQL is running
docker ps | grep postgres

# Check logs
docker logs n8n-postgres

# Restart services
docker-compose restart postgres
docker-compose restart n8n
```

### Issue: n8n Won't Start
```bash
# Check logs
docker logs n8n

# Verify encryption key is correct (min 32 chars)
# Restart with fresh start
docker-compose down
docker-compose up -d
```

### Issue: Out of Disk Space
```bash
# Clean up Docker
docker system prune -a

# Remove old volumes
docker volume prune
```

---

## 📊 Monitoring

### Database Size
```bash
docker exec n8n-postgres psql -U n8n -d n8n -c "
SELECT 
  schemaname,
  SUM(pg_total_relation_size(schemaname||'.'||tablename))::TEXT AS size
FROM pg_tables
GROUP BY schemaname;
"
```

### n8n Execution Count
```bash
docker exec n8n-postgres psql -U n8n -d n8n -c "
SELECT COUNT(*) as total_executions FROM execution;
"
```

### Disk Usage
```bash
docker system df
```

---

## 🔄 Scaling & Performance

### For High Volume (100+ executions/day)

1. **Increase Resources**:
   ```yaml
   services:
     n8n:
       deploy:
         resources:
           limits:
             cpus: '2'
             memory: 2G
   ```

2. **Optimize Database**:
   ```sql
   CREATE INDEX idx_execution_workflow ON execution(workflowId);
   CREATE INDEX idx_execution_status ON execution(status);
   ```

3. **Archive Old Executions**:
   ```bash
   # Keep only last 30 days
   docker exec n8n-postgres psql -U n8n -d n8n -c "
   DELETE FROM execution WHERE createdAt < NOW() - INTERVAL '30 days';
   "
   ```

---

## 📝 Workflow Development Tips

1. **Use Test Nodes**: Add test/debug nodes to workflows before production
2. **Check Logs**: Monitor execution history for errors
3. **Backup Workflows**: Export workflows regularly
4. **Version Control**: Keep workflow JSONs in Git
5. **Document**: Add descriptions to nodes and workflows

---

## 🔗 Useful Links

- **n8n Docs**: https://docs.n8n.io
- **n8n Community**: https://community.n8n.io
- **Docker Docs**: https://docs.docker.com
- **PostgreSQL Docs**: https://www.postgresql.org/docs/

---

## 📄 Next Steps

1. Import PDP Copy workflows from `/workspaces/idea-lab/app_ideas/pdp-rewriter/n8n-workflows/`
2. Configure credentials (Shopify, OpenAI, Claude)
3. Test workflows with sample data
4. Monitor execution history
5. Export workflows before making changes

---

**Last Updated**: 2026-08-15  
**Status**: Production-Ready
