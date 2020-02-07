#!/bin/bash

PXE_VM="PXE4640"
TODO_VM="TODO4640"

# Begin
 vbmg () { /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe "$@"; }

echo "[Starting script...]"

echo "[Running vbox_setup.sh]"
./vbox_setup.sh

# Turn on PXE VM
vbmg startvm "$PXE_VM"

# Wait for PXE to be available

while /bin/true; do
        ssh -i ~/ssh_keys/acit_admin_id_rsa -p 12222 \
            -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
            -q admin@localhost exit
        if [ $? -ne 0 ]; then
                echo "PXE server is not up, sleeping..."
                sleep 2
        else
                break
        fi
done

echo "[Copying necessary files to PXEboot server]"
scp -r ./setup/ pxe:/var/www/lighttpd/files/

echo "[Running install script]"
ssh pxe 'echo P@ssw0rd | sudo -S /var/www/lighttpd/files/setup/pxe_setup.sh'

# Turn on TODO VM
vbmg startvm "$TODO_VM"

while /bin/true; do
        ssh -i ~/ssh_keys/acit_admin_id_rsa -p 12022 \
            -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
            -q admin@localhost exit
        if [ $? -ne 0 ]; then
                echo "TODO machine is not up, sleeping..."
                sleep 15
        else
                break
        fi
done

# ! deprecated code
# echo "[Copying ./setup directory into VM]"
# scp -r ./setup todoapp:/home/admin
# scp ./setup/todoapp.service todoapp:/home/admin/setup/todoapp.service
# echo "[Running install script]"
# ssh todoapp 'echo P@ssw0rd | sudo -S /home/admin/setup/vm_setup.sh'

echo "[DONE!]"