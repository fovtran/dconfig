# file in /root/.asoundrc
# file in /home/$USER/.asoundrc
asoundrc= """
pulse {
        type                    "alsa"
        name                    "Sound Card: ALC888"
#        device                  "hw:0,0"     # optional
        format                  "44100:16:2" # optional
}

pcm.pulse { type pulse }
ctl.pulse { type pulse }

pcm.!default { type pulse }
ctl.!default { type pulse }
"""

# file in /etc/pulse/default.pa
# file in /home/$USER/.config/pulse/default.pa
pulsepa = """
#!/usr/bin/pulseaudio -nF
.fail

### Automatically restore the volume of streams and devices
load-module module-device-restore
load-module module-stream-restore
load-module module-card-restore

### Automatically augment property information from .desktop files stored in /usr/share/application
load-module module-augment-properties

### Should be after module-*-restore but before module-*-detect
load-module module-switch-on-port-available

### Load audio drivers statically (it's probably better to not load these drivers manually, but instead use module-udev-detect.

#load-module module-alsa-sink sink_name="AZALIA_OUT" device="hw:0,0"
#load-module module-alsa-source source_name="AZALIA_IN" device="hw:0,0"
#load-module module-alsa-sink sink_name="AZALIA_OUT" device=hw:0,0 channels=6 channel_map=front-left,front-right,rear-left,rear-right,front-center,lfe
#load-module module-oss device="/dev/dsp" sink_name=output source_name=input
#load-module module-oss-mmap device="/dev/dsp" sink_name=output source_name=input
#load-module module-pipe-sink

### Automatically load driver modules depending on the hardware available
.ifexists module-udev-detect.so
#load-module module-udev-detect use_ucm=0 tsched=0s ignore_dB=1
load-module module-udev-detect use_ucm=1 tsched=1 ignore_dB=0
.else
### Use the static hardware detection module (for systems that lack udev support)
#load-module module-detect
.endif

### Automatically connect sink and source if JACK server is present
#.ifexists module-jackdbus-detect.so
#.nofail
#load-module module-jackdbus-detect channels=2
#.fail
#.endif

# To record both mic and other audio input sources we need to add a named output sink. See:
# http://www.linuxquestions.org/questions/linux-software-2/alsa-and-pulseaudio-recording-multiple-input-devices-877614/
# http://www.youtube.com/watch?v=oJADNOY615Y&feature=player_embedded
.ifexists /tmp/enable-loopback
.else
load-module module-null-sink sink_name=stream
load-module module-loopback latency_msec=25 sink=stream
.endif

load-module module-native-protocol-unix

### Automatically load driver modules for Bluetooth hardware
#.ifexists module-bluetooth-policy.so
#load-module module-bluetooth-policy
#.endif
#.ifexists module-bluetooth-discover.so
#load-module module-bluetooth-discover
#.endif

### Load several protocols
#.ifexists module-esound-protocol-unix.so
#load-module module-esound-protocol-unix
#.endif

### Network access (may be configured with paprefs, so leave this commented here if you plan to use paprefs)
#load-module module-esound-protocol-tcp
#load-module module-native-protocol-tcp
#load-module module-zeroconf-publish

### Load the RTP receiver module (also configured via paprefs, see above)
#load-module module-rtp-recv

### Load the RTP sender module (also configured via paprefs, see above)
#load-module module-null-sink sink_name=rtp format=s16be channels=2 rate=44100 sink_properties="device.description='RTP Multicast Sink'"
#load-module module-rtp-send source=rtp.monitor

### Load additional modules from GSettings. This can be configured with the paprefs tool. Please keep in mind that the modules configured by paprefs might conflict with manually loaded modules.
.ifexists module-gsettings.so
.nofail
load-module module-gsettings
.fail
.endif

### Load something into the sample cache
load-sample-lazy x11-bell /usr/share/sounds/Oxygen-Sys-App-Message.ogg
load-sample-lazy pulse-hotplug /usr/share/sounds/Oxygen-Sys-App-Message.ogg
load-sample-lazy pulse-coldplug /usr/share/sounds/Oxygen-Sys-App-Message.ogg
load-sample-lazy pulse-access /usr/share/sounds/Oxygen-Sys-App-Message.ogg

### Automatically restore the default sink/source when changed by the user during runtime
### NOTE: This should be loaded as early as possible so that subsequent modules that look up the default sink/source get the right value
load-module module-default-device-restore

### Automatically move streams to the default sink if the sink they are connected to dies, similar for sources
load-module module-rescue-streams

### Make sure we always have a sink around, even if it is a null sink.
load-module module-always-sink

### Honour intended role device property
load-module module-intended-roles

### Automatically suspend sinks/sources that become idle for too long
#load-module module-suspend-on-idle

### If autoexit on idle is enabled we want to make sure we only quit when no local session needs us anymore.
.ifexists module-console-kit.so
#load-module module-console-kit
.endif

.ifexists module-systemd-login.so
load-module module-systemd-login
.endif

### Enable positioned event sounds
load-module module-position-event-sounds

### Cork music/video streams when a phone stream is active
# load-module module-role-cork

### Modules to allow autoloading of filters (such as echo cancellation) on demand. module-filter-heuristics tries to determine what filters
### make sense, and module-filter-apply does the heavy-lifting of loading modules and rerouting streams.
load-module module-filter-heuristics
load-module module-filter-apply

### Make some devices default
# alsa_output.pci-0000_00_14.2.analog-surround-51.monitor -> alsa_input.pci-0000_00_14.2.analog-stereo
#set-default-sink alsa_output.pci-0000_00_14.2.analog-surround-71.monitor
#set-default-sink alsa_output.pci-0000_00_14.2.analog-surround-71
#set-default-sink alsa_output.pci-0000_00_14.2.analog-stereo
#set-default-source alsa_input.pci-0000_00_14.2.analog-stereo
"""

