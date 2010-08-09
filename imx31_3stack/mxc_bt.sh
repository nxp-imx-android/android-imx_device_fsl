#!/bin/sh

/system/xbin/bccmd -t bcsp -d /dev/ttymxc1 psload -r /system/etc/bluez/csr.psr;
/system/bin/hciattach -n -s 921600 /dev/ttymxc1 bcsp 921600;

exit 0;
