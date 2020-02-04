#!/bin/bash

install_packages () {
    sudo yum install update -y
    sudo yum install git -y
    sudo yum install nodejs npm -y
    sudo yum install mongodb-server npm -y
    sudo systemctl enable mongod && sudo systemctl start mongod
}

create_user () {
    sudo useradd todoapp
    echo "P@ssw0rd" | sudo passwd --stdin todoapp
    sudo mkdir /home/todoapp/app
    sudo chown todoapp -R /home/todoapp
    sudo su - todoapp
    sudo git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todoapp/app/ACIT4640-todo-app
}

install_application () {
    sudo npm install --prefix /home/todoapp/app/ACIT4640-todo-app
    sudo mv /home/admin/assignment1/database.js /home/todoapp/app/ACIT4640-todo-app/config/
    sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
    sudo firewall-cmd --runtime-to-permanent
    cd /home
    sudo chmod 655 -R /home/todoapp/
}

install_nginx () {
    sudo yum install nginx -y
    sudo systemctl enable nginx && systemctl start nginx
    sudo mv /home/admin/assignment1/nginx.conf /etc/nginx/
    sudo systemctl restart nginx
}

nodejs_systemd () {
    sudo mv /home/admin/assignment1/todoapp.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable todoapp
    sudo systemctl start todoapp
    sudo systemctl status todo app
    sudo systemctl restart nginx
}

echo "Starting script..."

install_packages
create_user
install_application
install_nginx
nodejs_systemd

echo "DONE!"