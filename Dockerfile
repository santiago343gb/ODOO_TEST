FROM odoo:17

# Copy addons
COPY ./extra-addons /mnt/extra-addons

# Copy startup script
COPY start-odoo.sh /usr/local/bin/start-odoo.sh
RUN chmod +x /usr/local/bin/start-odoo.sh

EXPOSE 8069

CMD ["/usr/local/bin/start-odoo.sh"]
