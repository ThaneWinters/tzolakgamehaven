#!/bin/bash
#
# Create admin user for Game Haven v2
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

# Load environment
if [ -f .env ]; then
    source .env
fi

# Get credentials
if [ -z "$ADMIN_EMAIL" ]; then
    read -p "Admin email: " ADMIN_EMAIL
fi

if [ -z "$ADMIN_PASSWORD" ]; then
    read -sp "Admin password: " ADMIN_PASSWORD
    echo
fi

# Validate
if [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ]; then
    echo -e "${RED}Error: Email and password required${NC}"
    exit 1
fi

if [ ${#ADMIN_PASSWORD} -lt 6 ]; then
    echo -e "${RED}Error: Password must be at least 6 characters${NC}"
    exit 1
fi

echo -e "${YELLOW}Creating admin user...${NC}"

# Hash password using the API container
PASSWORD_HASH=$(docker exec gamehaven-api-v2 node -e "
const bcrypt = require('bcryptjs');
const hash = bcrypt.hashSync('$ADMIN_PASSWORD', 12);
console.log(hash);
")

# Insert user into database
docker exec -i gamehaven-db-v2 psql -U postgres -d gamehaven << EOSQL
INSERT INTO users (email, password_hash, display_name, role)
VALUES ('$ADMIN_EMAIL', '$PASSWORD_HASH', 'Admin', 'admin')
ON CONFLICT (email) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role = 'admin',
    updated_at = now();
EOSQL

echo -e "${GREEN}✓${NC} Admin user created: $ADMIN_EMAIL"
