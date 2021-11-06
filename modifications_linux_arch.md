# My modifications - linux environment

## Current OS: Arch Linux 

Personal installation guide. Infos about packages used, and installation
steps/scripts.

## Info

Needed:
Usb stick with Arch linux ISO -> Available
[here](https://archlinux.org/download/), and stable internet connection.

The mains steps here are based on the
[Arch wiki](https://wiki.archlinux.org/title/installation_guide), and on this
[tutorial](https://www.youtube.com/watch?v=DPLnBPM4DhI). Special mentions to
DistroTube's
[YT channel](https://www.youtube.com/c/DistroTube), where
is possible to find some interesting tweaks and tutorials. Also, some KDE
customization insights can be found
[here](https://www.youtube.com/c/LinuxScoop/).

It is encouraged to keep the /home folder in a separated partition. The
```$USERNAME``` must be the same for reinstallations/repairs in order to keep the
user files at the ```/home``` folder.

This installation aim to an EFI system with dualboot alongside Win10.

### Gparted info: (Nov/2021)

| Partition   |      Size (Gb)  |  Used (Gb) |
|----------|:-------------:|:------:|
| /dev/nvme0n1p6: ```/```  | 97.66 | 29.38 |
| /dev/nvme0n1p5: ```/home``` |  122.07  | 79.41 |

- Size on disk considered for installation: ~220 Gb
(50 "```/```" | 170 "```/home```")

## Installation

- Hostname: Aorus-r5 (my desktop)
- Username: junior

### ⚠️ Manual steps

Archiso is by default configured to an en-US keyboard.
If installing using a pt-br keyboard use:

```sh
loadkeys br-abnt2
```

Update system clock:

```bash
timedatectl set-ntp true
```

Partitioning:

⚠️  Attention! This step will erase data. Make sure to have an backup of your files before doing it.

- check disk partitions using:

```bash
fdisk -l
```

- Manage the disk partitions using:

```bash
cfdisk /dev/DISK_TO_BE_PARTITIONED
```

the DISK_TO_BE_PARTITIONED is the disk partition named by the systems, i.e.,
sda, sdb, nvme0n1...

```cfdisk``` command is a user friendly alternative to ```fdisk```,
it has a cli interface that helps to manage creating partitions,
set type and size.

In my case:

```bash
cfdisk /dev/nvme0n1
```

- Select the partitions ```nvme0n1p5``` and ```nvme0n1p6```;

- Delete them and create new partitions with sizes 50/170;

- Set ```nvme0n1p5``` to Linux Filesystem as ```/home``` (170Gb) and
```nvme0n1p6``` to Linux filesystem as ```/``` (50Gb).

- Write and save changes, then exit ```cfdisk```.

Format partitions:

- Formatting ```/home``` and ```/```: ⚠️ only format ```/home``` if it is a new installation

```bash
mkfs.ext4 /dev/nvme0n1p5
mkfs.ext4 /dev/nvme0n1p6
```

Mounting partitions:

To proceed with the installation, is necessary to mount the partitions that
will be used during the process, named, the ```/home``` partition, the
```/```, and the EFI System partition with can be identified via
```fdisk -l```.

- Mount the root partition using the mounting point ```/mnt```

```bash
mount /dev/nvme0n1p6 /mnt
```

- Create the Home folder and the efi folder to use as mounting points:

```bash
mkdir /mnt/home /mnt/efi
```

- Mount the ```/home``` and ```/efi``` partitions:

```bash
mount /dev/nvme0n1p5 /mnt/home
mount /dev/nvme0n1p1 /mnt/efi
```

Install the base Arch linux distribution, the linux kernel, and a simple text
editor... who knows...

```bash
pacstrap /mnt base linux linux-headers nano ntfs-3g
```

or

```bash
pacstrap /mnt base linux-lts linux-lts-headers nano ntfs-3g
```

if you want to use the LTS kernel.

Generate the partition table:

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

Finally, change to the root user at the recently installed system:

```bash
arch-chroot /mnt
```

### Scripts

Now the installation process can be automated. The EZ OS script
```ezos.sh``` will take care of the installation of useful packages, networking
configuration, locals, user configuration, drivers, and desktop environment.

Note1: This setup considers an AMD with nvidia GPU platform by default.
If using other platform, i.e. Intel, comment and uncomment sections in
the ```ezos.sh``` file that will be highlighted in advance.

Note2: The desktop env is KDE plasma.

Note3: The time zone is set to Americas/Fortaleza. Change if necessary.

Note4: If the USB is ntfs you need to install the ntfs support package:

```bash
pacman -S ntfs-3g
```

- First mount the USB stick with the script in a mounting point, i.e:

```bash
mkdir /mnt/usbstick
mount USBDEVICE /mnt/usbstick
```

the USBDEVICE can be found using the ```lsblk``` command.

- Then, enter in the USB dir and copy the script and aux files to your /mnt folder

```bash
cd /mnt/usbstick
cp -vr ezos.sh pkgs /
cd ../..
```

- In the /mnt folder, ensure that the script has the executable permission:

```bash
chmod +x ezos.sh
```

- Usage:

```bash
sh ezos.sh USERNAME HOSTNAME
```

In my case:

```bash
sh ezos.sh junior Aorus-r5
```

USERNAME: your user name

HOSTNAME: your machine name

In the terminal will appear like that : USERNAME@HOSTNAME $

At the end, the script will exit arch-chroot. Reboot the machine in order to
finish the installation and you are ready to go :).

## After install Scripts

After reboot, the after install script ```ezos_aftersintall.sh``` will help
to install additional packages regarding workflow and general customization.

Use the script in your ```/home``` folder:

- Note: Download miniconda

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh

sh Miniconda3-py39_4.10.3-Linux-x86_64.sh
```

```bash
sh ezos_aftersintall.sh
```

## Manual configurations TODO

- Recovery backup files
- On demand documentation of additional steps...
- vscode setup
- ssh keys and git repo user configs
- KDE customization
- Other on demand...
