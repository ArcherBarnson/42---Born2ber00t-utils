#!/bin/sh
ARCHITECTURE=$(uname -a)
CPU_PHY=$(lscpu | awk 'NR == 5{printf($2)}')
vCPU=$(lscpu | awk 'NR == 5{printf($2)}')
MEM=$(free --mega | awk 'NR == 2{printf("#Memory Usage: %d/%dMB (%d%%)"), $3, $2, $3/$2*100}')
DISK=$(df -h /dev/sda5 | awk 'NR == 2{printf("#Disk Usage : %d/%dGb (%d%%)"), $3, $2, $5}')
CPU_LOAD=$(grep 'cpu ' /proc/stat | awk '{printf("%d%%"), ($2+$3)*100/($2+$3+$4)}')
LAST_BOOT=$(who -b | awk 'NR == 1{printf("%s at %s"), $3, $4}')
LVM=$(vgchange -ay | grep -o active)
if [ "$LVM" = "active" ]; then
	LVM_ACT='yes'
else
        LVM_ACT='no'
fi
TCP=$(netstat -tan | grep -o ESTABLISHED | wc -l)
USERS=$(who | wc -l)
IPV4=$(hostname -I)
MAC=$(cat /sys/class/net/enp0s3/address)
SUDO=$(tail /var/log/auth.log | wc -l)
wall "
#Architecture:$ARCHITECTURE
#CPU Physical : $CPU_PHY
#vCPU : $vCPU
$MEM
$DISK
#CPU Load: $CPU_LOAD
#Last Boot: $LAST_BOOT
#LVM Active: $LVM_ACT
#TCP Connexions : $TCP ESTABLISHED 
#Users logged in : $USERS
#Network: IP $IPV4 ($MAC)
#Sudo : $SUDO cmd"
