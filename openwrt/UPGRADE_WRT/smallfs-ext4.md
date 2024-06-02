opkg install kmod-fs-ext4
opkg install kmod-usb-storage
opkg install block-mount
opkg install libblkid


mke2fs -t ext4 -O ^has_journal,^uninit_bg,^ext_attr,^huge_file,^64bit [/dev/device or /path/to/file]
# NO: mount -t ext4 -o user,uid=1001,gid=1001,nodiratime,noacl,noatime,rw,exec /dev/sdb1 /mnt/
mount -t ext4 -o user,noatime,nodiratime,errors=remount-ro,rw,exec /dev/sdb1 /mnt/
WRT : mount -t ext4 -o noatime,nodiratime,rw,exec /dev/sda1 /mnt/
ln -s /mnt /www2/DISK
vim /etc/config/uhttpd-user 
/etc/rc.d/S50uhttpd-user start
/usr/sbin/uhttpd -f -h /www2 -r OpenWrt2 -x /cgi-bin -t 60 -T 30 -k 20 -A 1 -n 3 -N 100 -R -p 0.0.0.0:8080
netstat -t -x -u -l
/usr/sbin/uhttpd -f -h /www2 -r OpenWrt2 -x /cgi-bin -t 60 -T 30 -k 20 -A 1 -n 3 -N 100 -R -p 0.0.0.0:8080 -U /tmp/uh.lock
mount --bind /mnt /www2/disk/
lsusb -t
block info | grep "/dev/sd"

mv linux-6.4.16.tar.xz node-v18.18.0-linux-x64.tar.xz julia-1.9.3-linux-x86_64.tar.gz VSCodium-linux-x64-1.82.2.23257.tar.gz /mnt/

# Automount the partition
# Generate a config entry for the fstab file:
block detect | uci import fstab
uci show fstab

uci set fstab.@mount[0].enabled='1'
uci set fstab.@mount[0].auto_swap='0'
uci commit fstab
service fstab boot

ln -s ../../usr/libexec/cgi-io /www2/cgi-bin/cgi-exec
ln -s ../../usr/libexec/cgi-io /www2/cgi-bin/cgi-download
uhttpd-mod-lua

i# uci set system.out1.default=1      
# uci commit
# /etc/init.d/led restart
w

mkdir /usr/lib/lua/test/
cp test/test-* /usr/lib/lua/test/

