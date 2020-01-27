#!/bin/bash

echo "Starting script..."

scp todoapp -r ./assignment1 admin@localhost:/home/admin
ssh todoapp '/bin/bash /home/admin/assignment1'

echo "DONE!"