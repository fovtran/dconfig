# Systemd Service Units and Timers

systemctl --user list-timers

mkdir ~/bin
# ~/bin/userdata.sh

#!/bin/bash

while true
do
    now=$(date)
    me=$(whoami)
    echo "User $me at $now"
    sleep 10
done

chmod +x ~/bin/userdata.sh
echo $XDG_CONFIG_HOME

mkdir -p ~/.config/systemd/user/
nano ~/.config/systemd/user/powerrun.service

systemctl --user daemon-reload

systemctl --user start powerrun.service
Failed to start powerrun.service: Unit powerrun.service has a bad unit file setting.
See user logs and 'systemctl --user status powerrun.service' for details.

systemctl --user status powerrun.service
○ powerrun.service - Script Daemon For Test User Services
     Loaded: bad-setting (Reason: Unit powerrun.service has a bad unit file setting.)
     Active: inactive (dead)

nano ~/.config/systemd/user/powerrun.service

systemctl --user daemon-reload
systemctl --user start powerrun.service
journalctl --all

# -- runner
[Unit]
Description=Script Daemon For Test User Services

[Service]
Type=simple
#User=diego
#Group=nobody
ExecStart=/home/diego//bin/userdata.sh
#Restart=on-failure
#StandardOutput=file:%h/log_file

[Install]
WantedBy=default.target

# --- timer
[Unit]
Description=Daily man-db regeneration
Documentation=man:mandb(8)

[Timer]
OnCalendar=daily
AccuracySec=12h
Persistent=true

[Install]
WantedBy=timers.target