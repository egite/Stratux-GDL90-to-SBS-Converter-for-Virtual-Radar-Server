#!/bin/sh
#make sure socat is installed
sudo apt update
sudo apt install socat -y

#make sure dump978-fa is installed (not including -y in case user wants to do something with config files), but need to get piaware repository first
wget https://www.flightaware.com/adsb/piaware/files/packages/pool/piaware/f/flightaware-apt-repository/flightaware-apt-repository_1.2_all.deb
sudo dpkg -i flightaware-apt-repository_1.2_all.deb
sudo apt update
sudo apt install dump978-fa skyview978 
cd ~pi ; wget -N https://github.com/egite/Stratux-GDL90-to-SBS-Converter-for-Virtual-Radar-Server/releases/latest/download/dump978-check.sh

#copy over the Stratux binary, lib and conf file
sudo wget -N https://github.com/egite/Stratux-GDL90-to-SBS-Converter-for-Virtual-Radar-Server/releases/latest/download/gen_gdl90 ; sudo chmod 755 gen_gdl90
sudo mkdir /opt ; sudo mkdir /opt/stratux ; sudo mkdir /opt/stratux/lib ; cd /opt/stratux/lib
sudo wget -N https://github.com/egite/Stratux-GDL90-to-SBS-Converter-for-Virtual-Radar-Server/releases/latest/download/libdump978.so ; sudo chmod 755 libdump978.so
cd /boot 
sudo wget -N https://github.com/egite/Stratux-GDL90-to-SBS-Converter-for-Virtual-Radar-Server/releases/latest/download/stratux.conf

#redirect gen_gdl90 log output to a black hole, we don't need it
sudo ln -s /dev/null /var/log/stratux.log

#get my GDL90 to SBS converter and monitoring scripts
cd ~pi ; wget -N https://github.com/egite/Stratux-GDL90-to-SBS-Converter-for-Virtual-Radar-Server/releases/latest/download/GDL90_to_SBS.py
wget -N https://github.com/egite/Stratux-GDL90-to-SBS-Converter-for-Virtual-Radar-Server/releases/latest/download/GDL90_to_SBS-check.sh ; chmod 755 GDL90_to_SBS-check.sh
wget -N https://github.com/egite/Stratux-GDL90-to-SBS-Converter-for-Virtual-Radar-Server/releases/latest/download/UAT.sh ; chmod 755 UAT.sh

#add lines to crontab to start the monitoring scripts for my converter and the dump978 checker
line="@reboot /home/pi/UAT.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
line="@reboot sleep 60 ; /home/pi/GDL90_to_SBS-check.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -
line="* * * * * /home/pi/dump978-check.sh"
(crontab -u $(whoami) -l; echo "$line" ) | crontab -u $(whoami) -

echo
echo "UAT traffic information in SBS format will be available on port 33333."
echo "Create a receiver in VRS and point it to the IP address of this pi (which seems to be `hostname -I | sed 's: ::g'`) at port 33333."
echo "Then reboot your pi.  It will take a least a minute for the data on port 33333 to become available once the pi is rebooted."
echo

