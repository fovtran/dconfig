kmod-ppp
kmod-pppoe
kmod-pppox
kmod-slhc

opkg remove kmod-slhc --force-removal-of-dependent-packages
ssh root@router2 -C 'opkg remove kmod-slhc --force-removal-of-dependent-packages'

opkg list-installed
opkg remove odhcpd-ipv6only
opkg remove odhcp6c

opkg install kmod-fs-ext4
opkg install kmod-usb-storage
opkg install block-mount

