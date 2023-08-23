#!/bin/bash

#PetaLinux SD Card utils script
#original version by Roy Cohen (bspguy.com)

# Enable debug=1    -- enable debug messages
# Disable debbug=0  -- disable debug messages
debug=1;

#get OS pretty name
osPrettyName=`cat /etc/os-release | grep PRETTY_NAME | sed 's/.*="\(.*\)"/\1/'`;
osKernelVer=`uname -r`

echo "***************************************************************";
echo "PetaLinux Environment Setup Tool";
echo "Running on $osPrettyName ($osKernelVer)";
echo "***************************************************************";
#print the debug message header
if [ $debug -eq 1 ]; then echo "***DEBUG MODE ON!***"; fi; 
echo " "

PTLX_PROJ_ROOT=/../../
PTLX_IMAGES=${PTLX_PROJ_ROOT}/images/linux/
source ${PETALINUX}/settings.sh
cd ${PTLX_IMAGES}
petalinux-package --boot --force --format BIN --fsbl ./zynqmp_fsbl.elf  --fpga ./system.bit --u-boot ./u-boot.elf --pmufw ./pmufw.elf --atf ./bl31.elf 


if [ $debug -eq 1 ]; then 
    echo "***DEBUG MODE ON!***";
    echo "***PARTITION!***";
    echo "***FILE SYSTEM!***";
    echo "***MOUNT***";
    echo "***COPY***";
    echo "***UMOUNT***";
    echo "***EJECT***";
fi; 