# file in /etc/pulse/daemon.conf
# file in /home/$USER/.config/pulse/daemon.conf
daemonconf = """
# This file is part of PulseAudio.
daemonize = no
fail = yes
allow-module-loading = yes
allow-exit = yes
use-pid-file = yes
system-instance = no
local-server-type = user
enable-shm = yes
enable-memfd = yes
shm-size-bytes = 0 # setting this 0 will use the system-default, usually 64 MiB
;lock-memory = yes
; cpu-limit = yes

high-priority = yes
nice-level = -11
realtime-scheduling = yes
realtime-priority = 9
;rlimit-rtprio = 9

; exit-idle-time = 20
; scache-idle-time = 20

; dl-search-path = (depends on architecture)

load-default-script-file = yes
; default-script-file = /etc/pulse/default.pa

; log-target = auto
; log-level = notice
; log-meta = no
; log-time = no
; log-backtrace = 0

flat-volumes = no

;default-sample-format = s16le
;default-sample-format = s24le
;default-sample-format = float32le

; speex-float-10 is best fast method, soxr-vhq is better but slower
; avoid soxr-vhq if you have an old slow CPU
resample-method = speex-float-1
;resample-method = speex-float-10
;resample-method = soxr-vhq
avoid-resampling = true
enable-remixing = yes
remixing-use-all-sink-channels = no
enable-lfe-remixing = no
; remixing-produce-lfe = no
; remixing-consume-lfe = yes
;lfe-crossover-freq = 0

default-sample-rate = 44100
;alternate-sample-rate = 48000
; alternate-sample-rate = 96000
; alternate-sample-rate = 192000

default-sample-channels = 4
default-channel-map = front-left,front-right,rear-left,rear-right
;default-channel-map = front-left,front-right,rear-left,rear-right,front-center,lfe,side-left,side-right,aux0,aux1

default-fragments = 4
default-fragment-size-msec = 25

enable-deferred-volume = yes
deferred-volume-safety-margin-usec = 2000
; deferred-volume-extra-delay-usec = 0

; rlimit-fsize = -1
; rlimit-data = -1
; rlimit-stack = -1
; rlimit-core = -1
; rlimit-as = -1
; rlimit-rss = -1
; rlimit-nproc = -1
; rlimit-nofile = 256
; rlimit-memlock = -1
; rlimit-locks = -1
; rlimit-sigpending = -1
; rlimit-msgqueue = -1
; rlimit-nice = 31
; rlimit-rtprio = 9
; rlimit-rttime = 200000
"""

# file in /etc/pulse/client.conf
clientconf = """
# This file is part of PulseAudio.

; default-sink =
; default-source =
; default-server =
; default-server = /var/run/pulse/native
; default-dbus-server =

; autospawn = no
daemon-binary = /usr/bin/pulseaudio
; daemon-binary = /bin/true
extra-arguments = --log-target=syslog

; cookie-file =

enable-shm = yes
shm-size-bytes = 0 # setting this 0 will use the system-default, usually 64 MiB

; auto-connect-localhost = no
; auto-connect-display = no
"""

# file in /home/$USER/.config/pulse/client.conf
clientconf = """
autospawn=no
"""
# file in /etc/pulse/client.conf.d/00-disable-autospawn.conf
daemonextra = """
# On linux systems, disable autospawn by default
# If you are not using systemd, comment out this line
# autospawn=no
"""

# file in /home/$USER/.config/jack/conf.xml
jackd = """
<?xml version="1.0"?>
<!--
JACK settings, as persisted by D-Bus object.
You probably don't want to edit this because
it will be overwritten next time jackdbus saves.
-->
<!-- Sun Jun 19 00:59:56 2022 -->
<jack>
 <engine>
  <option name="driver">alsa</option>
  <option name="realtime">true</option>
  <option name="verbose">true</option>
  <option name="client-timeout">500</option>
 </engine>
 <drivers>
  <driver name="alsarawmidi">
  </driver>
  <driver name="net">
  </driver>
  <driver name="dummy">
  </driver>
  <driver name="alsa">
   <option name="device"></option>
   <option name="capture"></option>
   <option name="rate">44100</option>
   <option name="period">1024</option>
   <option name="nperiods">2</option>
   <option name="hwmon">false</option>
   <option name="hwmeter">true</option>
   <option name="softmode">true</option>
   <option name="monitor">false</option>
   <option name="dither">t</option>
   <option name="shorts">false</option>
   <option name="midi-driver">seq</option>
  </driver>
  <driver name="loopback">
  </driver>
  <driver name="netone">
  </driver>
  <driver name="firewire">
  </driver>
 </drivers>
 <internals>
  <internal name="netmanager">
  </internal>
  <internal name="profiler">
  </internal>
  <internal name="netadapter">
  </internal>
  <internal name="audioadapter">
  </internal>
 </internals>
</jack>
"""