sudo systemctl status dump978-fa | grep "(running)" > /dev/null 2>/dev/null
if [ $? != 0 ] ; then
  echo "dump978-fa is down."
  echo  "`date "+%d-%b-%y %H:%M:%S"`:  dump978-fa is down." >> /home/pi/dump978-fa_failures.txt
  actualsize=$(wc -c < "/home/pi/dump978-fa_failures.txt")
  if [ $actualsize -ge 500 ] ; then
    echo > /home/pi/dump978-fa_failures.txt
    echo  "`date "+%d-%b-%y %H:%M:%S"`:  dump978-fa is down too many times.  Rebooting." >> /home/pi/dump978-fa_reboots.txt
    sleep 1
    sudo reboot
  fi
  sleep 10
  sudo systemctl restart dump978-fa
else
  echo "dump978-fa is up."
fi


