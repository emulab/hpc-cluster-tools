#!/bin/bash

# Check if the kernel is updated
uname -a | grep 3.13.11-ckt25
# Investigate the returned code
if [ $? -eq 0 ]; then
  echo "Kernel is already updated" 
else
  echo "Kernel needs to be updated"
  cd /tmp
  wget https://s3-us-west-2.amazonaws.com/dmdu-cloudlab/kernel-3.13.11-ckt25.tar.gz
  tar xzvf kernel-3.13.11-ckt25.tar.gz
  kver=3.13.11-ckt25
  cp vmlinuz-${kver} /boot
  cp config-${kver} /boot
  cp initrd.img-${kver} /boot
  cp uImage /boot
  cp uInitrd /boot
  mkdir /lib/modules/3.13.11-ckt25/
  wget https://s3-us-west-2.amazonaws.com/dmdu-cloudlab/lib_modules_3.13.11-ckt25.tar.gz
  tar xzvf lib_modules_3.13.11-ckt25.tar.gz -C /lib/modules/3.13.11-ckt25/
  echo "Everything is set for booting the updated kernel. Rebooting"
  reboot
fi

modprobe i2c-dev
apt-get update
apt-get install -y i2c-tools freeipmi
