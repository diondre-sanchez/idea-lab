#!/bin/bash

# n8n Local Deployment - Logs Script
# Usage: ./logs.sh [service]
# Example: ./logs.sh n8n

SERVICE="${1:-n8n}"
LINES="${2:-50}"

case "$SERVICE" in
  n8n)
    echo "📝 n8n Application Logs (last $LINES lines)"
    echo "================================"
    docker logs --tail "$LINES" n8n
    ;;
  postgres|pg)
    echo "📝 PostgreSQL Logs (last $LINES lines)"
    echo "================================"
    docker logs --tail "$LINES" n8n-postgres
    ;;
  all)
    echo "📝 All Logs"
    echo "================================"
    echo ""
    echo "--- n8n Application ---"
    docker logs --tail 20 n8n
    echo ""
    echo "--- PostgreSQL ---"
    docker logs --tail 20 n8n-postgres
    ;;
  *)
    echo "Usage: ./logs.sh [service] [lines]"
    echo ""
    echo "Services:"
    echo "  n8n         - n8n application logs"
    echo "  postgres    - PostgreSQL logs"
    echo "  all         - All logs"
    echo ""
    echo "Examples:"
    echo "  ./logs.sh n8n           - Last 50 lines of n8n logs"
    echo "  ./logs.sh postgres 100  - Last 100 lines of PostgreSQL logs"
    ;;
esac
