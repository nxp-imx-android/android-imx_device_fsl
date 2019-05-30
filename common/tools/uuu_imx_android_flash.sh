#!/bin/bash -e

help() {

bn=`basename $0`
cat << EOF

Version: 1.3
Last change: generate uuu script first and then use the generated uuu script to flash images
currently suported platforms: sabresd_6dq, sabreauto_6q, sabresd_6sx, evk_7ulp, sabresd_7d
                              evk_8mm, evk_8mq, evk_8mn, aiy_8mq, mek_8q, mek_8q_car

eg: ./uuu_imx_android_flash.sh -f imx8qm -a -e -D ~/nfs/179/2018.11.10/imx_pi9.0/mek_8q/
eg: ./uuu_imx_android_flash.sh -f imx6qp -e -D ~/nfs/187/maddev_pi9.0/out/target/product/sabresd_6dq/ -p sabresd

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
  -D directory      the directory of images
                        No need to use this option if images are in current working directory
  -t target_dev     emmc or sd, emmc is default target_dev, make sure target device exist
  -p board          specify board for imx6dl, imx6q, imx6qp and imx8mq, since more than one platform we maintain Android on use these chips
                        For imx6dl, imx6q, imx6qp, this is mandatory, it can be followed with sabresd or sabreauto
                        For imx8mq, this option is only used internally. No need for other users to use this option
                        For other chips, this option doesn't work
  -y yocto_image    flash yocto image together with imx8qm auto xen images. The parameter follows "-y" option should be a full path name
                        including the name of yocto sdcard image, this parameter could be a relative path or an absolute path
  -i                with this option used, after uboot for uuu loaded and executed to fastboot mode with target device chosen, this script will stop
                        This option is for users to manually flash the images to partitions they want to
  -daemon           after uuu script generated, uuu will be invoked with daemon mode. It is used for flash multi boards
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
erase=0
image_directory=""
target_dev="emmc"
RED='\033[0;31m'
STD='\033[0;0m'
sdp="SDP"
uboot_env_start=0
uboot_env_len=0
board=""
imx7ulp_evk_m4_sf_start=0
imx7ulp_evk_m4_sf_length=256
imx7ulp_evk_sf_blksz=512
imx7ulp_stage_base_addr=0x60800000
imx8qm_stage_base_addr=0x98000000
bootloader_usbd_by_uuu=""
bootloader_flashed_to_board=""
yocto_image=""
intervene=0
support_dual_bootloader=0
dual_bootloader_partition=""
current_working_directory=""
sym_link_directory=""
yocto_image_sym_link=""
daemon_mode=0

echo -e This script is validated with ${RED}uuu 1.2.135${STD} version, please align with this version.

if [ $# -eq 0 ]; then
    echo -e >&2 ${RED}please provide more information with command script options${STD}
    help
    exit
fi

while [ $# -gt 0 ]; do
    case $1 in
        -h) help; exit ;;
        -f) soc_name=$2; shift;;
        -c) card_size=$2; shift;;
        -d) device_character=$2; shift;;
        -a) slot="_a" ;;
        -b) slot="_b" ;;
        -m) flash_m4=1 ;;
        -e) erase=1 ;;
        -D) image_directory=$2; shift;;
        -t) target_dev=$2; shift;;
        -y) yocto_image=$2; shift;;
        -p) board=$2; shift;;
        -i) intervene=1 ;;
        -daemon) daemon_mode=1 ;;
        *)  echo -e >&2 ${RED}an option you specified is not supported, please check it${STD}
            help; exit;;
    esac
    shift
done

# -i option should not be used together with -daemon
if [ ${intervene} -eq 1 ] && [ ${daemon_mode} -eq 1 ]; then
    echo -daemon mode will be igonred
fi

# for specified directory, make sure there is a slash at the end
if [[ "${image_directory}" != "" ]]; then
     image_directory="${image_directory%/}/";
fi

# if card_size is not correctly set, exit.
if [ ${card_size} -ne 0 ] && [ ${card_size} -ne 7 ] && [ ${card_size} -ne 14 ] && [ ${card_size} -ne 28 ]; then
    echo -e >&2 ${RED}card size ${card_size} is not legal${STD};
    help; exit 1;
fi


if [ ${card_size} -gt 0 ]; then
    partition_file="partition-table-${card_size}GB.img";
fi

