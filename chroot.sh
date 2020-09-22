#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "KEYMAP=us" > /etc/vconsole.conf
echo arch-install > /etc/hostname
passwd
useradd -g wheel dev
passwd dev
mkdir /home/dev
chown -R dev /home/dev
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
pacman --noconfirm -S dialog xorg xorg-xinit xorg-xauth xterm grub
yes | pacman -S efibootmgr
mkdir /efi
mount /dev/sda1 /efi
grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg
pacman --noconfirm -S gnome
systemctl enable gdm
systemctl enable NetworkManager.service
exit
