#!/bin/sh

USERNAME=$1
HOSTNAME=$2

echo "
Welcome $USERNAME! To the

███████╗███████╗    ██████╗ ███████╗
██╔════╝╚══███╔╝   ██╔═══██╗██╔════╝
█████╗    ███╔╝    ██║   ██║███████╗
██╔══╝   ███╔╝     ██║   ██║╚════██║
███████╗███████╗██╗╚██████╔╝███████║
╚══════╝╚══════╝╚═╝ ╚═════╝ ╚══════╝        

installation helper. Relax, take a break and in a few minutes enjoy your new 
system! ;).
"

echo "Setting up $USERNAME at $HOSTNAME [Arch Linux installation]..."

echo "
###################################################
              TIME ZONE CONFIGURATION
###################################################
"
ln -sf /usr/share/zoneinfo/America/Fortaleza /etc/localtime

hwclock --systohc

echo "Done!"

echo "
###################################################
              LOCALE CONFIGURATION
###################################################
"
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
# echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen

locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Done!"

echo "
###################################################
             HOSTNAME CONFIGURATION
###################################################
"
echo "$HOSTNAME" > /etc/hostname

echo "127.0.0.1 localhost
::1 localhost
127.0.1.1 $HOSTNAME" >> /etc/hosts

hostnamectl

echo "Done!"

echo "
###################################################
        INSTALLING ADDITIONAL PACKAGES
###################################################
"

pacman -S --needed - < pkgs/pkglist.txt --noconfirm

# If AMD platform uncomment
# pacman -S amd-ucode

# If Intel platform uncomment
# pacman -S intel-ucode

echo "Done!"

echo "
###################################################
               CREATING YOUR USER
###################################################
"

useradd -m -g users -G wheel -s /bin/zsh $USERNAME

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

echo "
###################################################
          ENTER YOUR ROOT PASSWORD
###################################################
"

passwd

echo "
###################################################
            ENTER THE USER'S PASSWORD
###################################################
"

passwd $USERNAME

echo "Done!
"

echo "
###################################################
        INSTALLING and SETUP GRUB
###################################################
"

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

os-prober
grub-mkconfig -o /boot/grub/grub.cfg > grub_conf_log.txt

cat grub_conf_log.txt
sleep 3

echo "Done!
"

echo "
###################################################
        INSTALLING DESKTOP ENV - KDE plasma
###################################################
"
pacman -S --needed - < pkgs/de_pkglist.txt --noconfirm

echo "GRUB_THEME=\"/usr/share/grub/themes/breeze/theme.txt\"" >> /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

echo "Done!
"

echo "
###################################################
        ENABLE SERVICES
###################################################
"

systemctl enable NetworkManager
systemctl enable dhcpcd.service
systemctl enable sddm
systemctl enable systemd-timesyncd
systemctl enable bluetooth.service
systemctl enable fstrim.timer

echo "Done!
"

while true; do
    read -p "Do you want to exit chroot now to finish your EZ.OS installation? [Y/n] " yn
    case $yn in
        [Yy]* ) 
        echo "All done, bye!

  ██╗ 
██╗╚██╗
╚═╝ ██║
██╗ ██║
╚═╝██╔╝
   ╚═╝ 

Remember to reboot your machine!!"
        exit;; # clean up and reboot
        [Nn]* ) echo "All done, bye!

  ██╗ 
██╗╚██╗
╚═╝ ██║
██╗ ██║
╚═╝██╔╝
   ╚═╝ 

Remember to exit the chroot and reboot to complete the installation.
"
break;; # clean up 
        "" ) echo "All done, bye!

  ██╗ 
██╗╚██╗
╚═╝ ██║
██╗ ██║
╚═╝██╔╝
   ╚═╝ 

Remember to reboot your machine!!"
        exit;; # clean up and reboot
        * ) echo "Please answer yes or no.";;
    esac
done
