svn checkout svn://svn.openwrt.org/openwrt/branches/backfire
cd backfire && ./scripts/feeds update && ./scripts/feeds install -a
make V=s defconfig && make menuconfig
make V=s
make kernel_menuconfig
make V=s
make clean && make V=s

Prepare USB Bootable System

    Download sources:
        svn checkout svn://svn.openwrt.org/openwrt/branches/backfire

    Change directory to bildroot, then update & install feeds:
        cd backfire && ./scripts/feeds update && ./scripts/feeds install -a

    Create defconfig and enter MenuConfig:
        make V=s defconfig && make menuconfig

        Select the following:
            Target System → Atheros AR71xx/AR7240/AR913x
            Target Profile → TP-LINK TL-WR741ND v1
            Target Images → ramdisk → Compression → lzma
            Target Images → tar.gz

            Kernel modules → Filesystems →
                kmod-fs-ext2
                kmod-fs-ext3

            Kernel modules → USB Support → kmod-usb-core
                kmod-usb-ohci
                kmod-usb-storage

            Utilities → kexec tools → Configuration → (mips) Target name for kexec kernel

        Exit from menu and save configuration

    make V=s

    Modify:
        ./build_dir/linux-ar71xx/linux-2.6.32.27/arch/mips/kernel/machine_kexec.c
            Change Line 55 to: kexec_start_address = (unsigned long) phys_to_virt(image→start);

        ./build_dir/toolchain-mips_r2_gcc-4.3.3+cs_uClibc-0.9.30.1/linux-2.6.32.27/arch/mips/kernel/machine_kexec.c
            Change Line 55 to: kexec_start_address = (unsigned long) phys_to_virt(image→start);

        For USB support:
            ./target/linux/ar71xx/files/arch/mips/ar71xx/Kconfig
                Add new line 176 (under config AR71XX_MACH_TL_WR741ND): select AR71XX_DEV_USB

            ./target/linux/ar71xx/files/arch/mips/ar71xx/mach-tl-wr741nd.c
                Add Line 22 (under includes): #include “dev-usb.h”
                Add line 102 (under static void __init tl_wr741nd_setup(void)): ar71xx_add_device_usb();

    make kernel_menuconfig

        Select the following:
            Kernel type → Kexec system call

            General setup → Support initial ramdisks compressed using LZMA
                Built-in initramfs compression mode → LZMA

            Device Drivers → SCSI device support → M SCSI device support
                M SCSI disk support
                Probe all LUNs on each SCSI device

            Device Drivers → USB support → M Support for Host-side USB
                M OHCI HCD support → USB OHCI support for Atheros AR71xx
                    M USB Mass Storage support
                    USB announce new devices

            Kernel hacking → Default kernel command string → rootfstype=ext2 noinitrd console=ttyS0,115200 board=TL-WR741ND

    Modify: ./package/base-files/files/etc/preinit
        Below . /etc/diag.sh, add line: rootfs=/dev/sda1

        Optionally you can modify: ./target/linux/generic-2.6/base-files/init
            Change line 50 to: mount $rootfs /mnt -o noatime
                Blocks wear out faster if written to every time a file is accessed

    make clean && make V=s

    Repeat Step 5
        Clean operation creates issues, however it's necessary for the USB patch to work

    make V=s

    Partition external storage, then format first partition as ext2
    Extract contents of ./bin/ar71xx/openwrt-ar71xx-rootfs.tar.gz to root of file system
    Copy ./bin/ar71xx/openwrt-ar71xx-vmlinux-initramfs.elf to root of file system




kexec -ld kernel7l.img
kexec -d -l /overlay/vmllinux.elf
file vmlinux.elf 
# kexec -l --append="console=ttyS0,115200 rootfstype=squashfs" /tmp/vmlinux.elf 


