#!/bin/bash

echo "Starting script..."

scp -r setup todoapp:/home/admin
ssh todoapp '/bin/bash /home/admin/setup'

echo "DONE!"