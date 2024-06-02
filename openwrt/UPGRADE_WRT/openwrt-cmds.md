find /sys|grep gpio

iw wlan0 scan|grep -A 20 BSS 

usr/bin/gpiomon bcm63xx-gpio.0 1
usr/bin/gpioinfo

# setup
jffs2reset
reboot
access 192.168.1.1 - no pass needed
go wireless, setup client mode
go interfaces setup bridge, change eth ip to 192.168.1.254
go hosts add hosts
go firewall drop invalid packets, 
go system, set hostname, disable ntp server
go administration, set pass diego77a

# LuCi
current luci is
Powered by LuCI openwrt-19.07 branch (git-21.044.30835-34e0d65) / OpenWrt 19.07.7 r11306-c4a6851c72 

git clone https://github.com/openwrt/luci

# BASE
Model				ADB P.DG A4001N
Architecture		bcm63xx/96328dg2x2 (0x6328/0xB0)
Firmware Version	OpenWrt 19.07.7 r11306-c4a6851c72 / LuCI openwrt-19.07 branch git-21.044.30835-34e0d65
Kernel Version		4.14.221

-> GO

client erase old sshe keys:
	ssh-keygen -f "/home/diego/.ssh/known_hosts" -R "router2"

modules:
	kmod-fs-ext4
	samba4-server
openssh-sftp-server
luci-app-samba4
mariadb-server
nfs-kernel-server-utils
nfs-kernel-server
ffserver
kmod-fs-ksmbd
kmod-fs-nfsd
ksmbd-server
lcdproc-server
iotivity-example-simple

services:
	/rom/etc/rc.d/S50uhttpd
	find /|grep http
/etc/config/uhttpd
/etc/init.d/uhttpd
/overlay/upper/etc/config/uhttpd
/overlay/upper/etc/rc.d/S50uhttpd-user
/rom/etc/config/uhttpd
/rom/etc/init.d/uhttpd
/rom/usr/sbin/uhttpd

/usr/share/rpcd/acl.d/luci-app-uhttpd.json
cp /usr/share/rpcd/acl.d/luci-app-uhttpd.json /usr/share/rpcd/acl.d/luci-app-uhttpd-user.json


/etc/rc.d/S50uhttpd-user start

root@arturia:~# opkg install usbutils kmod-usb-storage

