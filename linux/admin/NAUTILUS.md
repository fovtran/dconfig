# SETUP NAUTILUS
sudo apt install nautilus-dropbox nautilus-gtkhash nautilus-sendto nautilus-admin nautilus-compare nautilus-extension-gnome-terminal nautilus-scripts-manager gedit-plugins

sudo usermod -a -G plugdev nosat

# sudo apt install polkit-kde-1
# sudo apt install polkit-kde-agent-1

apt install policykit-1-gnome
root@cihonm:~ # /usr/lib/x86_64-linux-gnu/polkit-gnome-authentication-agent-1
/usr/lib/x86_64-linux-gnu/polkit-gnome-authentication-agent-1

# RUN THIS ONE
You most likely have a .desktop file in /etc/xdg/autostart in the path somewhere with the full path to your polkit daemon.
For me adding /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 in ~/.Xsession fixed the issue. 

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1

# you need to be in the `storage` group in order for this to work.
+ /etc/polkit-1/localauthority/50-local.d/55-storage.pkla
[Storage Permissions]
Identity=unix-group:plugdev
Action=org.freedesktop.udisks.filesystem-mount;org.freedesktop.udisks.drive-eject;org.freedesktop.udisks.drive-detach;org.freedesktop.udisks.luks-unlock;org.freedesktop.udisks.inhibit-polling;org.freedesktop.udisks.drive-set-spindown
ResultAny=yes
ResultActive=yes
ResultInactive=no

root@test-pc:~# udiskie-umount /dev/sdb1

/usr/lib/gvfs/gvfs-udisks2-volume-monitor

# Run as root
pkexec thunar
pkttyagent --process `pidof firefox-bin`
pkexec pwd
# start pkttyagent for this shell, so pkexec is able to ask for authentication
_SHPID=$BASHPID
pkttyagent -p "$_SHPID" &
_PKPID=$!

Then you can freely use pkexec inside the script and it will work flawlessly. At the end of the script just kill the agent:

# Kill pkttyagent process
kill "$_PKPID"
IT WORKS!

# also exec ck-launch-session dbus-launch --exit-with-session fvwm

# SELINUX INSTALL
sudo apt install policycoreutils-gui

Modify the udisks daemon security policy

The second solution is to change the security policy of the udisks daemon. To do this, of course, you must have the udisks2 package installed on your system so that you can use the features of udisks and change your settings.

Open as root for editing a /usr/share/polkit-1/actions/org.freedesktop.UDisks2.policy file:

sudo nano /usr/share/polkit-1/actions/org.freedesktop.UDisks2.policy

Here we find the rule beginning with the following:

<action id="org.freedesktop.udisks2.filesystem-mount">

And at the bottom of this block, modify the following sections about this:

    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>yes</allow_active>
    </defaults>

to:

    <defaults>
      <allow_any>yes</allow_any>
      <allow_inactive>yes</allow_inactive>
      <allow_active>yes</allow_active>
    </defaults>

Then save the file.

# POLICYKIT

Examples

To allow users of group somegroup to manage systemd services, create /etc/polkit-1/localauthority/50-local.d/manage-units.pkla with the following content:

[Allow users to manage services]
Identity=unix-group:somegroup
Action=org.freedesktop.systemd1.manage-units
ResultActive=yes

This is PolicyKit's equivalent of the following polkit rule which would be found at /etc/polkit-1/rules.d/50-manage-units.rules:

polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.systemd1.manage-units"
        && subject.isInGroup("somegroup") )
    {
        return polkit.Result.YES;
    }
});

 Administrators can modify the PolicyKit configuration by way of an XML file, usually PolicyKit.conf. The man page gives a few examples of entries like the following:

    <match action="org.freedesktop.hal.storage.mount-fixed">
      <match user="davidz">
        <return result="yes"/>
      </match>
      <match user="freddy">
        <return result="no"/>
      </match>
    </match>

https://wiki.archlinux.org/title/Polkit

