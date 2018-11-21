#!/bin/bash

LOG=/var/log/nexmonitor.log

dizi=(httpd iptables firewalld systemd)
dizisay=${#dizi[@]}

cat <<EOF >$LOG

$(for (( i = 0; i < $dizisay; i++ )); do
	service=${dizi[$i]}
	if ps ax | grep -v grep | grep $service > /dev/null; then 
		echo "$service : calisiyor"; 
	else 
		echo "$service : calismiyor"; fi
done)

$(uptime | awk '{print "Load : " $8, $9, $10}')
$(uptime | awk '{print "Kac Kisi Bagli : " $4}')
$(uptime | awk '{print "Uptime : " $3}')
$(free -m | grep -v shared | awk '/^M/ {print "Ram Kapasitesi : "$2"MB", "\nKullanilan Ram : "$3"MB", "\nKKullanilabilir Ram : "$4"MB" }')
$(df -h | awk '/^\// {print "Disk Kullanimi : "$5, "\nDisk Boyutu : "$2 , "\nKullanilan Alan : "$3 , "\nKullanilabilir Alan : "$4 }')
$(echo -n "CPU Kullanımı : "; grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print "%"usage ""}')
$(echo -n "IP : "; curl ipinfo.io/ip 2>/dev/null)
$(echo -n "Hostname : "; hostname)

EOF
