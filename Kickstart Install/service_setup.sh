#!/bin/bash

echo "[Starting script...]"

# echo "[Running vbox_setup.sh]"
# /bin/bash ./setup/vbox_setup.sh
echo "[Copying ./setup directory into VM]"
scp -r ./setup todoapp:/home/admin
# echo "[Running install script]"
# ssh todoapp 'echo P@ssw0rd | sudo -S /home/admin/setup/vm_setup.sh'

echo "[DONE!]"