Polkit definitions can be divided into two kinds:

    Actions are defined in XML .policy files located in /usr/share/polkit-1/actions. Each action has a set of default permissions attached to it (e.g. you need to identify as an administrator to use the GParted action). The defaults can be overruled but editing the actions files is NOT the correct way.
    Authorization rules are defined in JavaScript .rules files. They are found in two places: 3rd party packages can use /usr/share/polkit-1/rules.d (though few if any do) and /etc/polkit-1/rules.d is for local configuration.

The command pkaction lists all the actions defined in /usr/share/polkit-1/actions for quick reference.

To get an idea of what polkit can do, here are a few commonly used groups of actions:

    systemd-logind (org.freedesktop.login1.policy) actions regulated by polkit include powering off, rebooting, suspending and hibernating the system, including when other users may still be logged in.
    udisks (org.freedesktop.udisks2.policy) actions regulated by polkit include mounting file systems and unlocking encrypted devices.
    NetworkManager (org.freedesktop.NetworkManager.policy) actions regulated by polkit include turning on and off the network, wifi or mobile broadband.

Each action is defined in an <action> tag in a .policy file. The org.gnome.gparted.policy contains a single action and looks like this:

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/software/polkit/policyconfig-1.dtd">
<policyconfig>

  <action id="org.gnome.gparted">
    <message>Authentication is required to run the GParted Partition Editor</message>
    <icon_name>gparted</icon_name>
    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>auth_admin</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">/usr/bin/gparted</annotate>
    <annotate key="org.freedesktop.policykit.exec.allow_gui">true</annotate>
  </action>

</policyconfig>


# NAUTILUS


Creating the scripts directory

$ mkdir -p ~/.local/share/nautilus/scripts

Nautilus scripts variables

For our scripts to be somehow useful, it should be possible to interact with the file manager status and be able to reference, for example, the path and the names of selected files, or the current working directory: we can access these information via some variables set exactly for this purpose. Let’s see them.
First of all we have the NAUTILUS_SCRIPT_SELECTED_FILE_PATHS variable. As should always happen, the variable name is pretty self-explanatory: this variable holds the full filesystem path of the files currently selected in the file manager. The variable value is a string; the file paths are delimited by the use of newline characters.
Another very useful variable is NAUTILUS_SCRIPT_SELECTED_URIS. We can use this variable, like the one we just saw, to reference selected files, with one difference: the files are not referenced by their paths, but by their URI, or “Unified Resource Identifier”. The role of this variable becomes evident when working on remote filesystems: in that case, simple paths will not work, and the NAUTILUS_SCRIPT_SELECT_FILE_PATHS variable will be empty. In such situations, to access the files we also need to know the type of protocol in use: a file selected in the file manager via the sftp protocol, for example, will be referenced as sftp://path/to/file.
Finally, we have the NAUTILUS_SCRIPT_CURRENT_URI and the NAUTILUS_SCRIPT_WINDOW_GEOMETRY variables. The former contains the URI of the directory opened in the file manger; the latter information about the geometry (width and height) and the position of the file manager window (eg: 631×642+26+23).

#!/usr/bin/env python3
"""
Author: Egidio Docile
Organize selected pictures by their creation date, using the exif
DateTimeOriginal tag
"""

import datetime
import os

from PIL import Image

DATETIME_ORIGINAL=36867

def main():
    for path in os.getenv('NAUTILUS_SCRIPT_SELECTED_FILE_PATHS','').splitlines():
        try:
            exif_data = Image.open(path)._getexif()
        except OSError:
            continue

        try:
            date = datetime.datetime.strptime(exif_data[DATETIME_ORIGINAL], '%Y:%m:%d %H:%M:%S')
            directory = os.path.join(date.strftime('%Y'), date.strftime('%B'))
        except (KeyError, ValueError, TypeError):
            directory = "unsorted"

        os.makedirs(directory, exist_ok=True)
        os.rename(path, os.path.join(directory, os.path.basename(path)))

if __name__ == '__main__':
    main()


#!/bin/bash
set -e
set -u
set -o pipefail

if zenity --question --title="Confirmation" --text="Should I run the script?"; then
  echo "${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS}" | while read -r selected_file; do
     file="$(basename "$selected_file")"
     mv "${file}" "${file,,}"
   done
fi
