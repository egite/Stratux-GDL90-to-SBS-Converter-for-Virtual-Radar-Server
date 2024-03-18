# Stratux GDL90 to SBS Converter for Virtual Radar Server

Getting UAT data into Virtual Radar Server continues to be a challenge.  The tools available can be difficult to install and can provide inconsistent and unreliable data to VRS.  

Stratux is a well-tested platform for receiving and decoding UAT data, however its output format is GDL90 which is suitable for avionics, not VRS.
To use a Stratux or use its tools to feed VRS, a format converter from GDL90 to SBS is needed.  The python script GDL90_to_SBS.py does just that, taking the GDL90 data and making it available on TCP port 33333 in SBS format for VRS.  No changes to the Stratux GDL90 output are made.  The script can work on a pi running Stratux or a pi without Stratux.  Choose your option below.

<ins>**Running the python program on a Stratux**</ins>

If you are running a local Stratux box, you can simply download the python script and my checker script to the Stratux and create a new receiver on your VRS to point to port 33333 to get all traffic information from Stratux.  Include in the Stratux's crontab to run the the checker script '[GDL90_to_SBS-check.sh](https://github.com/egite/Stratux-GDL90-to-SBS-Converter-for-Virtual-Radar-Server/releases/download/v1.0/GDL90_to_SBS.py)' at reboot with '@reboot sleep 60 ; /home/pi/GDL90_to_SBS-check.sh'.  Make sure developer mode and persistent logging are enabled when you install the program and modify the crontab.  You can disable those after installation.  
If you also have a 1090 dongle connected to your Stratux and you enable the "Show Traffic Source in Callsign" option in Stratux's settings, my python program will filter out all non-ADS-B traffic and only pass along UAT traffic on port 33333.  You can also point your VRS to Stratux's port 30003 to have an ADS-B-only feed, though that's only useful if you want to have separate UAT and ADS-B feeds into your VRS since the python script's feed on port 33333 will have both UAT and ADS-B traffic (unless you enable "Show Traffic Source in Callsign" as explained previously).

<ins>**Running the python program without Stratux**</ins>

If you prefer not to run Stratux to have UAT data fed into your VRS, you can install the necessary programs on a raspberry pi without having Stratux.  You just need three files from Stratux along with my python program and then install dump978-fa.  Running script 'UAT-data-for-VRS.sh' will do that.  You will of course need an SDR dongle for 978 MHz UAT reception plugged in to the pi and you need to know its serial number. 

After running my installion script, edit the configuration in /etc/default/dump978-fa appropriate to your setup (specifically dongle serial number and RECEIVER_LAT=xx.xxx and RECEIVER_LON=-xx.xxx appropriate to your location).  Then creater a new receiver in VRS and point it to your pi's port 33333 to get a solid and stable UAT feed into your VRS.

Installation of dump1090-fa (sudo apt install dump1090-fa) is not included in my script since it isn't necessary. However, running dump1090-fa with or without a 1090 MHz SDR dongle allows you to view the local SkyAware map.  If you decide to install dump1090-fa without an associated dongle, be sure to specific "RECEIVER=none" in /etc/default/dump1090-fa.  If you install it without a dongle, setup the device configuration as appropriate to your setup.  In either case include the lines RECEIVER_LAT=xx.xxx and RECEIVER_LON=-xx.xxx appropriate to your location in /etc/default/dump1090-fa.
