#!/bin/bash
sleep 30
while true ; do
  socat -u tcp4-connect:127.0.0.1:30978,forever,interval=5 STDOUT | sudo /home/pi/gen_gdl90 -uatin -logtostderr >/dev/null 2>/dev/null
  echo "gen_gdl90 ended prematurely at `date "+%d-%b-%y %H:%M:%S"`." >> /home/pi/gen_gdl90_failures.txt
  sleep 1
done
