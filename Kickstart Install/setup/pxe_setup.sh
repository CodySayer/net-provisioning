#!/bin/bash

echo "[Starting script...]"

echo "[setting /var/www/lighttpd permissions]"
sudo chmod 755 /var/www/lighttpd >> /dev/null
echo "[setting /var/www/lighttpd/files ownership]"
sudo chown admin /var/www/lighttpd/files >> /dev/null
echo "[setting permissions for acit_admin_id_rsa.pub]"
sudo chmod 644 /var/www/lighttpd/files/setup/acit_admin_id_rsa.pub >> /dev/null
echo "[replacing default ks.cfg]"
sudo mv /var/www/lighttpd/files/setup/ks.cfg /var/www/lighttpd/files/ks.cfg >> /dev/null
