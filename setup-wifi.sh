#!/bin/bash

clear

if [[ $EUID -ne 0 ]]
then
  echo ""
  echo " This script can be used to share your Internet over Wi-Fi."
  echo ""
  echo "    Usage :"
  echo ""
  echo "     share without a password : (easier to connect Toon 8=) )"
  echo ""
  echo "       sudo bash $0"
  echo ""
  echo "     share with a password    : (at least 8 long and safer 8=) )"
  echo ""
  echo "       sudo bash $0 pwd"
  echo ""
  echo " The name of the Wi-Fi to connect to will be ToonRouter."
  echo ""
  exit 0
fi

Password=$1
if (( ${#Password} > 0 && ${#Password} < 8 ))
then
  echo ""
  echo " Password too short"
  echo ""
  exit 0
fi

nmcli connection delete ToonRouter > /dev/null 2>&1
if [ "$Password" == "" ] 
then
  echo ""
  nmcli connection add type wifi ifname wlan0 con-name ToonRouter autoconnect yes  ssid ToonRouter mode ap 802-11-wireless.mode ap ipv4.method shared
  echo ""
  echo "For the ease of things, there is no password on this."
else
  echo ""
  nmcli connection add type wifi ifname wlan0 con-name ToonRouter autoconnect yes  ssid ToonRouter mode ap 802-11-wireless.mode ap ipv4.method shared 802-11-wireless-security.key-mgmt wpa-psk ipv4.method shared 802-11-wireless-security.psk $1
  echo ""
  echo "For the ease of things, remember your password : $1"
fi
nmcli connection up ToonRouter
echo ""
echo "Now you are sharing the Internet on the Wi-Fi of this computer."
echo ""
echo "You should be able to connect your Toon to the Wi-Fi network named ToonRouter."
echo ""
