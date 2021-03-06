#!/bin/bash

# load config file keys into environment variables in chroot
while read line; do
  if [[ "$line" =~ ^[^#]*= ]]; then
    key=`echo $line | sed 's/=.*//g'`
    value=`echo $line | sed 's/^.*.=//g'`
    export "$key"="$value"
    ((i++))
  fi
done < archconfig

ln -sf /usr/share/zoneinfo/"$TZ" /etc/localtime
hwclock --systohc
# export REGEX="'"
# export REGEX+="s/#$LOCALE/$LOCALE/g"
# export REGEX+="'"
# sed -i $REGEX /etc/locale.gen
# sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
# TODO: uncomment solution for user-friendly experience
echo $LOCALE >> /etc/locale.gen
locale-gen
#TODO: are further settings actually useful in modern DEs?
echo "LANG=$LANGUAGE" > /etc/locale.conf
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
echo $HOSTNAME > /etc/hostname
if [ $CI == 'true' ]; then
 (echo 'start123'; echo 'start123') | passwd
else
 passwd
fi
# TODO: add machine / service user creation
useradd -g wheel $ADMINUSER
if [ $CI == 'true' ]; then
 (echo 'start123'; echo 'start123') | passwd $ADMINUSER
else
 passwd $ADMINUSER
fi
mkdir /home/$ADMINUSER
chown -R dev /home/$ADMINUSER
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
pacman --noconfirm -S dialog xorg xorg-xinit xorg-xauth xterm grub
yes | pacman -S efibootmgr
mkdir /efi
mount "$DEVICE"1 /efi
grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=ARCH
grub-mkconfig -o /boot/grub/grub.cfg

# case for various desktop environments will go here
pacman --noconfirm -S gnome
systemctl enable gdm
systemctl enable NetworkManager.service
gsettings set org.gnome.system.locale region "en_US.UTF-8"

# install packagefile contents (TODO: skip software already installed earlier in installation)
if [ $PACKAGEFILE -e ]; then
pacman -S `cat packagefile | sed -z 's/\n/ /g'` >> /dev/null
else
echo "No packagefile present. Finishing installation"
fi
exit
