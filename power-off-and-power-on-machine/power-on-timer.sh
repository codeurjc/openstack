#!/usr/bin/env bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   printf "This script must be run as root\n" 1>&2
   exit 1
fi

if [[ -z "$1" || "$1" = "help" ]]; then
   printf "You need define the date of power on"
   printf "\nExample mode of use:"
   printf "\n   power-on-timer.sh 'tomorrow 08:00'"
   printf "\n   power-on-timer.sh 'next Monday 08:00'"
   printf "\n   power-on-timer.sh '13072020 08:00'"
   printf "\n   power-on-timer.sh '+ 60 hours'"
   printf "\n"
   exit 1
fi

POWER_ON_DATE=$(date '+%s' -d "$1")
sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm" 
sh -c "echo ${POWER_ON_DATE} > /sys/class/rtc/rtc0/wakealarm"

SAVED_SCHEDULED=$(cat /sys/class/rtc/rtc0/wakealarm)

if [ "${POWER_ON_DATE}" != "${SAVED_SCHEDULED}" ]; then
    printf "Error when define scheduled power off, please try again\n"
else 
    printf "Power on scheduled for:"
    printf "\n  %s" "$(date -d "@${SAVED_SCHEDULED}")"
    printf "\n"
fi
