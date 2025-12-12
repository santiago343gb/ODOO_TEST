FROM odoo:17

# Copiar módulos personalizados
COPY ./extra-addons /mnt/extra-addons

EXPOSE 8069

# Instalar psycopg2 para conexión PostgreSQL
RUN pip install psycopg2-binary

CMD bash -c '\
echo "=> Starting Odoo with Render DATABASE_URL"; \
# Parse DATABASE_URL only at runtime
DB_USER=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ["DATABASE_URL"])
print(u.username)
EOF
) && \
DB_PASSWORD=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ["DATABASE_URL"])
print(u.password)
EOF
) && \
DB_HOST=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ["DATABASE_URL"])
print(u.hostname)
EOF
) && \
DB_PORT=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ["DATABASE_URL"])
print(u.port)
EOF
) && \
DB_NAME=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ["DATABASE_URL"])
print(u.path[1:])
EOF
) && \
echo "=> Odoo will use:" && \
echo "Host: $DB_HOST" && \
echo "Port: $DB_PORT" && \
echo "User: $DB_USER" && \
echo "Database: $DB_NAME" && \
odoo \
    --db_host=$DB_HOST \
    --db_port=$DB_PORT \
    --db_user=$DB_USER \
    --db_password=$DB_PASSWORD \
    --database=$DB_NAME \
    --addons-path=/usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons \
    --http-port=8069 \
'
