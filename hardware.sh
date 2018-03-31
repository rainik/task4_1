#!/bin/bash

MotherboardMN=""
MotherboardPN=""

if [ -z "$(dmidecode -s baseboard-product-name | sed 's/^[ \t]*//;s/[ \t]*$//')" ]
  then
     MotherboardPN='Unknown'
  else
     MotherboardPN="$(dmidecode -s baseboard-product-name | sed 's/^[ \t]*//;s/[ \t]*$//')"
fi

if [ -z "$(dmidecode -s baseboard-manufacturer | sed 's/^[ \t]*//;s/[ \t]*$//')" ]
  then
     MotherboardMN='Unknown'
  else
     MotherboardMN="$(dmidecode -s baseboard-manufacturer | sed 's/^[ \t]*//;s/[ \t]*$//')"
fi

cat <<EOF > ./hardware.out
--- Hardware ---
CPU: $(lshw -c cpu | grep product | sed -n '1p'| awk -F ':' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
RAM: $(lshw -c memory | sed -n '/*-memory/, $p' | sed -n '4p' | awk -F ':' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
Motherboard: $MotherboardMN / $MotherboardPN
System Serial Number: $(dmidecode -s system-serial-number | sed 's/^[ \t]*//;s/[ \t]*$//')
--- System ---
OS distribution: $(cat /etc/issue.net | sed 's/^[ \t]*//;s/[ \t]*$//')
Kernel version: $(uname -a | awk '{print $3}' | sed 's/^[ \t]*//;s/[ \t]*$//')
Installation date: $(ls -alct / | tail -1 | awk '{print $6, $7, $8}' | sed 's/^[ \t]*//;s/[ \t]*$//')
Hostname: $(hostname -f | sed 's/^[ \t]*//;s/[ \t]*$//')
Uptime: $(uptime -p | awk -F ',' '{print $1,$2}' | sed 's/^up//'| sed 's/^[ \t]*//;s/[ \t]*$//')
Processes running: $(ps -ax | wc -l)
Users logged in: $(who | wc -l)
--- Network ---
$(ip -br a | awk '{if ($3=="") print $1,"-"; else print $1,substr($0, index($0,$3))}' | sed 's/ /, /g;s/,/:/' | rev | awk '{if ($1=="-") print $1,substr($0,index($0,2)); else print substr($0, index($0,$2))}' | rev | sed 's/.$//')
EOF
