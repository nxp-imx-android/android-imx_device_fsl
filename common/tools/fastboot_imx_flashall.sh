#!/bin/bash -e

help() {

bn=`basename $0`
cat << EOF

Version: 1.0
Last change: This is first version, this script use fastboot to flash images.

Usage: $bn <option>

options:
  -h                displays this help message
  -f soc_name       flash android image file with soc_name
  -a                only flash image to slot_a
  -b                only flash image to slot_b
  -c card_size      optional setting: 7 / 14 / 28
                        If not set, use partition-table.img (default)
                        If set to  7, use partition-table-7GB.img  for  8GB SD card
                        If set to 14, use partition-table-14GB.img for 16GB SD card
                        If set to 28, use partition-table-28GB.img for 32GB SD card
                    Make sure the corresponding file exist for your platform
  -m                flash m4 image
  -d dev            flash dtbo, vbmeta and recovery image file with dev
                        If not set, use default dtbo, vbmeta and image
  -e                erase user data after all image files being flashed
  -l                lock the device after all image files being flashed
EOF

}

# parse command line
soc_name=""
device_character=""
card_size=0
slot=""
systemimage_file="system.img"
vendor_file="vendor.img"
partition_file="partition-table.img"
support_dtbo=0
support_recovery=0
support_dualslot=0
support_m4_os=0
boot_partition="boot"
recovery_partition="recovery"
system_partition="system"
vendor_partition="vendor"
vbmeta_partition="vbmeta"
dtbo_partition="dtbo"
m4_os_partition="m4_os"
flash_m4=0
lock=0
erase=0

while [ $# -gt 0 ]; do
    case $1 in
        -h) help; exit ;;
        -f) soc_name=$2; shift;;
        -c) card_size=$2; shift;;
        -d) device_character=$2 ; shift;;
        -a) slot="_a" ;;
        -b) slot="_b" ;;
        -m) flash_m4=1 ;;
        -e) erase=1 ;;
        -l) lock=1 ;;
        *)  help; exit;;
    esac
    shift
done

# if card_size is not correctly set, exit.
if [ ${card_size} -ne 0 ] && [ ${card_size} -ne 7 ] && [ ${card_size} -ne 14 ] && [ ${card_size} -ne 28 ]; then
    help; exit 1;
fi

function flash_partition
{
    if [ $? -eq 0 ]; then
        if [ $(echo ${1} | grep "system") != "" ] 2>/dev/null; then
            img_name=${systemimage_file}
        elif [ $(echo ${1} | grep "vendor") != "" ] 2>/dev/null; then
            img_name=${vendor_file}
        elif [ ${support_dtbo} -eq 1 ] && [ $(echo ${1} | grep "boot") != "" ] 2>/dev/null; then
            img_name="boot.img"
        elif [ $(echo ${1} | grep "m4_os") != "" ] 2>/dev/null; then
            img_name="${soc_name}_m4_demo.img"
        elif [ $(echo ${1} | grep -E "dtbo|vbmeta|recovery") != "" -a ${device_character} != "" ] 2>/dev/null; then
            img_name="${1%_*}-${soc_name}-${device_character}.img"
        else
            img_name="${1%_*}-${soc_name}.img"
        fi
        fastboot flash ${1} ${img_name}
    fi
}

function flash_userpartitions
{
    if [ ${support_dtbo} -eq 1 ]; then
        flash_partition ${dtbo_partition}
    fi

    flash_partition ${boot_partition}

    if [ ${support_recovery} -eq 1 ]; then
        flash_partition ${recovery_partition}
    fi

    flash_partition ${system_partition}
    flash_partition ${vendor_partition}
    flash_partition ${vbmeta_partition}
}

function flash_partition_name
{
    boot_partition="boot"${1}
    recovery_partition="recovery"${1}
    system_partition="system"${1}
    vendor_partition="vendor"${1}
    vbmeta_partition="vbmeta"${1}
    dtbo_partition="dtbo"${1}

}

function flash_android
{
    if [ ${card_size} -gt 0 ]; then
        partition_file="partition-table-${card_size}GB.img"
    fi
    bootloader_file="u-boot-${soc_name}.imx"

    if [ ${soc_name#imx8} != ${soc_name} ]; then
        fastboot flash bootloader0 ${bootloader_file}
    else
        fastboot flash bootloader ${bootloader_file}
    fi

    fastboot reboot bootloader
    sleep 5

    fastboot flash gpt ${partition_file}
    fastboot getvar all 2>/tmp/fastboot_var.log  && grep -q "dtbo" /tmp/fastboot_var.log && support_dtbo=1
    grep -q "recovery" /tmp/fastboot_var.log && support_recovery=1
    # use boot_b to check whether current gpt support a/b slot
    grep -q "boot_b" /tmp/fastboot_var.log && support_dualslot=1
    grep -q "m4_os" /tmp/fastboot_var.log && support_m4_os=1

    if [ ${flash_m4} = 1 -a ${support_m4_os} = 1 ]; then
        flash_partition ${m4_os_partition}
    fi

    if [ "${slot}" = "" ] && [ ${support_dualslot} -eq 1 ] ; then
        #flash image to a and b slot
        flash_partition_name "_a"
        flash_userpartitions

        flash_partition_name "_b"
        flash_userpartitions
    else
        flash_partition_name ${slot}
        flash_userpartitions
        if [ ${support_dualslot} -eq 1 ] ; then
            fastboot set_active ${slot#_}
        fi
    fi
}

flash_android

if [ ${erase} -eq 1 ]; then
    fastboot erase userdata
    if [ ${soc_name#imx8} = ${soc_name} ]; then
        fastboot erase misc
        fastboot erase cache
    fi
fi

if [ ${lock} -eq 1 ]; then
    fastboot oem lock
fi

echo
echo ">>>>>>>>>>>>>> Flashing successfully completed <<<<<<<<<<<<<<"

exit 0
