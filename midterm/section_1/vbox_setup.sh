#!/bin/bash

# This is a shortcut function that makes it shorter and more readable
vbmg () { /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe "$@"; }

NET_NAME="NETMIDTERM"
VM_NAME="A01048668"
SSH_PORT="12922"
WEB_PORT="12980"
# SED_PROGRAM="/^Config file:/ { s/^.*:\s\+\(\S\+\)/\1/; s|\\\\|/|gp }"
# VBOX_FILE=$(vbmg showvminfo "$VM_NAME" | sed -ne "$SED_PROGRAM")
# VM_DIR=$(dirname "$VBOX_FILE")

# This function will clean the NAT network and the virtual machine
clean_all () {
    vbmg natnetwork remove --netname "$NET_NAME"

}

create_network () {
    vbmg natnetwork add --netname "$NET_NAME" --network "192.168.10.0/24"  --dhcp "off" --ipv6 "off" --port-forward-4 "SSH:tcp:[]:12922:[192.168.10.10]:22" --port-forward-4 "HTTP:tcp:[]:12980:[192.168.10.10]:80" #--port-forward-4 "PXESSH:tcp:[]:12222:[192.168.230.200]:22"

}

change_vm () {
    vbmg modifyvm MIDTERM4640 --name "$VM_NAME" --nic1 natnetwork --nat-network1 "$NET_NAME"

}

up_check () {

    vbmg startvm "$VM_NAME"

    while /bin/true; do
            ssh -i ~/.ssh/midterm_id_rsa -p 12922 \
            -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
            -q midterm@localhost exit
            if [ $? -ne 0 ]; then
                echo "MIDTERM machine is not up, sleeping..."
                sleep 15
            else
                echo
                echo "MACHINE UP!!!"
                echo
                break
            fi
    done
}

echo "Starting script..."

clean_all
change_vm
create_network
up_check

echo "DONE!"