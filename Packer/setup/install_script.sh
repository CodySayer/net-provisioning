#Variables for the script
PORT="8080"
USER="todoapp"
APP_FILE="/home/todoapp/app"
NGINX_FILE="/home/admin/setup/nginx.conf"
NGINX_CONFIG="/etc/nginx/nginx.conf"
SERVICE_FILE="/home/admin/setup/todoapp.service"
SERVICE_CONFIG="/etc/systemd/system/todoapp.service"

#Installing the necessary packages for the script to run
package_install () {
    sudo yum -y install git nodejs mongodb-server nginx
}

#Enabling and starting Nginx and MongoDB
third_party_services_setup () {
    sudo systemctl enable mongod && sudo systemctl start mongod
    sudo systemctl enable nginx && sudo systemctl start nginx
}

#Setting up port forwarding 
firewall_setup () {
    sudo firewall-cmd --zone=public --add-port="$PORT"/tcp
}

#Setting up users
app_user_creation () {
    sudo useradd -m "$USER"
    printf 'todoapp:123456' | sudo chpasswd
    sudo usermod -L "$USER"
}

#Cloning repository and installing
app_files_setup () {
    sudo git clone https://github.com/timoguic/ACIT4640-todo-app.git "$APP_FILE"
    sudo npm install --prefix "$APP_FILE"
    sudo chown -R todoapp:todoapp "$APP_FILE"
    sudo chmod 755 /home/todoapp
    sudo chmod 755 "$APP_FILE"
    sudo chmod -R 755 "$APP_FILE"/public
}

#Setting up the web server
web_server_configuration () {
    sudo cp "$NGINX_FILE" "$NGINX_CONFIG"
    sudo systemctl restart nginx
}

#Setting the app daemon and starting it
app_daemon_setup () {
	sudo cp "$SERVICE_FILE" "$SERVICE_CONFIG"
    sudo systemctl daemon-reload
    sudo systemctl enable todoapp
    sudo systemctl start todoapp
}

echo "Starting..."

package_install
third_party_services_setup
firewall_setup
app_user_creation
app_files_setup
web_server_configuration
app_daemon_setup

echo "Finished!"