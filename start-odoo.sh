#!/bin/bash
set -e

# Parse DATABASE_URL into components
python3 << 'EOF' > /tmp/db_parsed.txt
import os, urllib.parse
url = urllib.parse.urlparse(os.environ["DATABASE_URL"])

print(url.hostname)
print(url.port or 5432)
print(url.username)
print(url.password)
print(url.path.lstrip("/"))
EOF

DB_HOST=$(sed -n '1p' /tmp/db_parsed.txt)
DB_PORT=$(sed -n '2p' /tmp/db_parsed.txt)
DB_USER=$(sed -n '3p' /tmp/db_parsed.txt)
DB_PASSWORD=$(sed -n '4p' /tmp/db_parsed.txt)
DB_NAME=$(sed -n '5p' /tmp/db_parsed.txt)

echo "==> Parsed database info:"
echo "HOST=$DB_HOST"
echo "PORT=$DB_PORT"
echo "USER=$DB_USER"
echo "DB=$DB_NAME"

# Initialize database (safe for repeated runs)
echo "==> Initializing database $DB_NAME..."
odoo -d "$DB_NAME" --db_host="$DB_HOST" --db_port="$DB_PORT" \
     --db_user="$DB_USER" --db_password="$DB_PASSWORD" \
     --without-demo=all --stop-after-init || true

# Start server
echo "==> Starting Odoo server"
exec odoo -d "$DB_NAME" --db_host="$DB_HOST" --db_port="$DB_PORT" \
     --db_user="$DB_USER" --db_password="$DB_PASSWORD" \
     --addons-path="/usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons" \
     --http-port="$PORT"
