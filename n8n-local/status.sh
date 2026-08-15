#!/bin/bash

# n8n Local Deployment - Status Script
# Usage: ./status.sh

echo "📊 n8n Service Status"
echo "===================="
echo ""

# Check if containers are running
echo "🐳 Docker Containers:"
docker-compose ps

echo ""
echo "💾 Storage Usage:"
docker system df

echo ""
echo "🔍 Network:"
docker inspect n8n_network 2>/dev/null | grep -A 20 '"Containers"' || echo "Network not found"

echo ""
echo "📝 Recent Logs (n8n):"
docker logs --tail 10 n8n 2>/dev/null || echo "No logs available"

echo ""
echo "💡 Commands:"
echo "  View full n8n logs:     docker logs -f n8n"
echo "  View PostgreSQL logs:   docker logs n8n-postgres"
echo "  Access PostgreSQL:      docker exec -it n8n-postgres psql -U n8n -d n8n"
echo "  Check port usage:       lsof -i :5678"
