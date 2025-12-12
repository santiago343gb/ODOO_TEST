# Imagen base Odoo 17
FROM odoo:17

# Copiar módulos personalizados
COPY ./extra-addons /mnt/extra-addons

# Puerto HTTP
EXPOSE 8069

# Render nos da la variable DATABASE_URL con este formato:
# postgresql://user:password@host:port/dbname
# Odoo necesita los parámetros separados. Los extraemos con python.
RUN pip install psycopg2-binary

CMD bash -c "\
    echo '=> Parsing DATABASE_URL...' && \
    export DB_USER=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ['DATABASE_URL'])
print(u.username)
EOF
) && \
    export DB_PASSWORD=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ['DATABASE_URL'])
print(u.password)
EOF
) && \
    export DB_HOST=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ['DATABASE_URL'])
print(u.hostname)
EOF
) && \
    export DB_PORT=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ['DATABASE_URL'])
print(u.port)
EOF
) && \
    export DB_NAME=$(python3 - <<EOF
import os, urllib.parse
u = urllib.parse.urlparse(os.environ['DATABASE_URL'])
print(u.path[1:])
EOF
) && \
    echo '=> Starting Odoo with external PostgreSQL...' && \
    odoo \
        --db_host=$DB_HOST \
        --db_port=$DB_PORT \
        --db_user=$DB_USER \
        --db_password=$DB_PASSWORD \
        --database=$DB_NAME \
        --addons-path=/usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons \
        --http-port=8069"
