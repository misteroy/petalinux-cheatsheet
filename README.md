# petalinux-cheatsheet
Xilinx Petalinux commands cheatsheet daaaa :)



chmod 755 ./petalinux-v2022.2-final-installer.run 
sudo chmod 755 ./petalinux-v2022.2-final-installer.run 
./petalinux-v2022.2-final-installer.run --dir /home/misteroy/Projects/petalinux/2022.2/
petalinux-package --boot --u-boot ./images/linux/u-boot.elf
petalinux-build -x package
petalinux-build -c kernel 
bootgen read  BOOT.BIN 
petalinux-build -x mrproper
petalinux-config -c rootfs
petalinux-config -c uboot
petalinux-create -t project  -s ../xilinx-zcu102-v2022.2-10141622.bsp 
dd bs=8192 status=progress  if=~/../rootfs.ext4  of=/dev/sdc2
source ../../../../petalinux/2022.2/settings.sh