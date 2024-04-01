---

# PetaLinux Cheat Sheet

This cheat sheet includes common commands used in PetaLinux projects.

## Installation

```bash
chmod 755 ./petalinux-v2022.2-final-installer.run
sudo chmod 755 ./petalinux-v2022.2-final-installer.run 
./petalinux-v2022.2-final-installer.run --dir ~/../petalinux/2022.2/
source ../../../../petalinux/2022.2/settings.sh
```

## Packaging

```bash
petalinux-package --boot --u-boot ./images/linux/u-boot.elf
petalinux-package --boot --fsbl zynqmp_fsbl.elf  --pmufw pmufw.elf --atf bl31.elf --u-boot u-boot.elf
```

## Configuration

```bash
petalinux-config --get-hw-description=/../zc102_demo_wrapper.xsa
```

## Building

```bash
petalinux-build -x package
petalinux-build -c kernel
```

## Cleaning

```bash
petalinux-build -x mrproper
```

## Root File System Configuration

```bash
petalinux-config -c rootfs
petalinux-config -c uboot
```

## Project Creation

```bash
petalinux-create -t project  -s ../xilinx-zcu102-v2022.2-10141622.bsp 
```

## Writing Root File System to SD Card

```bash
dd bs=8192 status=progress  if=~/../rootfs.ext4  of=/dev/sdc2
```

### Fix umount Errors

```bash
fsck /dev/sde2
```

### Minicom Example

```bash
minicom  -D /dev/ttyUSBX -b 115200
```

### Device Tree Decompilation into DTS

```bash
dtc -I dtb -O dts system.dtb -o /tmp/tmp.dts
```

### Bootgen.bif Example

```plaintext
the_ROM_image:
{
	[bootloader, destination_cpu=a53-0] zynqmp_fsbl.elf
	[pmufw_image] pmufw.elf
	[destination_device=pl] pre-built/linux/implementation/download.bit
	[destination_cpu=a53-0, exception_level=el-3, trustzone] bl31.elf
	[destination_cpu=a53-0, load=0x00100000] system.dtb
	[destination_cpu=a53-0, exception_level=el-2] u-boot.elf
}
```

### Debugging Kernel

```bash
petalinux-boot --jtag --u-boot --fpga --bitstream system.bit
```

### Boot Kernel in U-Boot

```plaintext
> pxe get
> pxe boot
```

### QSPI Flash Boot

Make sure the TFTP server is up and the images are located in `/srv/tfpboot` directory.

```bash
# Initialize SPI flash
sf probe 0 0 0

# Erase SPI flash (for a 128MiB flash size)
sf erase 0 0x8000000

# Write BOOT.BIN into Flash
tfpboot 0x80000 BOOT.BIN
sf write 0x80000 0x0 <0xfile_size>

# Write image.ub into Flash
tfpboot 0x80000 image.ub
sf write 0x80000 <0ximage_flash_address> <0xfile_size>

# Write boot.scr into Flash
tfpboot 0x80000 boot.scr
sf write 0x80000 <0xboot_scr_flash_address> <0xfile_size>

# Reset board in QSPI mode
```

### Example for u-boot.txt

```plaintext
# Set environment variables
setenv bootargs console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rw rootwait

# Load the image from QSPI flash into memory
sf probe 0; sf read ${loadaddr} 0x100000 0x800000

# Boot the image
bootm ${loadaddr}
```

### How to Create a boot.scr File from the boot.txt

```bash
mkimage -C none -A arm -T script -d boot.txt boot.scr
```

---

This Markdown format provides a clear, organized, and easy-to-read layout for your cheat sheet, ideal for quick reference.
