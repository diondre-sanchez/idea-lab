#!/bin/bash

# n8n Local Deployment - Backup Script
# Usage: ./backup.sh

set -e

BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/n8n-backup-$TIMESTAMP.sql"

# Create backups directory
mkdir -p "$BACKUP_DIR"

echo "💾 Backing up n8n database..."

# Backup PostgreSQL
docker exec n8n-postgres pg_dump -U n8n n8n > "$BACKUP_FILE"

echo "✅ Backup complete!"
echo "📁 Location: $BACKUP_FILE"
echo ""
echo "🔄 To restore:"
echo "   docker exec -i n8n-postgres psql -U n8n n8n < $BACKUP_FILE"

# List recent backups
echo ""
echo "📋 Recent backups:"
ls -lh "$BACKUP_DIR" | tail -5
