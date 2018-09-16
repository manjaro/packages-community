#!/bin/bash
# setup_chroot_environemnt.sh: to setup correct environment *within* the chroot

# setup locale
locale-gen en_US.UTF-8

# setup pacman
pacman -S haveged --noconfirm
haveged -w 1024
pacman-key --init
pacman-key --populate archlinux manjaro
pacman-mirrors -g -c Germany
pacman -Syy

# setup makepkg
echo 'Packager="Travis CI Builder"' >> /etc/makepkg.conf
echo "MAKEFLAGS=\"-j$(nproc)\"" >> /etc/makepkg.conf

# setup user
user=$1
useradd -s /bin/bash $user
echo "$user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$user
