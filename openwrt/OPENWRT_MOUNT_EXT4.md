# Setup html index digger
find /mnt -maxdepth 1 -type f


# Install ext4 block-mounts
$ opkg install kmod-fs-ext4
# Installing kmod-fs-ext4 (5.10.176-1) to root...
# Downloading https://downloads.openwrt.org/releases/22.03.5/targets/bcm63xx/generic/packages/kmod-fs-ext4_5.10.176-1_mips_mips32.ipk
# Installing kmod-lib-crc16 (5.10.176-1) to root...
# Downloading https://downloads.openwrt.org/releases/22.03.5/targets/bcm63xx/generic/packages/kmod-lib-crc16_5.10.176-1_mips_mips32.ipk
# Configuring kmod-lib-crc16.
# Configuring kmod-fs-ext4.

$ opkg install kmod-usb-storage
Installing kmod-usb-storage (5.10.176-1) to root...
Downloading https://downloads.openwrt.org/releases/22.03.5/targets/bcm63xx/generic/packages/kmod-usb-storage_5.10.176-1_mips_mips32.ipk
Installing kmod-scsi-core (5.10.176-1) to root...
Downloading https://downloads.openwrt.org/releases/22.03.5/targets/bcm63xx/generic/packages/kmod-scsi-core_5.10.176-1_mips_mips32.ipk
Configuring kmod-scsi-core.
Configuring kmod-usb-storage.

$ opkg install block-mount
Installing block-mount (2022-06-02-93369be0-2) to root...
Downloading https://downloads.openwrt.org/releases/22.03.5/targets/bcm63xx/generic/packages/block-mount_2022-06-02-93369be0-2_mips_mips32.ipk
Configuring block-mount.

$ opkg install libblkid
$ opkg install openssh-sftp-server
Installing openssh-sftp-server (9.8p1-1) to root...
Downloading https://downloads.openwrt.org/releases/22.03.5/packages/mips_mips32/packages/openssh-sftp-server_9.8p1-1_mips_mips32.ipk
Configuring openssh-sftp-server.

# mke2fs -t ext4 -O ^has_journal,^uninit_bg,^ext_attr,^huge_file,^64bit [/dev/device or /path/to/file]
# NO: mount -t ext4 -o user,uid=1001,gid=1001,nodiratime,noacl,noatime,rw,exec /dev/sdb1 /mnt/

$ mount -t ext4 -o noatime,nodiratime,errors=remount-ro,rw,exec /dev/sda1 /mnt/
mkdir -p /mnt/cgi-bin
ln -s /mnt /www/disk

# mount --bind /mnt /www2/disk/
# lsusb -t
# block info | grep "/dev/sd"
# Automount the partition
# Generate a config entry for the fstab file:
block detect | uci import fstab
uci show fstab
uci set fstab.@mount[0].enabled='1'
uci set fstab.@mount[0].auto_swap='0'
uci commit fstab
service fstab boot

mkdir -p LUCI/opkg-tmp
mkdir -p LUCI/var/opkg-lists

LATEST RELEASES: https://openwrt.org/releases/22.03/notes-22.03.7
https://firmware-selector.openwrt.org/?version=22.03.7&target=bcm63xx%2Fgeneric&id=adb_pdg-a4001n-a-000-1a1-ax
sysupgrade https://downloads.openwrt.org/releases/22.03.7/targets/bcm63xx/generic/openwrt-22.03.7-bcm63xx-generic-adb
_pdg-a4001n-a-000-1a1-ax-squashfs-sysupgrade.bin
########## Done ext4

vim /etc/config/uhttpd-user 
/etc/rc.d/S50uhttpd-user start
/usr/sbin/uhttpd -f -h /www2 -r OpenWrt2 -x /cgi-bin -t 60 -T 30 -k 20 -A 1 -n 3 -N 100 -R -p 0.0.0.0:8080
netstat -t -x -u -l

/usr/sbin/uhttpd -f -h /www2 -r OpenWrt2 -x /cgi-bin -t 60 -T 30 -k 20 -A 1 -n 3 -N 100 -R -p 0.0.0.0:8080 -U /tmp/uh.lock

ln -s ../../usr/libexec/cgi-io /mnt/cgi-bin/cgi-exec
ln -s ../../usr/libexec/cgi-io /mnt/cgi-bin/cgi-download
uhttpd-mod-lua

# uci set system.out1.default=1      
# uci commit
# /etc/init.d/led restart

mkdir /usr/lib/lua/test/
cp test/test-* /usr/lib/lua/test/
