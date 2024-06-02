https://bbs.archlinux.org/viewtopic.php?id=285582
https://askubuntu.com/questions/1439652/how-can-i-downmix-stereo-audio-output-to-mono-in-pipewire-on-22-10

systemctl --user status pipewire{,-pulse}.service
wpctl

Open /usr/share/pulseaudio/alsa-mixer/profile-sets/default.conf, and add this to it:
pactl list modules
https://bbs.archlinux.org/viewtopic.php?id=278965
$ amixer sset "Auto-Mute" unmute
amixer set Master 5%+
amixer set Master toggle
modprobe snd-aloop
 $ arecord -c 2 -r 48000 -t wav -f FLOAT_LE -D pule - | aplay -c 2 -r 48000 -t wav -f FLOAT_LE -D pulse -
$ pacmd list-sink-inputs
$ pacmd list-source-outputs
$ pactl load-module module-loopback source=alsa_input.platform-sound.stereo-fallback sink=alsa_output.platform-sound.stereo-fallback

diego@lambert:~$ cat /usr/share/pipewire/pipewire.conf 

