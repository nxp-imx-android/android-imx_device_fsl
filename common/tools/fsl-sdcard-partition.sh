#!/bin/bash

# android-tools-fsutils should be installed as
# "sudo apt-get install android-tools-fsutils"

help() {

bn=`basename $0`
cat << EOF
usage $bn <option> device_node

options:
  -h				displays this help message
  -s				only get partition size
  -np 				not partition.
  -f soc_name			flash android image.
  -a				only flash image to slot_a
  -b				only flash image to slot_b
  -c card_size			optional setting: 7 / 14 / 28
					If not set, use partition-table.img
					If set to 7, use partition-table-7GB.img for 7GB SD card
EOF

}

# parse command line
moreoptions=1
node="na"
soc_name=""
cal_only=0
card_size=0
bootloader_offset=1
vaild_gpt_size=17
flash_images=1
not_partition=0
not_format_fs=0
slot=""
systemimage_file="system.img"
systemimage_raw_file="system_raw.img"
vendor_file="vendor.img"
vendor_raw_file="vendor_raw.img"
partition_file="partition-table.img"
g_sizes=0
while [ "$moreoptions" = 1 -a $# -gt 0 ]; do
	case $1 in
	    -h) help; exit ;;
	    -s) cal_only=1 ;;
	    -f) flash_images=1 ; soc_name=$2; shift;;
	    -c) card_size=$2; shift;;
	    -np) not_partition=1 ;;
	    -nf) not_format_fs=1 ;;
	    -a) slot="_a" ;;
	    -b) slot="_b" ;;
	    *)  moreoptions=0; node=$1 ;;
	esac
	[ "$moreoptions" = 0 ] && [ $# -gt 1 ] && help && exit
	[ "$moreoptions" = 1 ] && shift
done

if [ ${card_size} -ne 0 ] && [ ${card_size} -ne 7 ] && [ ${card_size} -ne 14 ] && [ ${card_size} -ne 28 ]; then
    help; exit;
fi

if [ "${soc_name}" = "imx8dv" ]; then
    bootloader_offset=16
fi


if [ "${soc_name}" = "imx8qm" -o "${soc_name}" = "imx8qxp" -o "${soc_name}" = "imx8mq" ]; then
    bootloader_offset=33
fi

if [ "${soc_name}" != "" ]; then
    soc_name="-${soc_name}"
fi

if [ ! -e ${node} ]; then
	help
	exit
fi


# dump partitions
if [ "${cal_only}" -eq "1" ]; then
gdisk -l ${node} 2>/dev/null | grep -A 20 "Number  "
exit
fi

function get_partition_size
{
    start_sector=`gdisk -l ${node} | grep -w $1 | awk '{print $2}'`
    end_sector=`gdisk -l ${node} | grep -w $1 | awk '{print $3}'`
    # 1 sector = 512 bytes. This will change unit from sector to MBytes.
    let "g_sizes=($end_sector - $start_sector + 1) / 2048"
}

function format_partition
{
    num=`gdisk -l ${node} | grep -w $1 | awk '{print $1}'`
    if [ ${num} -gt 0 ] 2>/dev/null; then
        echo "format_partition: $1:${node}${num} ext4"
        mkfs.ext4 -F ${node}${num} -L$1
    fi
}

function erase_partition
{
    num=`gdisk -l ${node} | grep -w $1 | awk '{print $1}'`
    if [ ${num} -gt 0 ] 2>/dev/null; then
        get_partition_size $1
        echo "erase_partition: $1 : ${node}${num} ${g_sizes}M"
        dd if=/dev/zero of=${node}${num} bs=1048576 conv=fsync count=$g_sizes
    fi
}

function flash_partition
{
    for num in `gdisk -l ${node} | grep -E -w "$1|$1_a|$1_b" | awk '{print $1}'`
    do
        if [ $? -eq 0 ]; then
            if [ $(echo ${1} | grep "system") != "" ] 2>/dev/null; then
                img_name=${systemimage_raw_file}
            elif [ $(echo ${1} | grep "vendor") != "" ] 2>/dev/null; then
                img_name=${vendor_raw_file}
            else
                img_name="${1%_*}${soc_name}.img"
            fi
            echo "flash_partition: ${img_name} ---> ${node}${num}"
            dd if=${img_name} of=${node}${num} bs=10M conv=fsync
        fi
    done
}

function format_android
{
    echo "formating android images"
    format_partition userdata
    format_partition cache
    erase_partition presistdata
    erase_partition fbmisc
    erase_partition misc
}

function make_partition
{
    if [ ${card_size} -gt 0 ]; then
        partition_file="partition-table-${card_size}GB.img"
    fi
    echo "make gpt partition for android: ${partition_file}"
    dd if=${partition_file} of=${node} bs=1k count=${vaild_gpt_size} conv=fsync
}

function flash_android
{
    boot_partition="boot"${slot}
    recovery_partition="recovery"${slot}
    system_partition="system"${slot}
    vendor_partition="vendor"${slot}
    vbmeta_partition="vbmeta"${slot}

if [ "${flash_images}" -eq "1" ]; then
    bootloader_file="u-boot${soc_name}.imx"
    flash_partition ${boot_partition}
    flash_partition ${recovery_partition}
    simg2img ${systemimage_file} ${systemimage_raw_file}
    flash_partition ${system_partition}
    rm ${systemimage_raw_file}
    simg2img ${vendor_file} ${vendor_raw_file}
    flash_partition ${vendor_partition}
    rm ${vendor_raw_file}
    flash_partition ${vbmeta_partition}
    echo "erase_partition: uboot : ${node}"
    echo "flash_partition: ${bootloader_file} ---> ${node}"
    first_partition_offset=`gdisk -l ${node} | grep ' 1 ' | awk '{print $2}'`
    # the unit of first_partition_offset is sector size which is 512 Byte.
    count_bootloader=`expr ${first_partition_offset} / 2 - ${bootloader_offset}`
    echo "the bootloader partition size: ${count_bootloader}"
    dd if=/dev/zero of=${node} bs=1k seek=${bootloader_offset} conv=fsync count=${count_bootloader}
    dd if=${bootloader_file} of=${node} bs=1k seek=${bootloader_offset} conv=fsync
fi
}

if [[ "${not_partition}" -eq "1" && "${flash_images}" -eq "1" ]] ; then
    flash_android
    exit
fi

make_partition
sleep 3
for i in `cat /proc/mounts | grep "${node}" | awk '{print $2}'`; do umount $i; done
hdparm -z ${node}

# backup the GPT table to last LBA for sd card.
echo -e 'r\ne\nY\nw\nY\nY' |  gdisk ${node}

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
