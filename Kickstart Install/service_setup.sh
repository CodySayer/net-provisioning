#!/bin/bash

echo "[Starting script...]"

# echo "[Running vbox_setup.sh]"
# /bin/bash ./setup/vbox_setup.sh
echo "[Copying ./setup directory into VM]"
scp -r ./setup todoapp:/home/admin
scp ./setup/todoapp.service todoapp:/home/admin/setup/todoapp.service
# echo "[Running install script]"
# ssh todoapp 'echo P@ssw0rd | sudo -S /home/admin/setup/vm_setup.sh'

echo "[DONE!]"