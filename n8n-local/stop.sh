#!/bin/bash

# n8n Local Deployment - Shutdown Script
# Usage: ./stop.sh

set -e

echo "🛑 Stopping n8n..."
docker-compose down

echo "✅ n8n stopped"
echo ""
echo "💡 To start again: ./start.sh"
echo "⚠️  To reset all data: docker-compose down -v && ./start.sh"
