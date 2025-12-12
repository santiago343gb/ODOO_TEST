#!/bin/bash
set -e

echo ">>> Generating Odoo configuration..."

DB_PARAMS=$(python3 - <<EOF
import os, urllib.parse
url = urllib.parse.urlparse(os.environ["DATABASE_URL"])
print(f"""
[options]
db_host = {url.hostname}
db_port = {url.port}
db_user = {url.username}
db_password = {url.password}
addons_path = /usr/lib/python3/dist-packages/odoo/addons,/var/lib/odoo/addons/17.0,/mnt/extra-addons
""")
EOF
)

echo "$DB_PARAMS" > /etc/odoo/odoo.conf

echo ">>> Starting Odoo..."
exec odoo -c /etc/odoo/odoo.conf
