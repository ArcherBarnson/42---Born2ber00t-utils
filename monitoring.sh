#!/bin/sh

LVM=$(vgchange -ay | grep -o active)
IPV4=$(hostname -I)
MAC=$(cat /sys/class/net/enp0s3/address)
wall \
printf "#Architecture : " && uname -a && \
printf "#CPU Physical : " && lscpu | awk 'NR == 5{printf("$2")}' && \
printf "\nvCPU : " && lscpu | awk 'NR == 5{printf("$2")}' && \
free --mega | awk 'NR == 2{printf("#Memory Usage: %d/%dMB (%d%%)"), $3, $2, $3/$2*100}' && \
df -h /dev/sda5 | awk 'NR == 2{printf("\n#Disk Usage : %d/%dGb (%d%%)"), $3, $2, $5}' && \
printf "\n#CPU Load : " && \
grep 'cpu ' /proc/stat | awk '{printf("%d%%"), ($2+$3)*100/($2+$3+$4)}' && \
printf "\n#Last Boot: $(who -b | awk 'NR == 1{printf("%s at %s"), $3, $4}')"
if [ "$LVM" = "active" ]; then
	printf "\n#LVM use: yes"
else
	printf "\n#LVM use: no"
fi && \
printf "\n#TCP Connexions : $(netstat -tan | grep -o ESTABLISHED | wc -l) ESTABLISHED" && \
printf "\n#Users logged in : $(who | wc -l)" && \
printf "\n#Network: IP $IPV4 ($MAC)\n" && \
printf "#Sudo : $(tail /var/log/auth.log | wc -l) cmd\n"