# dump the partition table image file into text file and check whether some partition names are in it
hexdump -C -v ${image_directory}${partition_file} > /tmp/partition-table_1.txt
# get the 2nd to 17th colunmns, it's hex value in text mode for partition table file
awk '{for(i=2;i<=17;i++) printf $i" "; print ""}' /tmp/partition-table_1.txt > /tmp/partition-table_2.txt
# put all the lines in a file into one line
sed ':a;N;$!ba;s/\n//g' /tmp/partition-table_2.txt > /tmp/partition-table_3.txt

# check whether there is "bootloader_b" in partition file
grep "62 00 6f 00 6f 00 74 00 6c 00 6f 00 61 00 64 00 65 00 72 00 5f 00 62 00" /tmp/partition-table_3.txt > /dev/null \
        && support_dual_bootloader=1 && echo dual bootloader is supported
# check whether there is "dtbo" in partition file
grep "64 00 74 00 62 00 6f 00" /tmp/partition-table_3.txt > /dev/null \
        && support_dtbo=1 && echo dtbo is supported
# check whether there is "recovery" in partition file
grep "72 00 65 00 63 00 6f 00 76 00 65 00 72 00 79 00" /tmp/partition-table_3.txt > /dev/null \
        && support_recovery=1 && echo recovery is supported
# check whether there is "boot_b" in partition file
grep "62 00 6f 00 6f 00 74 00 5f 00 61 00" /tmp/partition-table_3.txt > /dev/null \
        && support_dualslot=1 && echo dual slot is supported

# for conditions that the path specified is current working directory or no path specified
if [[ "${image_directory}" == "" ]] || [[ "${image_directory}" == "./" ]]; then
    sym_link_directory=`pwd`;
    sym_link_directory="${sym_link_directory%/}/";
# for conditions that absolute path is specified
elif [[ "${image_directory#/}" != "${image_directory}" ]] || [[ "${image_directory#~}" != "${image_directory}" ]]; then
    sym_link_directory=${image_directory};
# for other relative path specified
else
    sym_link_directory=`pwd`;
    sym_link_directory="${sym_link_directory%/}/";
    sym_link_directory=${sym_link_directory}${image_directory}
fi


# if absolute path is used
if [[ "${yocto_image#/}" != "${yocto_image}" ]] || [[ "${yocto_image#~}" != "${yocto_image}" ]]; then
    yocto_image_sym_link=${yocto_image}
# if other relative path is used
else
    yocto_image_sym_link=`pwd`;
    yocto_image_sym_link="${yocto_image_sym_link%/}/";
    yocto_image_sym_link=${yocto_image_sym_link}${yocto_image}
fi

# get device and board specific parameter
case ${soc_name%%-*} in
    imx8qm)
            vid=0x1fc9; pid=0x0129; chip=MX8QM;
            uboot_env_start=0x2000; uboot_env_len=0x10;
            emmc_num=0; sd_num=1;
            board=mek ;;
    imx8qxp)
            vid=0x1fc9; pid=0x012f; chip=MX8QXP;
            uboot_env_start=0x2000; uboot_env_len=0x10;
            emmc_num=0; sd_num=1;
            board=mek ;;
    imx8mq)
            vid=0x1fc9; pid=0x012b; chip=MX8MQ;
            uboot_env_start=0x2000; uboot_env_len=0x8;
            emmc_num=0; sd_num=1;
            if [ -z "$board" ]; then
                board=evk;
            fi ;;
    imx8mm)
            vid=0x1fc9; pid=0x0134; chip=MX8MM;
            uboot_env_start=0x2000; uboot_env_len=0x8;
            emmc_num=1; sd_num=0;
            board=evk ;;
    imx8mn)
            vid=0x1fc9; pid=0x0134; chip=MX8MN;
            uboot_env_start=0x2000; uboot_env_len=0x8;
            emmc_num=1; sd_num=0;
            board=evk ;;
    imx7ulp)
            vid=0x1fc9; pid=0x0126; chip=MX7ULP;
            uboot_env_start=0x700; uboot_env_len=0x10;
            sd_num=0;
            board=evk ;;
    imx7d)
            vid=0x15a2; pid=0x0076; chip=MX7D;
            uboot_env_start=0x700; uboot_env_len=0x10;
            sd_num=0;
            board=sabresd ;;
    imx6sx)
            vid=0x15a2; pid=0x0071; chip=MX6SX;
            uboot_env_start=0x700; uboot_env_len=0x10;
            sd_num=2;
            board=sabresd ;;
    imx6dl)
            vid=0x15a2; pid=0x0061; chip=MX6D;
            uboot_env_start=0x700; uboot_env_len=0x10;
            emmc_num=2; sd_num=1 ;;
    imx6q)
            vid=0x15a2; pid=0x0054; chip=MX6Q;
            uboot_env_start=0x700; uboot_env_len=0x10;
            emmc_num=2; sd_num=1 ;;
    imx6qp)
            vid=0x15a2; pid=0x0054; chip=MX6Q;
            uboot_env_start=0x700; uboot_env_len=0x10;
            emmc_num=2; sd_num=1 ;;
    *)

            echo -e >&2 ${RED}the soc_name you specified is not supported${STD};
            help; exit 1;
