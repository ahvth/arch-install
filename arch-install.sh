#!/bin/bash

timedatectl set-ntp true
mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mount /dev/sda2 /mnt
reflector --country Hungary --protocol https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
hwclock --systohc
sed 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen > /etc/locale.gen
echo "KEYMAP=us" > /etc/vconsole.conf
echo arch-install > /etc/hostname
passwd
useradd -g wheel dev
passwd dev
mkdir /home/dev
chown -R dev /home/dev
sed 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers > /etc/sudoers
yes | pacman -S dialog xorg xorg-xinit xorg-xauth xterm
yes | pacman -S efibootmgr
mkdir /efi
mount /dev/sda1 /efi
grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg
yes | pacman -S gnome
systemctl enable gdm
systemctl enable NetworkManager.service
exit
echo "Installation successful. Reboot now to use your system."
