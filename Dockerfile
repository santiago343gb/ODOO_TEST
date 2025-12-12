FROM odoo:17

COPY ./extra-addons /mnt/extra-addons

COPY ./start-odoo.sh /start-odoo.sh
RUN chmod +x /start-odoo.sh

CMD ["/start-odoo.sh"]
