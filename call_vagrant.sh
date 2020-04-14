#!/bin/bash 
echo "###################################################################################"
echo "Deleting virtualbox dhcp server, it will be created during vagrant up"
echo "This is to avoid network conflict due to vpn/non vpn network switch."
echo "###################################################################################"

for i in {0..10}
 do  
  #VBoxManage hostonlyif remove vboxnet$i 2>/dev/null
  echo "VBoxManage dhcpserver remove --ifname vboxnet$i"
  VBoxManage dhcpserver remove --ifname vboxnet$i 2>/dev/null
done
echo "sleeping for 30 seconds to refresh"
sp="/-\|"
echo -n ' '
timer=0
while true
do
    printf "\b${sp:i++%${#sp}:1}"
    sleep 1
    timer=$(echo "$timer + 1"|bc)
    if [[ $timer -eq 30 ]] 
     then
       break
    fi
done
echo " "
echo "calling [ vagrant halt ] "
vagrant halt
echo "calling [ vagrant up ] "
vagrant up --provision
