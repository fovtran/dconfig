1. Install USB device support;
```shell
opkg install kmod-usb-core kmod-usb-ohci kmod-usb2 kmod-usb-storage e2fsprogs fdisk usbutils mount-utils block-mount kmod-fs-ext4 kmod-fs-vfat kmod-nls-utf-8 kmod-nls-cp437 kmod-nls-iso8859-1

reboot
```
2. Install ```blkid```, run ```opkg update && opkg install blkid```;
3. Copy ```block.sh``` to directory ```/lib/functions```;
4. Copy ```10-mount``` and ```20-swap``` to directory ```/etc/hotplug.d/block```;
5. That's it! run ```logread -f``` command then plug in a USB stick to test.