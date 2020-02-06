#!/bin/bash

install_packages () {
    echo "[updating repos]"
    echo P@ssw0rd | sudo -S yum install update -y >> /dev/null
    echo "[installing git]"
    sudo yum install git -y >> /dev/null
    echo "[adding node repo]"
    curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash - >> /dev/null
    echo "[installing node]"
    sudo yum install nodejs -y >> /dev/null
    echo "[copying mongodb repo]"
    sudo cp /home/admin/setup/mongodb-org.repo /etc/yum.repos.d/mongodb-org.repo >> /dev/null
    echo "[installing mongodb server]"
    sudo yum install mongodb-org-server -y >> /dev/null
    echo "[enabling and starting mongod]"
    echo P@ssw0rd | sudo -S systemctl enable mongod >> /dev/null
    echo P@ssword | sudo -S systemctl start mongod >> /dev/null
}

create_user () {
    echo "[adding todoapp user]"
    sudo useradd todoapp >> /dev/null
    echo "[setting todoapp password]"
    echo "P@ssw0rd" | sudo passwd --stdin todoapp >> /dev/null
    echo "[making todoapp home directory]"
    sudo mkdir /home/todoapp/app >> /dev/null
    echo "[giving todoapp home ownership]"
    sudo chown todoapp -R /home/todoapp >> /dev/null
    echo "[git cloning as todoapp]"
    sudo git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todoapp/app/ACIT4640-todo-app
}

install_application () {
    echo "[running npm install]"
    sudo npm install --prefix /home/todoapp/app/ACIT4640-todo-app >> /dev/null
    echo "[moving database.js from setup folder to target]"
    sudo mv /home/admin/setup/database.js /home/todoapp/app/ACIT4640-todo-app/config/ >> /dev/null
    echo "[setting firewall rules]"
    sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp >> /dev/null
    sudo firewall-cmd --runtime-to-permanent >> /dev/null
    echo "[returning home and setting permissions]"
    cd /home >> /dev/null
    sudo chmod 655 -R /home/todoapp/ >> /dev/null
}

# TODO: breakout test this function
# install_nginx () {
#     sudo yum install nginx -y
#     sudo systemctl enable nginx && systemctl start nginx
#     sudo mv /home/admin/assignment1/nginx.conf /etc/nginx/
#     sudo systemctl restart nginx
# }

# TODO: breakout test this function
# nodejs_systemd () {
#     sudo mv /home/admin/assignment1/todoapp.service /etc/systemd/system/
#     sudo systemctl daemon-reload
#     sudo systemctl enable todoapp
#     sudo systemctl start todoapp
#     sudo systemctl status todo app
#     sudo systemctl restart nginx
# }

echo "Starting script..."

install_packages
create_user
install_application
# install_nginx
# nodejs_systemd

echo "DONE!"