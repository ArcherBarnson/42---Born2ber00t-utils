#!/bin/sh
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0;37m'
WH='\033[1;37m'
printf "${WH}\n----------------------------------------------------------------------------------------------\n" && \
printf "		SSH CONFIG\n" && \
printf "\n----------------------------------------------------------------------------------------------\n${NC}" && \
sleep 1 && \
printf "${CYAN}Modfying /etc/ssh/sshd_config${NC}...\n" && \
sed -i -e "s/\(#Port \).*/\Port 4242/" \
-e "s/\(#PermitRootLogin \).*/\PermitRootLogin no/" /etc/ssh/sshd_config && \
printf "${GREEN}Done!${NC}\n\n" && \
sleep 1 && \
printf "\n${WH}----------------------------------------------------------------------------------------------\n" && \
printf "		PASSWORD POLICY\n" && \
printf "\n----------------------------------------------------------------------------------------------\n${NC}" && \
sleep 1 && \
printf "${CYAN}Modfying /etc/login.defs...${NC}\n" && \
sed -i -e "s/\(PASS_MAX_DAYS \).*/\PASS_MAX_DAYS 30/" \
-e "s/\(PASS_MIN_DAYS \).*/\PASS_MIN_DAYS 2/" \
-e "s/\(PASS_WARN_AGE \).*/\PASS_WARN_AGE 7/" /etc/login.defs && \
printf "${GREEN}Done!${NC}\n\n" && \
sleep 1 && \
printf "${CYAN}Modfying /etc/security/pwquality.conf...${NC}\n" && \
sed -i "/# difok/c\difok = 7" /etc/security/pwquality.conf && \
sed -i "/# minlen/c\minlen = 10" /etc/security/pwquality.conf && \
sed -i "/# dcredit/c\dcredit = -2" /etc/security/pwquality.conf && \
sed -i "/# ucredit/c\ucredit = -1" /etc/security/pwquality.conf && \
sed -i "/# maxrepeat/c\maxrepeat = 3" /etc/security/pwquality.conf && \
sed -i "/# usercheck/c\usercheck = 1" /etc/security/pwquality.conf && \
sed -i "/# enforce_for_root/c\enforce_for_root" /etc/security/pwquality.conf && \
printf "${GREEN}Done!${NC}\n\n" && \
sleep 1 && \
printf "${WH}\n----------------------------------------------------------------------------------------------\n" && \
printf "		UFW SETUP & SERVICES INIT\n" && \
printf "\n----------------------------------------------------------------------------------------------\n" && \
sleep 1 && \
printf "${CYAN}Activating the firewall and opening ports...\nSetting up hostname...${NC}\n" && \
ufw enable && ufw allow 22 && ufw allow 4242 && hostnamectl set-hostname bgrulois42 && \
printf "${CYAN}Restarting servives...${NC}\n" && \
printf "${GREEN}Done!${NC}\n\n" && \
systemctl restart ssh && systemctl start lighttpd && systemctl enable lighttpd && \
hostnamectl status && ufw status verbose && systemctl status ssh && \
printf "\n${GREEN}----------------------------------------------------------------------------------------------\n" && \
printf "		AUTOCONFIG COMPLETE :D\n" && \
printf "\n----------------------------------------------------------------------------------------------${NC}\n\n\n" && \
while true; do
    printf "Some of the services that were setup need a reboot to finalize their initialization.\n"
    read -p "Do you want to reboot now ? [Y/n]" yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) exit;;
    esac
done