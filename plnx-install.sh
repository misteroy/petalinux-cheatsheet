#!/bin/bash
#original version by Roy Cohen (bspguy.com)
#
#-log <LOGFILE>	Specifies where the log file should be created. By default, it is petalinux_installation_log in your working directory.
#-d|--dir [INSTALL_DIR]	Specifies the directory where you want to install the tool kit. If not specified, the tool kit is installed in your working directory.
#-p|--platform <arch_name>	Specifies the architecture:
#aarch64: Sources for Zynq UltraScale+ MPSoC devices and Versal devices.
#arm: sources for Zynq devices.
#If -p not specified then by default it will install all the platforms
#MicroBlaze™ : sources for MicroBlaze devices


DOWNLOAD_INSTALLATION_DIR=/home/chuck-u-farley/Projects/zcu_102/
PTLX_INSTALLATION_DIR=/home/chuck-u-farley/Projects/zcu_102/peta_install/
PETA_PLATFROM="aarch64" # arm, aarch64, microblaze
LOGFILE=/home/chuck-u-farley/Projects/zcu_102/ptlx_install_log
PTLX_INSTALL_VERSION=v2022.2-10141622

chmod +x ./ptlx-env-setup.sh
./ptlx-env-setup.sh

#chmod +x ${DOWNLOAD_INSTALLATION_DIR}/petalinux-${PTLX_INSTALL_VERSION}-installer.run
#./petalinux-${PTLX_INSTALL_VERSION}-installer.run --log ${LOGFILE} --dir ${PTLX_INSTALLATION_DIR}

$ mkdir -p /home/<user>/petalinux/<petalinux-version>
$ ./petalinux-v<petalinux-version>-final-installer.run --dir /home/<user>/petalinux/<petalinux-version>

#Important: Once installed, you cannot move or copy the installed directory. In the above example, you cannot move or copy /home/<user>/petalinux/<petalinux-version> because the full path is stored in the Yocto e-SDK environment file.
$ ./petalinux-PETALINUX_INSTALL_VERSION-installer.run --dir <INSTALL_DIR>

$ ./petalinux-v<petalinux-version>-final-installer.run --dir <INSTALL_DIR> --platform "arm"
$ ./petalinux-v<petalinux-version>-final-installer.run --dir <INSTALL_DIR> --platform "aarch64"
$ ./petalinux-v<petalinux-version>-final-installer.run --dir <INSTALL_DIR> --platform "microblaze"