#!/bin/bash

# ==== MAKI ====
sed -i '/location \/ {/a \        allow 10.82.1.4;\n        deny all;' /etc/nginx/sites-available/default
nginx -t && service nginx restart

# ==== PANDA ====
sed -i '/location \/ {/a \        allow 10.82.1.4;\n        deny all;' /etc/nginx/sites-available/default
nginx -t && service nginx restart

# ==== NANAMI ====
sed -i '/location \/ {/a \        allow 10.82.4.2;\n        deny all;' /etc/nginx/sites-available/default
nginx -t && service nginx restart

# ==== TODO ====
sed -i '/location \/ {/a \        allow 10.82.4.2;\n        deny all;' /etc/nginx/sites-available/default
nginx -t && service nginx restart

# ==== KIRARA ====
sed -i '/location \/ {/a \        allow 10.82.4.2;\n        deny all;' /etc/nginx/sites-available/default
nginx -t && service nginx restart
