#!/bin/sh
#
cd ./src/main/webapp/portfolio
for file in `find ./ -printf '%P\n' -name '*.jpg'`;do convert -thumbnail 200 $file t_$file; done
cd ../../../../
