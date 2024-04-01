#!/bin/bash

#PetaLinux SD Card utils script
#original version by Roy Cohen (bspguy.com)
PTLX_PROJ_ROOT=/../../
PTLX_IMAGES=${PTLX_PROJ_ROOT}/images/linux/
source ${PETALINUX}/settings.sh
petalinux-create -t project  -s ../xilinx-zcu102-v2022.2-10141622.bsp 
