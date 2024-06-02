opkg update
opkg install --force-reinstall opkg

opkg list | grep -e <pattern1> -e <pattern2>
opkg list | awk -e '/<pattern>/{print $0}'
opkg info kmod-nf-\* | awk -e '/length/{print $0}'
opkg list-installed | awk -e '{print $1}' | tr '\n' ' '
for pkg in <package1> <package2> <package3>; do opkg info ${pkg}; done
opkg depends dropbear

