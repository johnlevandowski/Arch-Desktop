#!/bin/bash

HOSTNAME="john-arch"
USERNAME="john"

ln -sf /usr/share/zoneinfo/US/Mountain /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf
echo $HOSTNAME >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 "$HOSTNAME".localdomain "$HOSTNAME >> /etc/hosts
echo root:password | chpasswd

pacman -S efibootmgr networkmanager network-manager-applet intel-ucode linux-headers linux-lts-headers base-devel

ROOTPARTUUID=$(lsblk -no PARTUUID /dev/disk/by-label/INSTALL)

bootctl install

echo "default arch.conf" > /boot/loader/loader.conf
echo "timeout 2" >> /boot/loader/loader.conf

echo "title   Arch Linux" > /boot/loader/entries/arch.conf
echo "linux   /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd  /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options root=PARTUUID=${ROOTPARTUUID} rw" >> /boot/loader/entries/arch.conf

echo "title   Arch Linux - LTS" > /boot/loader/entries/arch-lts.conf
echo "linux   /vmlinuz-linux-lts" >> /boot/loader/entries/arch-lts.conf
echo "initrd  /intel-ucode.img" >> /boot/loader/entries/arch-lts.conf
echo "initrd  /initramfs-linux-lts.img" >> /boot/loader/entries/arch-lts.conf
echo "options root=PARTUUID=${ROOTPARTUUID} rw" >> /boot/loader/entries/arch-lts.conf

e2label /dev/disk/by-label/INSTALL ROOT

systemctl enable NetworkManager
systemctl enable fstrim.timer

useradd -m $USERNAME
echo $USERNAME:password | chpasswd
echo $USERNAME" ALL=(ALL) ALL" >> /etc/sudoers.d/$USERNAME

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
