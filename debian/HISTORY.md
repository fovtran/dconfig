mount -t proc proc /proc
mount -o remount,rw /
apt remove totem-plugins
apt remove gnome-music
apt autoremove
apt remove gnome-mahjongg gnome-games 
apt remove gnome-maps gnome-sound-recorder  gnome-getting-started-docs 
echo "echo '.bashrc boot'" > /.bashrc
dpkg -l|grep rygel
apt remove rygel
apt remove scantv
apt remove xserver-xorg-video-vmware xserver-xorg-video-qxl xserver-xorg-video-radeon xserver-xorg-video-amdgpu thunar-data
mount -o remount,ro /
tune2fs -l  /dev/sda1
apt remove qt5-style-plugins android-tools-adb 
