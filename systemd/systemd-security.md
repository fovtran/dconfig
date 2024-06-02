$ systemd --user
systemd 241 running in user mode for user 1000/nosat. (+PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD -IDN2 +IDN -PCRE2 default-hierarchy=hybrid)
RLIMIT_MEMLOCK is already as high or higher than we need it, not bumping.
Found cgroup2 on /sys/fs/cgroup/unified, unified hierarchy for systemd controller
Unified cgroup hierarchy is located at /sys/fs/cgroup/unified/user.slice/user-1000.slice/session-5.scope. Controllers are on legacy hierarchies.
Failed to create /user.slice/user-1000.slice/session-5.scope/init.scope control group: Permission denied
Failed to allocate manager object: Permission denied


sudo systemd-run --user --uid=$(id -u nosat) --gid=$(id -g nosat) -E "DISPLAY=:0.0" -t --slice=systemd-example-isolation-helper.slice /opt/BOOT/firefox/firefox --no-remote
Running as unit: run-u482.service

systemd-run --uid=$(id -u nosat) --gid=$(id -g nosat) -E "DISPLAY=:0.0" -t --slice=systemd-example-isolation-helper.slice /opt/BOOT/VSCode-linux-x64/bin/code-insiders ~/public_html


systemd-analyze security [unit]
# systemctl edit httpd
/bin/sh -c "while true; do true; done" & # CPU HOG

[Service]
ProtectSystem=strict
ProtectHome=yes
PrivateDevices=yes
ProtectKernelTunables=yes
ProtectKernelModules=yes
ProtectControlGroups=yes
SystemCallFilter=@system-service
SystemCallErrorNumber=EPERM
NoNewPrivileges=yes
PrivateTmp=yes

$ systemd-run --help
systemd-run [OPTIONS...] {COMMAND} [ARGS...]

Run the specified command in a transient scope or service.

  -h --help                       Show this help
     --version                    Show package version
     --no-ask-password            Do not prompt for password
     --user                       Run as user unit
  -H --host=[USER@]HOST           Operate on remote host
  -M --machine=CONTAINER          Operate on local container
     --scope                      Run this as scope rather than service
     --unit=UNIT                  Run under the specified unit name
  -p --property=NAME=VALUE        Set service or scope unit property
     --description=TEXT           Description for unit
     --slice=SLICE                Run in the specified slice
     --no-block                   Do not wait until operation finished
  -r --remain-after-exit          Leave service around until explicitly stopped
     --wait                       Wait until service stopped again
     --send-sighup                Send SIGHUP when terminating
     --service-type=TYPE          Service type
     --uid=USER                   Run as system user
     --gid=GROUP                  Run as system group
     --nice=NICE                  Nice level
     --working-directory=PATH     Set working directory
  -d --same-dir                   Inherit working directory from caller
  -E --setenv=NAME=VALUE          Set environment
  -t --pty                        Run service on pseudo TTY as STDIN/STDOUT/
                                  STDERR
  -P --pipe                       Pass STDIN/STDOUT/STDERR directly to service
  -q --quiet                      Suppress information messages during runtime
  -G --collect                    Unload unit after it ran, even when failed
  -S --shell                      Invoke a $SHELL interactively

Path options:
     --path-property=NAME=VALUE   Set path unit property

Socket options:
     --socket-property=NAME=VALUE Set socket unit property

Timer options:
     --on-active=SECONDS          Run after SECONDS delay
     --on-boot=SECONDS            Run SECONDS after machine was booted up
     --on-startup=SECONDS         Run SECONDS after systemd activation
     --on-unit-active=SECONDS     Run SECONDS after the last activation
     --on-unit-inactive=SECONDS   Run SECONDS after the last deactivation
     --on-calendar=SPEC           Realtime timer
     --timer-property=NAME=VALUE  Set timer unit property

See the systemd-run(1) man page for details.

