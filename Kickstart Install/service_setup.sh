#!/bin/bash

# set colors
RED='\033[0;31m'
BLUE='\033[0;36m'
GREEN='\e[32m'
NC='\033[0m'

# set VM names
PXE_VM="PXE4640"
TODO_VM="TODO4640"

vbmg () {
        /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe "$@";
}


# ! SET UP VIRTUALBOX ENVIRONMENT
vboxSetup () {
        echo "[Running vbox_setup.sh]"
        ./vbox_setup.sh
}

pxeSetup () {
        # ! TURN ON PXE MACHINE
        vbmg startvm "$PXE_VM"

        # ! WAIT FOR PXE MACHINE
        while /bin/true; do
                ssh -i ~/.ssh/acit_admin_id_rsa -p 12222 \
                -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                -q admin@localhost exit
                if [ $? -ne 0 ]; then
                        echo "PXE server is not up, sleeping..."
                        sleep 2
                else
                        break
                fi
        done

        # ! PRE-INSTALL PXE MACHINE SETUP
        echo "[Copying necessary files to PXEboot server]"
        scp -r ./setup/ pxe:/var/www/lighttpd/files/ >> /dev/null
        echo "[Running install script]"
        ssh pxe 'echo P@ssw0rd | sudo -S /var/www/lighttpd/files/setup/pxe_setup.sh'
}

todoappSetup () {
        # ! TURN ON TODOAPP MACHINE
        vbmg startvm "$TODO_VM"

        # ! WAIT FOR TODOAPP MACHINE
        while /bin/true; do
                ssh -i ~/.ssh/acit_admin_id_rsa -p 12022 \
                -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                -q admin@localhost exit
                if [ $? -ne 0 ]; then
                        echo "TODO machine is not up, sleeping..."
                        sleep 15
                else
                        break
                fi
        done
}

todoappPostInstall () {
        # ! RUNS IN TODOAPP MACHINE
        vbmg controlvm "$PXE_VM" poweroff soft
        echo "[Copying ./setup directory into VM]"
        scp -r ./setup todoapp:/home/admin
        scp ./setup/todoapp.service todoapp:/home/admin/setup/todoapp.service
        echo "[Running install script]"
        ssh todoapp 'echo P@ssw0rd | sudo -S /home/admin/setup/vm_setup.sh'
}

theWholeShebang () {
        echo
        echo
        echo -e ${GREEN}[Starting script...]${NC}
        echo
        echo -e [${BLUE}1/4${NC}] Setting up VirtualBox machine
        echo
        sleep 1
        vboxSetup
        sleep 1
        echo
        echo -e ${GREEN}[Done setting up VirtualBox machine\!]${NC}
        sleep 3
        echo
        echo -e [${BLUE}2/4${NC}] Setting up PXE server
        echo
        sleep 1
        pxeSetup
        sleep 1
        echo
        echo -e ${GREEN}[Done setting up PXE server\!]${NC}
        sleep 3
        echo
        echo -e [${BLUE}3/4${NC}] Running autodeploy on TODO
        echo
        sleep 1
        todoappSetup
        sleep 1
        echo
        echo -e ${GREEN}[Done running autodeploy on TODO\!]${NC}
        sleep 3
        echo
        echo -e [${BLUE}4/4${NC}] Running post-install on TODO
        echo
        sleep 1
        todoappPostInstall
        sleep 1
        echo
        echo -e ${GREEN}[Done running post-install on TODO\!]${NC}
        sleep 2
        echo
        echo -e ${GREEN}[DONE\!]${NC}
        echo
        echo
}

theWholeShebang