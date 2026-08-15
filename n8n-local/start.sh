#!/bin/bash

# n8n Local Deployment - Startup Script
# Usage: ./start.sh

set -e

echo "🚀 Starting n8n local instance..."

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Creating from template..."
    cp .env.example .env 2>/dev/null || echo "Note: Create .env manually with your settings"
fi

# Check if encryption key is set
if grep -q "your_encryption_key_here" .env; then
    echo "⚠️  WARNING: Using default encryption key!"
    echo "   Generate a secure key: openssl rand -base64 32"
    echo "   Update N8N_ENCRYPTION_KEY in .env"
    echo ""
fi

# Pull latest images
echo "📥 Pulling latest Docker images..."
docker-compose pull

# Start services
echo "🐳 Starting Docker services..."
docker-compose up -d

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

# Check if services are running
echo "🔍 Checking service status..."
docker-compose ps

echo ""
echo "✅ n8n is starting up!"
echo ""
echo "📍 n8n URL: http://localhost:5678"
echo "🗄️  Database: PostgreSQL running on localhost:5432"
echo ""
echo "⏱️  Give it 10-15 seconds to fully initialize..."
echo ""
echo "📝 Next steps:"
echo "   1. Open http://localhost:5678 in your browser"
echo "   2. Create your first account"
echo "   3. Import PDP Copy workflows"
echo "   4. Configure credentials (Shopify, OpenAI, etc.)"
echo ""
echo "📖 View logs: docker logs -f n8n"
echo "🛑 Stop services: docker-compose down"
