#!/bin/bash

copy_configs () {
    echo "[Copying necessary files into VM]"
    scp -r ./setup midterm:/home/midterm
    echo "[Running install script]"
    ssh midterm 'echo P@ssw0rd | sudo -S /home/midterm/setup/vm_setup.sh'
}


echo "Starting script..."

copy_configs

echo "DONE!"
