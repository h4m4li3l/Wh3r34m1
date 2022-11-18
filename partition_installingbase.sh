#This is not intended to be an script
#As i see it, the fun of Arch is to have the system on your way
#Scripts would make it on my way. 
#And my actual knowledge doens't allow me to create an script of that size btw.
#There 's a loooot more of tweaks that still need to be doing
#It's not very clever to let people know some points here, as cipher, filesystems, but whatever, 
#i'm not very clever

#usaremos trim periodico, no continuo (fs.trimmer)
#usaremos las opciones de mount default. Todavia tengo que estudiar mount
#si alguien quiere colaborar y agregar opciones mejores para el mount de ext4 en SSD y Nvme

'your_choice'

loadkeys 'es'
#partition disk as prefered"

fdisk /dev/'vda'
  g #Create new GPT table
  n #Create new partition 1: +300M t 1 // partition 2: +DESIRED_SIZE t 43 
  w # write and quit

#$EFIPART PARTITION type 1
#$GRUB PARTITION only needed case in legacy (will not cover it) or to boot from encrypted
Trying to fix the boot from encrypted partition
#$SYSPART PARTITION type 43 (LVM)

mkfs.fat -F32 /dev/'vda1'
#mkfs.ext4 /dev/$GRUB

#---------------------------LUKS+encryption+LVM+EXT4---------------------------------

cryptsetup --cipher aes-xts-plain64 --hash sha512 --use-random --verify-passphrase luksFormat /dev/'vda2'

cryptsetup luksOpen /dev/'vda2' 'root'

pvcreate --dataalignment 1m /dev/mapper/'root'
    #pvdisplay

vgcreate 'volgroup' /dev/mapper/'root'
    #vgdisplay

lvcreate -L '16G' 'volgroup' -n 'lvroot'
lvcreate -L '32G' 'volgroup' -n 'lvhome'
    #lvdisplay

mkfs.ext4 /dev/'volgroup'/'lvroot' (btrfs, ext4,...)

mkfs.ext4 /dev/'volgroup'/'lvhome' (btrfs, ext4,...)

#-------------------------Case use ext4 as fs----------------------------------------
# Mounting root by UUID:
lvrootuuid=$(blkid -s UUID -o value /dev/mapper/'volgroup-lvroot')
mount -U $lvrootuuid /mnt

OR

#Mounting by disk ID
mount /dev/'volgroup'/'lvroot' /mnt


#Mounting home by UUID
mkdir /mnt/home

lvhomeuuid=$(blkid -s UUID -o value /dev/mapper/'volgrouplvhome')
mount -U $lvhomeuuid /mnt/home

OR

#Mounting by disk ID
mount /dev/'volgroup'/'lvhome' /mnt/home

mkdir /mnt/boot/EFI
mount /dev/'vda1' /mnt/boot/EFI

mkdir /mnt/etc
genfstab -U /mnt >> /mnt/etc/fstab

#-----------------------Case use btrfs as fs (will not cover it)---------------------
#cd /mnt
#mkdir /mnt/home
#btrfs subvolume create @
#cd & umount /mnt
#mount /dev/$VOLGROUPANME/$LVHOME /mnt/home
#cd /mnt/home
#btrfs subvolume create @home
#cd & umount /mnt/home
#mount -o noatime,space_cache=v2,ssd,compress=zstd,discard=async,subvol=@ /dev/$VOLGROUPNAME1/LVROOT /mnt
#mkdir /mnt/home
#mount -o noatime,space_cache=v2,ssd,compress=zstd,discard=async,subvol=@home /dev/$VOLGROUPNAME1/LVHOME /mnt/home
#mkdir /mnt/boot
#mkfs.ext4 /dev/vda2
#mount /dev/vda2 /mnt/boot
#mkdir /mnt/etc
#genfstab -U /mnt >> /mnt/etc/fstab

#--------------------------Actualizing Package Manager--------------------------------
Make sure you have internet

