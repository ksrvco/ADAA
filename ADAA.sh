#!/bin/bash
# Project name: ADAA - Automatic defense against the attacker
# Written by: KsrvcO
# Version: 1.0
# Tested on: Debian based linux servers
# Contact me: flower.k2000@gmail.com
reset
if ! [ $(id -u) = 0 ]; then
	   echo "Run this tool as root privilege."
	   exit 1
else
echo -e "

   ▄████████ ████████▄     ▄████████    ▄████████ 
  ███    ███ ███   ▀███   ███    ███   ███    ███ 
  ███    ███ ███    ███   ███    ███   ███    ███ 
  ███    ███ ███    ███   ███    ███   ███    ███ 
▀███████████ ███    ███ ▀███████████ ▀███████████ 
  ███    ███ ███    ███   ███    ███   ███    ███ 
  ███    ███ ███   ▄███   ███    ███   ███    ███ 
  ███    █▀  ████████▀    ███    █▀    ███    █▀  
                                       by KsrvcO    
                                                  
 [+] Project name: ADAA - Automatic defense against the attacker 
 [+] Written by: KsrvcO  
 [+] Version: 1.0     
 [+] Contact me: flower.k2000@gmail.com                                     

 "
read -p "[+] Enter your trusted ip address: " trust
read -p "[+] Enter your path for important data (ex: /home/s2/credentials/ ): " data
read -p "[+] Enter your key for encrypting your data: " key
echo "[++] Started monitoring..."
while (true)
do
sleep 10
last | grep "still logged in" | awk '/ / {print $3}' | grep -v $trust > attacker_ip.txt
last | grep "still logged in" | grep -v $trust | awk '/ / {print $2}' > pts.txt
if [ -s attacker_ip.txt ]
    then
        for i in $(ls $data | tr "" "\n")
            do
            gpg --batch -c --passphrase $key $data$i
            done
        find $data -type f -not -name '*gpg' -print0 | xargs -0 rm --
        for j in $(cat attacker_ip.txt)
        do
            iptables -I INPUT -p tcp -s $j -j DROP
        done
        for k in $(cat pts.txt)
        do 
            pkill -9 -t $k 
        done
        cat attacker_ip.txt >> blocked_history.txt
        rm -rf attacker_ip.txt
        rm -rf pts.txt
        ## Put your code here for sending encrypted files to your email address.
fi
done
fi
