#!/bin/bash

echo "Starting script..."

scp -r setup todoapp:/home/admin
cat install_script.sh | ssh todoapp '/bin/bash /home/admin/setup'

echo "DONE!"