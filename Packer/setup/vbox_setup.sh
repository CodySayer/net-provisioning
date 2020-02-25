#!/bin/bash

vbmg () { VBoxManage "$@"; }

NET_NAME="NET_4640"
PXE_SSH_PORT="12222"
PXE_SERVER_VM_NAME="PXE_4640"
VM_NAME="TODO_4640"
SSH_PORT="12022"
WEB_PORT="12080"
BASE_DIR="/Users/diegofelix/VirtualBox VMs"
FILE="$BASE_DIR/$VM_NAME/$VM_NAME.vdi"

clean_all () {
    vbmg natnetwork remove --netname "$NET_NAME"
    vbmg unregistervm --delete "$VM_NAME"
}

create_network () {
    vbmg natnetwork add --netname "$NET_NAME" --network "192.168.230.0/24" --ipv6 "off" --dhcp "off" --enable 
    vbmg natnetwork modify --netname "$NET_NAME" --port-forward-4 "pxessh:tcp:[]:$PXE_SSH_PORT:[192.168.230.200]:22"
    vbmg natnetwork modify --netname "$NET_NAME" --port-forward-4 "guestssh:tcp:[]:$SSH_PORT:[192.168.230.10]:22"
    vbmg natnetwork modify --netname "$NET_NAME" --port-forward-4 "guesthttp:tcp:[]:$WEB_PORT:[192.168.230.10]:80"
}

create_vm () {
    vbmg createvm --name "$VM_NAME" --ostype "RedHat_64" --register
    vbmg modifyvm "$VM_NAME" --memory 2040 --cpus 1 --audio "none" --nic1 natnetwork --nat-network1 "$NET_NAME" --boot1 disk --boot2 net
    
    vbmg createmedium disk --filename "$FILE".vdi --size 10240 --variant Standard

    vbmg storagectl "$VM_NAME" --name SATA --add sata --bootable on
    vbmg storageattach "$VM_NAME" --storagectl SATA --port 0 --type hdd --medium "$FILE".vdi

    vbmg storagectl "$VM_NAME" --name IDE --add ide
    vbmg storageattach "$VM_NAME" --storagectl IDE --port 1 --device 1 --type dvddrive --medium emptydrive
}

clean_all
create_network
create_vm
