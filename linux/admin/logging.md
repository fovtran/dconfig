$ systemd-analyze set-log-level
journalctl --force --user --vacuum-time=20s
journalctl --force --vacuum-time=20s
journalctl --all --boot 0 --user

echo 'hello' | systemd-cat -p emerg
[Service]
...
LogNamespace=noisy

Create a new config for that namespace:

cd /etc/systemd
cp journald.conf journald@noisy.conf
nano journald@noisy.conf

And edit the config however you wish. E.g. I just set it to Storage=volatile and RuntimeMaxUse=10M because I don't give a hoot about my app's syslog logs (I already have sufficient app logs). N.B.: When storage is volatile, it uses Runtime* vars, not System* vars.

Reload and restart:

sudo systemctl daemon-reload
sudo systemctl restart myapp # mayb
