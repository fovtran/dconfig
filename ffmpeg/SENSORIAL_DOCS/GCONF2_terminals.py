"""
#! /bin/sh

# First panel to move
start=2

# Number of panels to move
count=$( wmctrl -d | wc -l )

desk=0
for winid in $( wmctrl -l | grep 'dom0 xfce4-panel$' \
    | awk "NR==$start,NR==$(( start + count - 1 )) { print \$1; }" )
do
    wmctrl -i -r $winid -b remove,sticky
    wmctrl -i -r $winid -t $desk
    desk=$(( desk + 1 ))
done

Save this script, for instance as local-panels.sh in your home directory, and make it executable (chmod u+x ~/local-panels.sh)
Configure the script to suit your needs:
$start: XFCE numbers your panels, this is the number of the fist panel you want to make local. Here the first panel is kept global, and the panel 2 and onward are made local to their own workspaces.
$count: The number of panels to make local. By default this is equal to the number of workspaces, ie. one different local panel per workspace.
$desk: The first workspace to have a local panel. By default every workspace will have a local panel, but setting this variable to a higher value allows you to have no local panel on the first few workspaces if you would like to.

Configure XFCE to automatically start this script upon session opening: go in XFCE Settings Manager > Session and Startup, click on the Application Autostart tab, and then on the Add button to schedule the execution of the script upon each session opening.
"""
#!/usr/bin/env python3
import subprocess
import os
import time
import shutil

home = os.environ["HOME"]
desktop_dir = home+"/"+"Desktop"
data_dirstr = home+"/desktop_data/desktop_"

get = lambda cmd: subprocess.check_output(["/bin/bash", "-c", cmd]).decode("utf-8")

def get_desktop():
    return [l for l in get("wmctrl -d").splitlines() if "*" in l][0].split()[-1]

while True:
    curr_dt1 = get_desktop()
    time.sleep(1)
    curr_dt2 = get_desktop()
    # alter the set of launchers when workspace changes
    if not curr_dt1 == curr_dt2:
        datafolder = data_dirstr+curr_dt2
        for f in [f for f in os.listdir(desktop_dir)if f.endswith(".desktop")]:
            subject = desktop_dir+"/"+f
            os.remove(subject)
        for f in os.listdir(datafolder):
            subject = datafolder+"/"+f; target = desktop_dir+"/"+f
            shutil.copyfile(subject, target)
            subprocess.call(["/bin/bash", "-c", "chmod +x "+target])

#!/usr/bin/env python3
import subprocess
import os
import time
import shutil

home = os.environ["HOME"]
desktop_dir = home+"/"+"Desktop"
data_dirstr = home+"/desktop_data/desktop_"

get = lambda cmd: subprocess.check_output(["/bin/bash", "-c", cmd]).decode("utf-8")
def get_desktop():
    return [l for l in get("wmctrl -d").splitlines() if "*" in l][0].split()[-1]

while True:
    curr_dt1 = get_desktop()
    time.sleep(1)
    curr_dt2 = get_desktop()
    # alter the set of launchers & links when workspace changes
    if not curr_dt1 == curr_dt2:
        datafolder = data_dirstr+curr_dt2
        for f in os.listdir(desktop_dir):
            subject = desktop_dir+"/"+f
            if os.path.islink(subject) or subject.endswith(".desktop") :
                os.remove(subject)
        for f in os.listdir(datafolder):
            subject = datafolder+"/"+f; target = desktop_dir+"/"+f
            if os.path.islink(subject):
                os.symlink(os.readlink(subject), target)
            else:
                shutil.copy(subject,target)
