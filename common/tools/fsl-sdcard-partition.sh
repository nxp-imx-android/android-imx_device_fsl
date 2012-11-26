#!/bin/bash

# partition size in MB
BOOTLOAD_RESERVE=8
BOOT_ROM_SIZE=8
SYSTEM_ROM_SIZE=512
DATA_SIZE=1024
CACHE_SIZE=256
RECOVERY_ROM_SIZE=8
VENDER_SIZE=8
MISC_SIZE=8

help() {

bn=`basename $0`
cat << EOF
usage $bn <option> device_node

options:
  -h				displays this help message
  -s				only get partition size
  -np 				not partition.
  -f 				flash android image.
EOF

}

# check the if root?
userid=`id -u`
if [ $userid -ne "0" ]; then
	echo "you're not root?"
	exit
fi


# parse command line
moreoptions=1
node="na"
cal_only=0
flash_images=0
not_partition=0
not_format_fs=0
while [ "$moreoptions" = 1 -a $# -gt 0 ]; do
	case $1 in
	    -h) help; exit ;;
	    -s) cal_only=1 ;;
	    -f) flash_images=1 ;;
	    -np) not_partition=1 ;;
	    -nf) not_format_fs=1 ;;
	    *)  moreoptions=0; node=$1 ;;
	esac
	[ "$moreoptions" = 0 ] && [ $# -gt 1 ] && help && exit
	[ "$moreoptions" = 1 ] && shift
done

if [ ! -e ${node} ]; then
	help
	exit
fi


# call sfdisk to create partition table
# get total card size
seprate=40
total_size=`sfdisk -s ${node}`
total_size=`expr ${total_size} / 1024`
rom_size=`expr ${BOOT_ROM_SIZE} + ${SYSTEM_ROM_SIZE} + ${DATA_SIZE}`
rom_size=`expr ${rom_size} + ${CACHE_SIZE} + ${RECOVERY_ROM_SIZE} + ${MISC_SIZE} + ${VENDER_SIZE} + ${seprate}`
boot_start=`expr ${BOOTLOAD_RESERVE}`
boot_rom_sizeb=`expr ${BOOT_ROM_SIZE} + ${BOOTLOAD_RESERVE}`
recovery_start=`expr ${boot_start} + ${BOOT_ROM_SIZE} + 1`
extend_start=`expr ${recovery_start} + 1`
extend_size=`expr ${SYSTEM_ROM_SIZE} + ${DATA_SIZE} + ${CACHE_SIZE} + ${VENDER_SIZE} + ${MISC_SIZE} + ${seprate}`
system_start=`expr ${extend_start} + 1`
cache_start=`expr ${extend_start} + ${SYSTEM_ROM_SIZE} + 1`
data_start=`expr ${cache_start} + ${CACHE_SIZE} + 1`
misc_start=`expr ${data_start} + ${DATA_SIZE}`
vfat_start=`expr ${extend_start} + ${extend_size}`
vfat_size=`expr ${total_size} - ${rom_size}`

# create partitions
if [ "${cal_only}" -eq "1" ]; then
cat << EOF
BOOT   : ${boot_rom_sizeb}MB
RECOVERY: ${RECOVERY_ROM_SIZE}MB
SYSTEM : ${SYSTEM_ROM_SIZE}MB
CACHE  : ${CACHE_SIZE}MB
DATA   : ${DATA_SIZE}MB
MISC   : ${MISC_SIZE}MB
VFAT   : ${vfat_size}MB
EOF
exit
fi

function format_android
{
    echo "formating android images"
    mkfs.vfat ${node}4
    mkfs.ext4 ${node}5 -Lsystem
    mkfs.ext4 ${node}6 -Lcache
    mkfs.ext4 ${node}7 -Ldata
    mkfs.ext4 ${node}8 -Lvender
}

function flash_android
{
if [ "${flash_images}" -eq "1" ]; then
    echo "flashing android images..."    
    dd if=u-boot.bin of=${node} bs=1k seek=1 skip=1
    dd if=/dev/zero of=${node} bs=512 seek=1536 count=16
    dd if=boot.img of=${node}1
    dd if=recovery.img of=${node}2
    dd if=system.img of=${node}5
fi
}

if [[ "${not_partition}" -eq "1" && "${flash_images}" -eq "1" ]] ; then
    flash_android
    exit
fi


# destroy the partition table
dd if=/dev/zero of=${node} bs=1024 count=1

sfdisk --force -uM ${node} << EOF
,${boot_rom_sizeb},83
,${RECOVERY_ROM_SIZE},83
,${extend_size},5
,${vfat_size},b
,${SYSTEM_ROM_SIZE},83
,${CACHE_SIZE},83
,${DATA_SIZE},83
,${VENDER_SIZE},83
,${MISC_SIZE},83
EOF

# adjust the partition reserve for bootloader.
# if you don't put the uboot on same device, you can remove the BOOTLOADER_ERSERVE
# to have 8M space.
# the minimal sylinder for some card is 4M, maybe some was 8M
# just 8M for some big eMMC 's sylinder
sfdisk --force -uM ${node} -N1 << EOF
${BOOTLOAD_RESERVE},${BOOT_ROM_SIZE},83
EOF

# format the SDCARD/DATA/CACHE partition
part=""
echo ${node} | grep mmcblk > /dev/null
if [ "$?" -eq "0" ]; then
	part="p"
fi

format_android
flash_android


# For MFGTool Notes:
# MFGTool use mksdcard-android.tar store this script
# if you want change it.
# do following:
#   tar xf mksdcard-android.sh.tar
#   vi mksdcard-android.sh 
#   [ edit want you want to change ]
#   rm mksdcard-android.sh.tar; tar cf mksdcard-android.sh.tar mksdcard-android.sh
