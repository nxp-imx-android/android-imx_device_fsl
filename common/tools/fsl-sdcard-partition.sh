#!/bin/bash -e

help() {

bn=`basename $0`
cat << EOF

Version: 1.3
Last change: remove the limitation that this script must be executed with current directory containing the images
             remove the limitation that non-default images need to change file names before executing this script
             correct help info and remove the content not used for current stage.

Usage: $bn <option> device_node

options:
  -h                displays this help message
  -s                only get partition size
  -np               not partition.
  -f soc_name       flash android image file with soc_name. Below table lists soc_name values and bootloader offset.
                           ┌────────────────────────────┬───────────────┐
                           │   soc_name                 │     offset    │
                           ├────────────────────────────┼───────────────┤
                           │ imx6dl/imx6q/imx6qp        │      1k       │
                           │ imx6sx/imx7d/imx7ulp       │               │
                           ├────────────────────────────┼───────────────┤
                           │ imx8mm/imx8mq              │      33k      │
                           ├────────────────────────────┼───────────────┤
                           │ imx8qm/imx8qxp             │      32k      │
                           └────────────────────────────┴───────────────┘
  -a                only flash image to slot_a
  -b                only flash image to slot_b
  -c card_size      optional setting: 7 / 14 / 28
                        If not set, use partition-table.img (default)
                        If set to  7, use partition-table-7GB.img  for  8GB SD card
                        If set to 14, use partition-table-14GB.img for 16GB SD card
                        If set to 28, use partition-table-28GB.img for 32GB SD card
                    Make sure the corresponding file exist for your platform.
  -d dev            flash android image file with "dev" in there names.
  -D directory      specify the directory which contains the images to be flashed.
  -m                flash m4 image
  -o force_offset   force set uboot offset
EOF

}

# parse command line
moreoptions=1
node="na"
soc_name=""
force_offset=""
cal_only=0
card_size=0
bootloader_offset=1
m4_image_offset=5120
vaild_gpt_size=17
not_partition=0
slot=""
systemimage_file="system.img"
vendor_file="vendor.img"
partition_file="partition-table.img"
g_sizes=0
support_dtbo=0
flash_m4=0
RED='\033[0;31m'
STD='\033[0;0m'

image_directory=""
device_character=""



while [ "$moreoptions" = 1 -a $# -gt 0 ]; do
    case $1 in
        -h) help; exit ;;
        -s) cal_only=1 ;;
        -f) soc_name=$2; shift;;
        -c) card_size=$2; shift;;
        -np) not_partition=1 ;;
        -a) slot="_a" ;;
        -b) slot="_b" ;;
        -m) flash_m4=1 ;;
        -o) force_offset=$2; shift;;
        -d) device_character=$2; shift;;
        -D) image_directory=$2; shift;;
        *)  moreoptions=0; node=$1 ;;
    esac
    [ "$moreoptions" = 0 ] && [ $# -gt 1 ] && help && exit
    [ "$moreoptions" = 1 ] && shift
done

# check required applications are installed
command -v simg2img >/dev/null 2>&1 || { echo -e >&2 "${RED}Missing simg2img app. Please run: sudo apt-get install android-tools-fsutils${STD}" ; exit 1 ; }
command -v hdparm >/dev/null 2>&1 || { echo -e >&2 "${RED}Missing hdparm app. Please make sure it is installed. Exiting.${STD}" ; exit 1 ; }
command -v gdisk >/dev/null 2>&1 || { echo -e >&2 "${RED}Missing gdisk app. Please make sure it is installed. Exiting.${STD}" ; exit 1 ; }

if [ ${card_size} -ne 0 ] && [ ${card_size} -ne 7 ] && [ ${card_size} -ne 14 ] && [ ${card_size} -ne 28 ]; then
    help; exit 1;
fi

# imx8qxp RevB0 chips and imx8qm RevB0 chips, bootloader offset is 32KB on SD card
if [ "${soc_name}" = "imx8qxp" -o "${soc_name}" = "imx8qm" ]; then
    bootloader_offset=32
fi

# imx8mq chips and imx8mm chips, bootloader offset is 33KB on SD card
if [ "${soc_name}" = "imx8mq" -o "${soc_name}" = "imx8mm" ]; then
    bootloader_offset=33
fi

if [ "${force_offset}" != "" ]; then
    bootloader_offset=${force_offset}
fi

# exit if the block device file specified by ${node} doesn't exist
if [ ! -e ${node} ]; then
    help
    exit 1
fi

# to be discussed
# echo "${soc_name} bootloader offset is: ${bootloader_offset}"

# for specified directory, make sure there is a slash at the end
if [[ "${image_directory}" != "" ]]; then
    image_directory="${image_directory%/}/";
fi



# dump partitions
if [ "${cal_only}" -eq "1" ]; then
    gdisk -l ${node} 2>/dev/null | grep -A 20 "Number  "
    exit 0
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
            if [ "$(echo ${1} | grep "system")" != "" ]; then
                img_name=${systemimage_file}
            elif [ "$(echo ${1} | grep "vendor")" != "" ]; then
                img_name=${vendor_file}
            elif [ ${support_dtbo} -eq 1 ] && [ $(echo ${1} | grep "boot") != "" ] 2>/dev/null; then
                img_name="boot.img"
            elif [ "$(echo ${1} | grep -E "dtbo|vbmeta|recovery")" != "" -a "${device_character}" != "" ]; then
                img_name="${1%_*}-${soc_name}-${device_character}.img"
            else
                img_name="${1%_*}-${soc_name}.img"
            fi
            # check whether the image files to be flashed exist or not
            if [ ! -f "${image_directory}${img_name}" ]; then
                echo -e >&2 "${RED}File ${img_name} not found. Please check. Exiting${STD}"
                return 1
            fi
            echo "flash_partition: ${img_name} ---> ${node}${num}"

            if [ "$(echo ${1} | grep "system")" != "" ] || [ "$(echo ${1} | grep "vendor")" != "" ]; then
                simg2img ${image_directory}${img_name} ${node}${num}
            else
                dd if=${image_directory}${img_name} of=${node}${num} bs=10M conv=fsync
            fi
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
    if [ ! -f "${image_directory}${partition_file}" ]; then
        echo -e >&2 "${RED}File ${partition_file} not found. Please check. Exiting${STD}"
        return 1
    fi
    echo "make gpt partition for android: ${partition_file}"
    dd if=${image_directory}${partition_file} of=${node} bs=1k count=${vaild_gpt_size} conv=fsync
}

