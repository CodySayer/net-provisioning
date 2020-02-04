#!/bin/bash

echo "Starting script..."

echo "Running vbox_setup.sh"
/bin/bash ./setup/vbox_setup.sh
echo "Copying ./setup directory into VM"
scp -r ./setup todoapp:/home/admin
echo "Running install script"
cat install_script.sh | ssh todoapp '/bin/bash /home/admin/setup'

echo "DONE!"