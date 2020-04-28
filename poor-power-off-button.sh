#!/bin/sh

# shutdown raspberry pi safely when connecting the correct
# poor-power-off-button USB

# lsbusb:
# Bus 001 Device 006: ID 0950:2544 Kingston DataTraveler 2.0 Stick (2GB)
# 0930: vendor ID
# 6544: product ID

# add rule:
# cat /etc/udev/rules.d/99-poor-power-off-button.rules
# ATTRS{idVendor}=="0950", ATTRS{idProduct}=="2544", ACTION=="add", RUN+="/root/poor-power-off-button.sh"

# to see all environment variables available:
# LOGFILE="/tmp/poor-power-off-button.log"
# env >> "$LOGFILE"

logger -t "$(basename "$0")" "Poor power off USB detected. Shutting down..."
/sbin/shutdown -h now