esac

# test whether board info is specified for imx6dl, imx6q and imx6qp
if [[ "${board}" == "" ]]; then
    if [[ "$(echo ${device_character} | grep "ldo")" != "" ]]; then
            board=sabresd;

        else
            echo -e >&2 ${RED}board info need to be specified for imx6dl, imx6q and imx6qp with -p option, it can be sabresd or sabreauto${STD};
            help; exit 1;
        fi
fi

# test whether target device is supported
if [ ${soc_name#imx7} != ${soc_name} ] || [ ${soc_name#imx6} != ${soc_name} -a ${board} = "sabreauto" ] \
    || [ ${soc_name#imx6} != ${soc_name} -a ${soc_name} = "imx6sx" ]; then
    if [ ${target_dev} = "emmc" ]; then
        echo -e >&2 ${soc_name}-${board} does not support emmc as target device, \
                change target device automatically;
        target_dev=sd;
    fi
fi

# set target_num based on target_dev
if [[ ${target_dev} = "emmc" ]]; then
    target_num=${emmc_num};
else
    target_num=${sd_num};
fi

# set sdp command name based on soc_name
if [[ ${soc_name#imx8q} != ${soc_name} ]] || [[ ${soc_name} == "imx8mn" ]]; then
    sdp="SDPS"
fi

# find the names of the bootloader used by uuu and flashed to board
if [[ "${device_character}" == "ldo" ]] || [[ "${device_character}" == "epdc" ]] || \
        [[ "${device_character}" == "ddr4" ]]; then
    bootloader_usbd_by_uuu=u-boot-${soc_name}-${device_character}-${board}-uuu.imx
    bootloader_flashed_to_board="u-boot-${soc_name}-${device_character}.imx"
else
    bootloader_usbd_by_uuu=u-boot-${soc_name}-${board}-uuu.imx
    bootloader_flashed_to_board=u-boot-${soc_name}.imx
fi

function uuu_load_uboot
{
    echo uuu_version 1.2.135 > /tmp/uuu.lst
    rm -f /tmp/${bootloader_usbd_by_uuu}
    ln -s ${sym_link_directory}${bootloader_usbd_by_uuu} /tmp/${bootloader_usbd_by_uuu}
    echo ${sdp}: boot -f ${bootloader_usbd_by_uuu} >> /tmp/uuu.lst
    if [[ ${soc_name#imx8m} != ${soc_name} ]]; then
        # for images need SDPU
        echo SDPU: delay 1000 >> /tmp/uuu.lst
        echo SDPU: write -f ${bootloader_usbd_by_uuu} -offset 0x57c00 >> /tmp/uuu.lst
        echo SDPU: jump >> /tmp/uuu.lst
        # for images need SDPV
        echo SDPV: delay 1000 >> /tmp/uuu.lst
        echo SDPV: write -f ${bootloader_usbd_by_uuu} -skipspl >> /tmp/uuu.lst
        echo SDPV: jump >> /tmp/uuu.lst
    fi
    echo FB: ucmd setenv fastboot_dev mmc >> /tmp/uuu.lst
    echo FB: ucmd setenv mmcdev ${target_num} >> /tmp/uuu.lst
    echo FB: ucmd mmc dev ${target_num} >> /tmp/uuu.lst

    # erase environment variables of uboot
    if [[ ${target_dev} = "emmc" ]]; then
        echo FB: ucmd mmc dev ${target_num} 0 >> /tmp/uuu.lst
    fi
    echo FB: ucmd mmc erase ${uboot_env_start} ${uboot_env_len} >> /tmp/uuu.lst

    if [[ ${target_dev} = "emmc" ]]; then
        echo FB: ucmd mmc partconf ${target_num} 1 1 1 >> /tmp/uuu.lst
    fi

    if [[ ${intervene} -eq 1 ]]; then
        echo FB: done >> /tmp/uuu.lst
        uuu /tmp/uuu.lst
        exit 0
    fi
}

function flash_partition
{
    if [ "$(echo ${1} | grep "bootloader_")" != "" ]; then
        img_name=${uboot_proper_to_be_flashed}
    elif [ "$(echo ${1} | grep "system")" != "" ]; then
        img_name=${systemimage_file}
    elif [ "$(echo ${1} | grep "vendor")" != "" ]; then
        img_name=${vendor_file}
    elif [ "$(echo ${1} | grep "bootloader")" != "" ]; then
        img_name=${bootloader_flashed_to_board}

    elif [ ${support_dtbo} -eq 1 ] && [ "$(echo ${1} | grep "boot")" != "" ]; then
            img_name="boot.img"
    elif [ "$(echo ${1} | grep "m4_os")" != "" ]; then
        img_name="${soc_name}_m4_demo.img"
    elif [ "$(echo ${1} | grep -E "dtbo|vbmeta|recovery")" != "" -a "${device_character}" != "" ]; then
        img_name="${1%_*}-${soc_name}-${device_character}.img"
    elif [ "$(echo ${1} | grep "gpt")" != "" ]; then
        img_name=${partition_file}
    else
        img_name="${1%_*}-${soc_name}.img"
    fi

    echo -e generate lines to flash ${RED}${img_name}${STD} to the partition of ${RED}${1}${STD}
    rm -f /tmp/${img_name}
    ln -s ${sym_link_directory}${img_name} /tmp/${img_name}
    echo FB: flash ${1} ${img_name} >> /tmp/uuu.lst
}

function flash_userpartitions
{
    if [ ${support_dual_bootloader} -eq 1 ]; then
        flash_partition ${dual_bootloader_partition}
    fi
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
    if [ ${support_dual_bootloader} -eq 1 ]; then
        dual_bootloader_partition=bootloader${1}
    fi
}

function flash_android
{
    # if dual bootloader is supported, the name of the bootloader flashed to the board need to be updated
    if [ ${support_dual_bootloader} -eq 1 ]; then
        bootloader_flashed_to_board=spl-${soc_name}.bin
        if [[ "${soc_name}" = imx8qm ]] && [[ "${device_character}" = xen ]]; then
            uboot_proper_to_be_flashed=bootloader-${soc_name}-${device_character}.img
        else
            uboot_proper_to_be_flashed=bootloader-${soc_name}.img
        fi
    fi

    # for xen, no need to flash spl
    if [[ "${device_character}" != xen ]]; then
        if [ ${soc_name#imx8} != ${soc_name} ]; then
            flash_partition "bootloader0"
        else
            flash_partition "bootloader"
        fi
    fi

    flash_partition "gpt"
    # force to load the gpt just flashed, since for imx6 and imx7, we use uboot from BSP team,
    # so partition table is not automatically loaded after gpt partition is flashed.
    echo FB: ucmd setenv fastboot_dev sata >> /tmp/uuu.lst
    echo FB: ucmd setenv fastboot_dev mmc >> /tmp/uuu.lst

    # if a platform doesn't support dual slot but a slot is selected, ignore it.
    if [ ${support_dualslot} -eq 0 ] && [ "${slot}" != "" ]; then
        echo -e >&2 ${RED}ab slot feature not supported, the slot you specified will be ignored${STD}
        slot=""
    fi

    # since imx7ulp use uboot for uuu from BSP team,there is no hardcoded m4_os partition. If m4 need to be flashed, flash it here.
    if [[ ${soc_name} == imx7ulp ]] && [[ ${flash_m4} -eq 1 ]]; then
        # download m4 image to dram
        rm -f /tmp/${soc_name}_m4_demo.img
        ln -s ${sym_link_directory}${soc_name}_m4_demo.img /tmp/${soc_name}_m4_demo.img
        echo -e generate lines to flash ${RED}${soc_name}_m4_demo.img${STD} to the partition of ${RED}m4_os${STD}
        echo FB: ucmd setenv fastboot_buffer ${imx7ulp_stage_base_addr} >> /tmp/uuu.lst
        echo FB: download -f ${soc_name}_m4_demo.img >> /tmp/uuu.lst

        echo FB: ucmd sf probe >> /tmp/uuu.lst
        echo FB[-t 30000]: ucmd sf erase `echo "obase=16;$((${imx7ulp_evk_m4_sf_start}*${imx7ulp_evk_sf_blksz}))" | bc` \
                `echo "obase=16;$((${imx7ulp_evk_m4_sf_length}*${imx7ulp_evk_sf_blksz}))" | bc` >> /tmp/uuu.lst

        echo FB[-t 30000]: ucmd sf write ${imx7ulp_stage_base_addr} `echo "obase=16;$((${imx7ulp_evk_m4_sf_start}*${imx7ulp_evk_sf_blksz}))" | bc` \
                `echo "obase=16;$((${imx7ulp_evk_m4_sf_length}*${imx7ulp_evk_sf_blksz}))" | bc` >> /tmp/uuu.lst
    else
        if [[ ${flash_m4} -eq 1 ]]; then
            flash_partition ${m4_os_partition}
        fi
    fi

    if [ "${slot}" = "" ] && [ ${support_dualslot} -eq 1 ]; then
        #flash image to a and b slot
        flash_partition_name "_a"
        flash_userpartitions

        flash_partition_name "_b"
        flash_userpartitions
    else
        flash_partition_name ${slot}
        flash_userpartitions
    fi
}

uuu_load_uboot

flash_android

# flash yocto image along with mek_8qm auto xen images
if [[ "${yocto_image}" != "" ]]; then
    if [ ${soc_name} != "imx8qm" ] || [ "${device_character}" != "xen" ]; then
        echo -e >&2 ${RED}-y option only applies for imx8qm xen images${STD}
        help; exit 1;
    fi

    target_num=${sd_num}
    echo FB: ucmd setenv fastboot_dev mmc >> /tmp/uuu.lst
    echo FB: ucmd setenv mmcdev ${target_num} >> /tmp/uuu.lst
    echo FB: ucmd mmc dev ${target_num} >> /tmp/uuu.lst
    echo -e generate lines to flash ${RED}`basename ${yocto_image}`${STD} to the partition of ${RED}all${STD}
    rm -f /tmp/`basename ${yocto_image}`
    ln -s ${yocto_image_sym_link} /tmp/`basename ${yocto_image}`
    echo FB[-t 600000]: flash -raw2sparse all `basename ${yocto_image}` >> /tmp/uuu.lst
    # replace uboot from yocto team with the one from android team
    echo -e generate lines to flash ${RED}u-boot-imx8qm-xen-dom0.imx${STD} to the partition of ${RED}bootloader0${STD} on SD card
    rm -f /tmp/u-boot-imx8qm-xen-dom0.imx
    ln -s ${sym_link_directory}u-boot-imx8qm-xen-dom0.imx /tmp/u-boot-imx8qm-xen-dom0.imx
    echo FB: flash bootloader0 u-boot-imx8qm-xen-dom0.imx >> /tmp/uuu.lst

    xen_uboot_size_dec=`wc -c ${image_directory}spl-${soc_name}-${device_character}.bin | cut -d ' ' -f1`
    xen_uboot_size_hex=`echo "obase=16;${xen_uboot_size_dec}" | bc`
    # write the xen spl from android team to FAT on SD card
    echo -e generate lines to write ${RED}spl-${soc_name}-${device_character}.bin${STD} to ${RED}FAT${STD}
    rm -f /tmp/spl-${soc_name}-${device_character}.bin
    ln -s ${sym_link_directory}spl-${soc_name}-${device_character}.bin /tmp/spl-${soc_name}-${device_character}.bin
    echo FB: ucmd setenv fastboot_buffer ${imx8qm_stage_base_addr} >> /tmp/uuu.lst
    echo FB: download -f spl-${soc_name}-${device_character}.bin >> /tmp/uuu.lst
    echo FB: ucmd fatwrite mmc ${sd_num} ${imx8qm_stage_base_addr} spl-${soc_name}-${device_character}.bin 0x${xen_uboot_size_hex} >> /tmp/uuu.lst

    target_num=${emmc_num}
    echo FB: ucmd setenv fastboot_dev mmc >> /tmp/uuu.lst
    echo FB: ucmd setenv mmcdev ${target_num} >> /tmp/uuu.lst
    echo FB: ucmd mmc dev ${target_num} >> /tmp/uuu.lst
fi

echo FB[-t 600000]: erase misc >> /tmp/uuu.lst

# make sure device is locked for boards don't use tee
echo FB[-t 600000]: erase presistdata >> /tmp/uuu.lst
echo FB[-t 600000]: erase fbmisc >> /tmp/uuu.lst

if [ "${slot}" != "" ] && [ ${support_dualslot} -eq 1 ]; then
    echo FB: set_active ${slot#_} >> /tmp/uuu.lst
fi

if [ ${erase} -eq 1 ]; then
    if [ ${support_recovery} -eq 1 ]; then
        echo FB[-t 600000]: erase cache >> /tmp/uuu.lst
    fi
    echo FB[-t 600000]: erase userdata >> /tmp/uuu.lst
fi

echo FB: done >> /tmp/uuu.lst

echo "uuu script generated, start to invoke uuu with the generated uuu script"
if [ ${daemon_mode} -eq 1 ]; then
    uuu -d /tmp/uuu.lst
else
    uuu /tmp/uuu.lst
fi

exit 0
