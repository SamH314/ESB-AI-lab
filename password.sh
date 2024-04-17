#!/bin/bash
sudo mkdir /media/usb-drive
sudo mount /dev/sda1 /media/usb-drive/ 
cd /media/usb-drive/
ssid=$(head -n 1 password.txt)
psk=$(head -n 2 password.txt | tail -n 1)

echo "network = {ssid=\"$ssid\" psk=\"psk\"} " >> /etc/wpa_supplicant/wpa_supplicant.conf

sudo umount /dev/sda1
