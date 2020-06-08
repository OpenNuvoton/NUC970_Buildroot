#!/bin/sh
ifconfig wlan0 up
wpa_supplicant -D nl80211 -i wlan0 -c/etc/wpa_supplicant.conf -B
udhcpc -i wlan0
ifconfig
