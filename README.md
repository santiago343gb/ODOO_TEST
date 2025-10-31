# Instalación paso a paso de Odoo 17 en Render

Este repositorio sirve como guía para instalar Odoo 17 desde cero en Render usando GitHub. Está pensado para personas que nunca instalaron Odoo ni usaron Render.

## 2. Requisitos

- Cuenta en GitHub.  
- Cuenta en Render.  
- Conexión a Internet y navegador web.  
- No se requieren conocimientos previos de programación.

## 3. Crear el repositorio en GitHub

1. Entra en tu cuenta de GitHub.  
2. Haz clic en **New Repository**.  
3. Nómbralo, por ejemplo: `odoo_render_demo`.  
4. Marca la casilla **Add a README file**.  
5. Haz clic en **Create repository**.  


## 4. Estructura de archivos del proyecto

odoo_render_demo/
├── Dockerfile
├── README.md
└── extra-addons/
└── dummy_module/
├── init.py
├── manifest.py
└── .gitkeep

### Módulo de ejemplo `dummy_module`

**extra-addons/dummy_module/__manifest__.py**

```python
{
    "name": "Dummy Module",
    "version": "1.0",
    "summary": "Módulo vacío de prueba",
    "installable": True,
}
# Archivo vacío para que Odoo reconozca la carpeta como un módulo
FROM odoo:17
# Copiamos los módulos personalizados
COPY ./extra-addons /mnt/extra-addons
# Puerto donde Odoo escucha
EXPOSE 8069
# Puerto por defecto de PostgreSQL
ENV PGPORT=5432
# Inicializa la base de datos y arranca Odoo
CMD ["bash","-lc", "\
echo '==> Checking/initializing DB $PGDATABASE' && \
odoo -d $PGDATABASE -i base --without-demo=all \
--db_host=$PGHOST --db_port=$PGPORT \
--db_user=$PGUSER --db_password=$PGPASSWORD \
--addons-path=/usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons \
--stop-after-init || true; \
echo '==> Starting Odoo server' && \
odoo --db_host=$PGHOST --db_port=$PGPORT \
--db_user=$PGUSER --db_password=$PGPASSWORD \
--addons-path=/usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons \
--db-filter=$PGDATABASE \
--dev=all"]


