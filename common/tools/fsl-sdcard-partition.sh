#!/bin/bash

# android-tools-fsutils should be installed as
# "sudo apt-get install android-tools-fsutils"

# partition size in MB
BOOTLOAD_RESERVE=8
BOOT_ROM_SIZE=32
SYSTEM_ROM_SIZE=1536
CACHE_SIZE=512
RECOVERY_ROM_SIZE=32
DEVICE_SIZE=8
MISC_SIZE=4
DATAFOOTER_SIZE=2
METADATA_SIZE=2
FBMISC_SIZE=1
PRESISTDATA_SIZE=1

help() {

bn=`basename $0`
cat << EOF
usage $bn <option> device_node

options:
  -h				displays this help message
  -s				only get partition size
  -np 				not partition.
  -f soc_name			flash android image.
EOF

}

# parse command line
moreoptions=1
node="na"
soc_name=""
cal_only=0
bootloader_offset=1
flash_images=0
not_partition=0
not_format_fs=0
bootloader_file="u-boot.imx"
bootimage_file="boot.img"
systemimage_file="system.img"
systemimage_raw_file="system_raw.img"
recoveryimage_file="recovery.img"
while [ "$moreoptions" = 1 -a $# -gt 0 ]; do
	case $1 in
	    -h) help; exit ;;
	    -s) cal_only=1 ;;
	    -f) flash_images=1 ; soc_name=$2; shift;;
	    -np) not_partition=1 ;;
	    -nf) not_format_fs=1 ;;
	    *)  moreoptions=0; node=$1 ;;
	esac
	[ "$moreoptions" = 0 ] && [ $# -gt 1 ] && help && exit
	[ "$moreoptions" = 1 ] && shift
done

if [ "${soc_name}" = "imx8dv" ]; then
    bootloader_offset=16
fi

if [ ! -e ${node} ]; then
	help
	exit
fi


sfdisk_version=`sfdisk -v | awk '{print $4}' | awk -F '.' '{print $2}'`
if [ $sfdisk_version -ge "26" ]; then
    opt_unit=""
    unit_mb="M"
else
    echo "Please update your sfdisk version to 2.26 or later version"
    exit
fi

# call sfdisk to create partition table
# get total card size
seprate=100
total_size=`sfdisk -s ${node}`
total_size=`expr ${total_size} / 1024`
boot_rom_sizeb=`expr ${BOOT_ROM_SIZE} + ${BOOTLOAD_RESERVE}`
extend_size=`expr ${SYSTEM_ROM_SIZE} + ${CACHE_SIZE} + ${DEVICE_SIZE} + ${MISC_SIZE} + ${FBMISC_SIZE} + ${PRESISTDATA_SIZE} + ${DATAFOOTER_SIZE} + ${METADATA_SIZE} +  ${seprate}`
data_size=`expr ${total_size} - ${boot_rom_sizeb} - ${RECOVERY_ROM_SIZE} - ${extend_size}`

# create partitions
if [ "${cal_only}" -eq "1" ]; then
cat << EOF
BOOT   : ${boot_rom_sizeb}MB
RECOVERY: ${RECOVERY_ROM_SIZE}MB
SYSTEM : ${SYSTEM_ROM_SIZE}MB
CACHE  : ${CACHE_SIZE}MB
DATA   : ${data_size}MB
MISC   : ${MISC_SIZE}MB
DEVICE : ${DEVICE_SIZE}MB
DATAFOOTER : ${DATAFOOTER_SIZE}MB
METADATA : ${METADATA_SIZE}MB
FBMISC   : ${FBMISC_SIZE}MB
PRESISTDATA : ${PRESISTDATA_SIZE}MB
EOF
exit
fi

function format_android
{
    echo "formating android images"
    mkfs.ext4 ${node}${part}4 -L data
    mkfs.ext4 ${node}${part}5 -Lsystem
    mkfs.ext4 ${node}${part}6 -Lcache
    mkfs.ext4 ${node}${part}7 -Ldevice
}

function flash_android
{
    bootloader_file="u-boot-${soc_name}.imx"
    bootimage_file="boot-${soc_name}.img"
    recoveryimage_file="recovery-${soc_name}.img"
if [ "${flash_images}" -eq "1" ]; then
    echo "flashing android images..."    
    echo "bootloader: ${bootloader_file} offset: ${bootloader_offset}"
    echo "boot image: ${bootimage_file}"
    echo "recovery image: ${recoveryimage_file}"
    echo "system image: ${systemimage_file}"
    dd if=/dev/zero of=${node} bs=1k seek=${bootloader_offset} conv=fsync count=800
    dd if=${bootloader_file} of=${node} bs=1k seek=${bootloader_offset} conv=fsync
    dd if=${bootimage_file} of=${node}${part}1 conv=fsync
    dd if=${recoveryimage_file} of=${node}${part}2 conv=fsync
    simg2img ${systemimage_file} ${systemimage_raw_file}
    dd if=${systemimage_raw_file} of=${node}${part}5 conv=fsync
    rm ${systemimage_raw_file}
fi
}

if [[ "${not_partition}" -eq "1" && "${flash_images}" -eq "1" ]] ; then
    flash_android
    exit
fi

sfdisk --force ${opt_unit}  ${node} << EOF
,${boot_rom_sizeb}${unit_mb},83
,${RECOVERY_ROM_SIZE}${unit_mb},83
,${extend_size}${unit_mb},5
,${data_size}${unit_mb},83
,${SYSTEM_ROM_SIZE}${unit_mb},83
,${CACHE_SIZE}${unit_mb},83
,${DEVICE_SIZE}${unit_mb},83
,${MISC_SIZE}${unit_mb},83
,${DATAFOOTER_SIZE}${unit_mb},83
,${METADATA_SIZE}${unit_mb},83
,${FBMISC_SIZE}${unit_mb},83
,${PRESISTDATA_SIZE}${unit_mb},83
EOF

# adjust the partition reserve for bootloader.
# if you don't put the uboot on same device, you can remove the BOOTLOADER_ERSERVE
# to have 8M space.
# the minimal sylinder for some card is 4M, maybe some was 8M
# just 8M for some big eMMC 's sylinder
sfdisk --force ${opt_unit} ${node} -N1 << EOF
${BOOTLOAD_RESERVE}${unit_mb},${BOOT_ROM_SIZE}${unit_mb},83
EOF

# sleep 5s after re-partition
# umount the partition which is mounted automatically.
# sync the mbr table with hdparm
sleep 5
for i in `cat /proc/mounts | grep "${node}" | awk '{print $2}'`; do umount $i; done
hdparm -z ${node}

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
