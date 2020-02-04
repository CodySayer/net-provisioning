#!/bin/bash

echo "Starting script..."

scp todoapp -r ./assignment1 admin@localhost:/home/admin
ssh todoapp '/bin/bash /home/admin/assignment1'

# echo "Starting script..."

# echo "P@ssw0rd" | scp -P 12022 -r assignment1 admin@localhost

# install_packages
# create_user

# echo "DONE!"