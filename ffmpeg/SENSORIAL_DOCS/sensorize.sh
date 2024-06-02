#!/bin/bash

/usr/bin/sensors

hddtemp /dev/sda
hddtemp /dev/sdb
hddtemp /dev/sdc

/usr/bin/cpufreq-info
