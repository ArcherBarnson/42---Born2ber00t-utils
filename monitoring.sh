#!/bin/sh

LVM=$(vgchange -ay LVMGroup | awk 'NR == 1{printf("%s"), $9}')
IPV4=$(hostname -I)
MAC=$(cat /sys/class/net/enp3s0f0/address)

printf "#Architecture : " && uname -a && \
free --mega | awk 'NR == 2{printf("#Memory Usage: %d/%dMB (%d%)"), $3, $2, $3/$2*100}' && \
df -h /dev/sda | awk 'NR == 2{printf("\n#Disk Usage : %d/%dGb (%d%)"), $3, $2, $5}' && \
if [$LVM == 'active']; then
	printf "#LVM use: yes"
else
	printf "#LVM use: no"
fi && \
printf "\n#Network: IP $IPV4 ($MAC)"
