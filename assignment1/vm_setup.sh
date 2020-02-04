#!/bin/bash

echo P@ssw0rd | ssh root@localhost -P 12022


# vm_connect () {
#     ssh admin@todoapp
# }

# install_packages () {
#     sudo yum install git
#     sudo yum install nodejs npm -y
#     sudo yum install mongodb-server npm -y
#     sudo systemctl enable mongod && systemctl start mongod
# }

# create_user () {
#     sudo useradd todoapp
#     echo "P@ssw0rd" | sudo passwd --stdin todoapp
#     sudo su - todoapp
#     git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todo-app/app/
# }

# echo "Starting script..."

# echo "P@ssw0rd" | scp -P 12022 -r assignment1 admin@localhost

# install_packages
# create_user

# echo "DONE!"