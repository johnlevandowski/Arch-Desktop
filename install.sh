#!/bin/bash

reflector --country US --age 6 --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base linux linux-lts linux-firmware nano git
genfstab -U /mnt >> /mnt/etc/fstab
sed -i 's/relatime/noatime/' /mnt/etc/fstab
mv /root/arch.johnlevandowski.com /mnt/arch.johnlevandowski.com
