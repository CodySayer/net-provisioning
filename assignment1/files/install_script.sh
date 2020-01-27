#!/bin/bash

install_application () {
    npm install --prefix ~/app
}

install_nginx () {
    cd
    sudo yum install nginx -y
    sudo systemctl start nginx

}

nodejs_systemd () {
    sudo systemctl daemon-reload
    sudo systemctl enable todoapp
    sudo systemctl start todoapp
    sudo systemctl status todo app
    sudo systemctl restart nginx
}

echo "Starting script..."

install_application
install_nginx
nodejs_systemd

echo "DONE!"