reflector --verbose --latest 10 --age 12 --protocol https -c $COUNTRY -c $COUNTRYn --save /etc/pacman.d/mirrorlist
OR
reflector --verbose --latest 10 --age 12 --protocol https --country $COUNTRY >> /etc/pacman.d/mirrorlist

pacman -Syyy
pacman -S archlinux-keyring # por si acaso para actualizar las claves de los devs

#edit /etc/pacman.conf uncomment in #Misc -> Colors and Parallel downloads = 5

#--------------------------Installing base system-------------------------------------

#pacstrap -i /mnt base linux-firmware linux-headers linux git vim btrfs-progs $UCODE
pacstrap -i /mnt base linux-firmware linux-hardened-headers linux-hardened git vim $UCODE
#?KERNEL = Study the lts kernel and compare with the hardened, and others, even more when preparing gentoo install, hardened nomultilib selinux, etc...
#?initramfs = mkinitcpio, booster, dracut

#base install packages:
#acl archlinux-keyring argon2 attr audit bassh binutils brotli bzip2 ca-certificates 
#ca-certificates-mozilla ca-certificates-utils coreutils cryptsetup curl db dbus device-mapper diffutils e2fsprogs expat file filessytem findutils gawk gcc-libs gdbm gettext glib2 glibc gmp gnupg gnutls gpgme gpme gpm grep gzip hwdata iana-etc icu iproute iptables iputils json-c kbbd keyutils kmod krb less libarchive libassuan libbpf libcap libacp-ng libelf libevent libffi libgcrypt libgpg-error libidn libska libldap libmnl libnetfilter_conntrack libnfnetlink libnftnl libnghttp2 libnl libnsl libp11-kit libpcap libps libsasl libseccomp libsecret libssh libsysprof-capture libtasn libtirp libunistring libverto libxcrypt libxm licenses linux-api-headers linux-firmware-whence lz4 lzo mkinitcpio mkinitcpio-busybox mpfr ncurses nettle npth openssl p11-kit pacman pacman-mirrorlist pahole pam pambase pciutils pcre pcre2 perl perl-error perl-mailtools perl-timedate pinentry popt procps-ng psmisc python readline sed shadow sqlite systemd systemd-libs systemd-sysvcompat tar tpm2-tss tzdata util-llinux util-linux-libs vim-runtime xz zlib zstd amd-ucode basee btrfs-progs git linux linux-firmware linux-headers vim

#-------------------------Chroot to the new root--------------------------------------

arch-chroot /mnt


#!/bin/bash
#KEYMAP="KEYMAP=es"
#HOSTNAME=hostname?
#USER=user?

ln -sf /usr/share/zoneinfo/Continent?/Ciudad? /etc/localtime
timedatectl set-timezone
hwclock --systohc
vim /etc/locale.gen 
locale-gen
OR echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
  locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo 'es' >> /etc/vconsole.conf
echo 'hostname'  >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 'hostname'.localdomain 'hostname'" >> /etc/hosts

#-----------------------Other Basic Utilities Packages----------------------------------
# You can remove the tlp package if you are installing on a desktop or vm
pacman -Syyy
pacman -S archlinux-keyring
#edit /etc/pacman.conf uncomment in #Misc -> Colors and Parallel downloads = 5

pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools 
dosfstools base-devel avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils 
dnsutils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion 
openssh rsync reflector acpi acpi_call firewalld sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

#------------------------Setting up bootloader-------------------------------------------
EDITOR=vim visudo #uncomment to allow members of the group wheel ...

vim /etc/mkinitcpio.conf #HOOKS... block 'encrypt lvm2' filesystems  .....
mkinitcpio -p linux-hardened

vim /etc/default/grub # loglevel=3 cryptdevice=/dev/'vda2':'volgroup'
#Uncomment GRUB_ENABLE_CRYPTODISK = y

grub-install --target=x86_64-efi --bootloader-id=GRUB --recheck
#change the directory to /boot/efi is you mounted the EFI partition at /boot/efi
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

useradd -m -g users -G wheel 'your user'
passwd
passwd 'your user'

exit
umount -a
reboot

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
