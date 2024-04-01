#!/bin/bash
/*
 *              plnx scripts                                  
 *                                                                            
 * Petalinux script for deploying petalinux images                           
 * into an SD card.
 * Enable debug=1    -- enable debug messages
 * Disable debbug=0  -- disable debug messages
 *                                 
 * Change History:
 * 23/11/2021 - Roy Cohen: New NXP LSDK shell scripts
 * 24/08/2023 - Roy Cohen: Ported for Xilinx PetaLinux
 */

debug=1;

#get OS pretty name
osPrettyName=`cat /etc/os-release | grep PRETTY_NAME | sed 's/.*="\(.*\)"/\1/'`;
osKernelVer=`uname -r`

# Am i groot?
echo -n "NOTE: Check for superuser..."
#get the actual user
if [ $SUDO_USER ]; then actualUser=$SUDO_USER; else actualUser=`whoami`; fi
#get the effective user
currentUser=`whoami`
if [ $currentUser != "root" ]; then echo -e "FAILED!\nNOTE: Please re-run this script as sudo"; exit 1; else echo "SUCCESS! (from "$actualUser")"; fi;

echo "***************************************************************";
echo "PetaLinux deply sd-card tool";
echo "Running on $osPrettyName ($osKernelVer)";
echo "***************************************************************";
#print the debug message header
if [ $debug -eq 1 ]; then echo "***DEBUG MODE ON!***"; fi; 

help()
{
   # Display Help   
   echo
   echo "Syntax: ptlx-sd-card-utils [-h|p|d|f|m]"
   echo "options:"   
   echo "h     Print this help message."
   echo "p     Partition sd card."
   echo "d     Deploy images to SD Card."
   echo "f     Create filesystems."
   echo "m     mount filesystems."
   echo
}

################################################################################
# format sd card to /boot and /rootfs partitions                                                                       
################################################################################
partition_sdcard()
{
  echo "Partitioning sdcard..."
  TGTDEV=/dev/sdc
  # to create the partitions programatically (rather than manually)
  # we're going to simulate the manual input to fdisk
  # The sed script strips off all the comments so that we can 
  # document what we're doing in-line with the actual commands
  # Note that a blank line (commented as "defualt" will send a empty
  # line terminated with a newline to take the fdisk default.
  sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
    o # clear the in memory partition table
    n # new partition
    p # primary partition
    1 # partition number 1
      # default - start at beginning of disk 
    +1000M # 1000 MB boot parttion
    n # new partition
    p # primary partition
    2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
    p # print the in-memory partition table
    w # write the partition table
    q # and we're done
EOF

}

deploy_sdcard()
{
  PTLX_PROJ_ROOT=/../../
  PTLX_IMAGES=${PTLX_PROJ_ROOT}/images/linux/
  source ${PETALINUX}/settings.sh
  cd ${PTLX_IMAGES}
  petalinux-package --boot --force --format BIN --fsbl ./zynqmp_fsbl.elf  --fpga ./system.bit --u-boot ./u-boot.elf --pmufw ./pmufw.elf --atf ./bl31.elf 
}

create_fs()
{
  echo "Creating filesystems..."
  mkfs.vfat /dev/sdc1
  mkfs.ext4 /dev/sdc2
}

mount_fs()
{
  mkdir -pv /mnt/sdcard
  mkdir -pv /mnt/sdcard/boot
  mkdir -pv /mnt/sdcard/rootfs

  mount /dev/sdc1 /mnt/sdcard/boot
  mount /dev/sdc2 /mnt/sdcard/rootfs
}

################################################################################
# Process the input options.                                                   #
################################################################################
# Get the options
while getopts ":hpdfm" option; do
   case $option in
      h) 
        help
        exit;;
      p)
        partition_sdcard
        exit;;
      d) 
        deploy_sdcard
        exit;;
      f) 
        create_fs
        exit;;
      m) 
        mount_fs
        exit;;
     \?) # incorrect option
        echo "Error: Invalid option"
        exit;;
   esac
done

echo "All Is Good!!!"


#if [ $debug -eq 1 ]; then 
#    echo "***DEBUG MODE ON!***";
#    echo "***PARTITION!***";
#    echo "***FILE SYSTEM!***";
#    echo "***MOUNT***";
#    echo "***COPY***";
#    echo "***UMOUNT***";
#    echo "***EJECT***";
#fi; 