function flash_android
{
    boot_partition="boot"${slot}
    recovery_partition="recovery"${slot}
    system_partition="system"${slot}
    vendor_partition="vendor"${slot}
    vbmeta_partition="vbmeta"${slot}
    dtbo_partition="dtbo"${slot}
    gdisk -l ${node} 2>/dev/null | grep -q "dtbo" && support_dtbo=1

    if [[ "${device_character}" == "ldo" ]] || [[ "${device_character}" == "epdc" ]] || \
            [[ "${device_character}" == "ddr4" ]]; then
        bootloader_file="u-boot-${soc_name}-${device_character}.imx"
    else
        bootloader_file="u-boot-${soc_name}.imx"
    fi

    if [ "${support_dtbo}" -eq "1" ] ; then
        flash_partition ${dtbo_partition} || exit 1
    fi
    flash_partition ${boot_partition}  || exit 1
    flash_partition ${recovery_partition}  || exit 1
    flash_partition ${system_partition} || exit 1
    flash_partition ${vendor_partition} || exit 1
    flash_partition ${vbmeta_partition} || exit 1
    echo "erase_partition: uboot : ${node}"
    echo "flash_partition: ${bootloader_file} ---> ${node}"
    first_partition_offset=`gdisk -l ${node} | grep ' 1 ' | awk '{print $2}'`
    # the unit of first_partition_offset is sector size which is 512 Byte.
    count_bootloader=`expr ${first_partition_offset} / 2 - ${bootloader_offset}`
    echo "the bootloader partition size: ${count_bootloader}"
    dd if=/dev/zero of=${node} bs=1k seek=${bootloader_offset} conv=fsync count=${count_bootloader}
    dd if=${image_directory}${bootloader_file} of=${node} bs=1k seek=${bootloader_offset} conv=fsync
    if [ "${flash_m4}" -eq "1" ] ; then
        if [ "${soc_name}" = "imx7ulp" ]; then
            echo -e >&2 "${RED}Caution:${STD}"
            echo -e >&2 "        m4 image for imx7ulp_evk is in SPI flash on board, not in SD card, use uboot commands to flash it."
        else
            m4_image=${soc_name#*-}"_m4_demo.img"
            echo "flash_partition: ${m4_image} ---> ${node}"
            dd if=${image_directory}${m4_image} of=${node} bs=1k seek=${m4_image_offset} conv=fsync
        fi
    fi
}

if [ "${not_partition}" -eq "1" ] ; then
    flash_android || exit 1
    echo ">>>>>>>>>>>>>> Flashing successfully completed <<<<<<<<<<<<<<"
    exit 0
fi


# invoke make_partition to write first 17KB in partition table image to sdcard start
make_partition || exit 1

# unmount partitions and then force to re-read the partition table of the specified device
sleep 3
for i in `cat /proc/mounts | grep "${node}" | awk '{print $2}'`; do umount $i; done
hdparm -z ${node}

# backup the GPT table to last LBA for sd card. execute "gdisk ${node}" with the input characters
# redirect standard OUTPUT to /dev/null to reduce some ouput
echo -e 'r\ne\nY\nw\nY\nY' |  gdisk ${node} 1>/dev/null

format_android
flash_android || exit 1

if [ "${slot}" = "_b" ]; then
    echo -e >&2 "${RED}Caution:${STD}"
    echo -e >&2 "       This script can't generate metadata to directly boot from b slot, fastboot command may need to be used to boot from b slot."
fi

echo
echo ">>>>>>>>>>>>>> Flashing successfully completed <<<<<<<<<<<<<<"

exit 0

# For MFGTool Notes:
# MFGTool use mksdcard-android.tar store this script
# if you want change it.
# do following:
#   tar xf mksdcard-android.sh.tar
#   vi mksdcard-android.sh 
#   [ edit want you want to change ]
#   rm mksdcard-android.sh.tar; tar cf mksdcard-android.sh.tar mksdcard-android.sh
