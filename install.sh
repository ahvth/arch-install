#!/bin/bash

timedatectl set-ntp true
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
reflector --country Hungary --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
cp chroot.sh /mnt/chroot.sh
arch-chroot /mnt /chroot.sh
