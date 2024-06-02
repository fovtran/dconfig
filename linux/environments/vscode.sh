#!/bin/bash

mount -o remount,exec,rw,size=2G /tmp

cd /tmp/

# wget --max-redirect=3 --user-agent=Mozilla --content-disposition -E -J https://code.visualstudio.com/sha/download?build=stable&os=linux-x64
# wget $(curl https://code.visualstudio.com/sha/download?build=stable&os=linux-x64 | grep window.location.href | cut -d'"' -f2 | sed 's/\\//g')
#wget -c https://github.com/VSCodium/vscodium/releases/download/1.82.2.23257/VSCodium-linux-x64-1.82.2.23257.tar.gz
wget -c https://code.visualstudio.com/sha/download?build=stable&os=linux-x64
wget -c https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.3-linux-x86_64.tar.gz
wget -c https://nodejs.org/dist/v18.18.0/node-v18.18.0-linux-x64.tar.xz

#wget -c https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.7-linux-x86_64.tar.gz
#wget -c https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.7-linux-x86_64.tar.gz.asc

exit 0
rm -rf julia-1.9.3/ node-v18.18.0-linux-x64 VSCode-linux-x64 vscode-user .vscode/

tar xvfz julia-1.9.3-linux-x86_64.tar.gz
rm julia-1.9.3-linux-x86_64.tar.gz
tar xvfJ node-v18.18.0-linux-x64.tar.xz
rm node-v18.18.0-linux-x64.tar.xz
# tar xvfz code*

./julia-1.9.3/bin/julia
# ./node-v18.18.0-linux-x64/bin/node
# ./VSCode-linux-x64/bin/code
HOME=/tmp/ /tmp/VSCode-linux-x64/bin/code --user-data-dir /tmp/vscode-user
