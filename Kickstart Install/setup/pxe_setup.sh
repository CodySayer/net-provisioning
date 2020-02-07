#!/bin/bash

echo "[Starting script...]"

echo "[setting /var/www/lighttpd permissions]"
sudo chmod 755 /var/www/lighttpd
echo "[setting /var/www/lighttpd/files ownership]"
sudo chown admin /var/www/lighttpd/files
# echo "[]"
# echo "[]"
# echo "[]"
# echo "[]"
# echo "[]"

# ! deprecated code
# echo "[Copying ./setup directory into VM]"
# scp -r ./setup todoapp:/home/admin
# scp ./setup/todoapp.service todoapp:/home/admin/setup/todoapp.service
# echo "[Running install script]"
# ssh todoapp 'echo P@ssw0rd | sudo -S /home/admin/setup/vm_setup.sh'