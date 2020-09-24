#!/bin/bash

# load config file keys into environment variables
while read line; do
  if [[ "$line" =~ ^[^#]*= ]]; then
    key=`echo $line | sed 's/=.*//g'`
    value=`echo $line | sed 's/^.*.=//g'`
    export "$key"="$value"
    ((i++))
  fi
done < archconfig

timedatectl set-ntp true

# case for partition layout
# single partition config
sgdisk -og $DEVICE
export ENDSECTOR="$(sgdisk -E $DEVICE)"
sgdisk -n 1:2048:400MB $DEVICE
sgdisk -n 2:401MB:$ENDSECTOR $DEVICE
mkfs.fat -F 32 "$DEVICE"1
mkfs.ext4 "$DEVICE"2
mount "$DEVICE"2 /mnt

# home partition config (home folder in a separate partition)

# btrfs partition config (uses the btrfs filesystem with subvolumes in ubuntu layout @ and @home)


# sort mirrors by speed in country
if [ $SORTMIRRORS == "true" ]; then
 reflector --country $MIRRORCOUNTRY --protocol https --sort rate --save /etc/pacman.d/mirrorlist
 echo "Mirror set to $MIRRORCOUNTRY"
fi

# case for lts vs mainline kernel
pacstrap /mnt base base-devel linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab
cp chroot.sh /mnt/chroot.sh
cp archconfig /mnt/archconfig
arch-chroot /mnt /chroot.sh
