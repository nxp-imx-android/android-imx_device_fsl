#!/bin/bash -e

help() {

bn=`basename $0`
cat << EOF

Version: 1.7
Last change: generate super.img when flash images with dynamic partition feature
currently suported platforms: evk_7ulp, evk_8mm, evk_8mq, evk_8mn, aiy_8mq, evk_8mp, mek_8q, mek_8q_car

eg: ./uuu_imx_android_flash.sh -f imx8qm -a -e -D ~/android10/mek_8q/ -t emmc -u trusty -d mipi-panel

Usage: $bn <option>

options:
  -h                displays this help message
  -f soc_name       flash android image file with soc_name
  -a                only flash image to slot_a
  -b                only flash image to slot_b
  -c card_size      optional setting: 14 / 28
                        If not set, use partition-table.img/partition-table-dual.img (default)
                        If set to 14, use partition-table-14GB.img for 16GB SD card
                        If set to 28, use partition-table-28GB.img/partition-table-28GB-dual.img for 32GB SD card
                    Make sure the corresponding file exist for your platform
  -m                flash mcu image
  -u uboot_feature  flash uboot or spl&bootloader image with "uboot_feature" in their names
                        For Standard Android:
                            If the parameter after "-u" option contains the string of "dual", then spl&bootloader image will be flashed,
                            otherwise uboot image will be flashed
                        For Android Automative:
                            only dual bootloader feature is supported, by default spl&bootloader image will be flashed
                        Below table lists the legal value supported now based on the soc_name provided:
                           ┌────────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────────┐
                           │   soc_name     │  legal parameter after "-u"                                                                          │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mm       │  dual trusty-dual 4g-evk-uuu 4g ddr4-evk-uuu ddr4 evk-uuu trusty-4g trusty-secure-unlock trusty      │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mn       │  dual trusty-dual evk-uuu trusty-secure-unlock trusty ddr4-evk-uuu ddr4                              │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mq       │  dual trusty-dual evk-uuu trusty-secure-unlock trusty                                                │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mp       │  dual trusty-dual evk-uuu trusty-secure-unlock trusty                                                │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8qxp      │  mek-uuu trusty-secure-unlock trusty secure-unlock c0 trusty-c0 mek-c0-uuu                           │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8qm       │  mek-uuu trusty-secure-unlock trusty secure-unlock md hdmi                                           │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx7ulp      │  evk-uuu                                                                                             │
                           └────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────┘

  -d dtb_feature    flash dtbo, vbmeta and recovery image file with "dtb_feature" in their names
                        If not set, default dtbo, vbmeta and recovery image will be flashed
                        Below table lists the legal value supported now based on the soc_name provided:
                           ┌────────────────┬──────────────────────────────────────────────────────────────────────────────────────────────────────┐
                           │   soc_name     │  legal parameter after "-d"                                                                          │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mm       │  ddr4 m4 mipi-panel                                                                                  │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mn       │  mipi-panel rpmsg ddr4 ddr4-mipi-panel ddr4-rpmsg                                                    │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mq       │  dual mipi-panel mipi                                                                                │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mp       │  rpmsg hdmi lvds-panel lvds mipi-panel                                                               │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8qxp      │                                                                                                      │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8qm       │  hdmi mipi-panel md xen                                                                              │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx7ulp      │  evk-mipi evk mipi                                                                                   │
                           └────────────────┴──────────────────────────────────────────────────────────────────────────────────────────────────────┘

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
  -dryrun           only generate the uuu script under /tmp direcbory but not flash images
  -super            do not generate super.img when flash the images with dynamic partition feature enabled.
                       Under the condition that dynamic partition feature are enabled:
                         if this option is not used, super.img will be generated under "/tmp" and flashed to the board.
                         if this option is used, make sure super.img already exists together with other images.
EOF

}

# this function checks whether the value of first parameter is in the array value of second parameter
# pass the name of the (array)variable to this function. the first is potential element, the second one is array.
# make sure the first parameter is not empty
function whether_in_array
{
    local potential_element=`eval echo \$\{${1}\}`
    local array=(`eval echo \$\{${2}\[\*\]\}`)
    local array_length=${#array[*]}
    local last_element=${array[${array_length}-1]}

    for arg in ${array[*]}
    do
        if [ "${arg}" = "${potential_element}" ]; then
            result_value=0
            return 0
        fi
        if [ "${arg}" = "${last_element}" ]; then
            result_value=1
            return 0
        fi
    done
}

function uuu_load_uboot
{
    echo uuu_version 1.3.124 > /tmp/uuu.lst
    rm -f /tmp/${bootloader_used_by_uuu}
    ln -s ${sym_link_directory}${bootloader_used_by_uuu} /tmp/${bootloader_used_by_uuu}
    echo ${sdp}: boot -f ${bootloader_used_by_uuu} >> /tmp/uuu.lst
    # for uboot by uuu which enabled SPL
    if [[ ${soc_name#imx8m} != ${soc_name} ]]; then
        # for images need SDPU
        echo SDPU: delay 1000 >> /tmp/uuu.lst
        echo SDPU: write -f ${bootloader_used_by_uuu} -offset 0x57c00 >> /tmp/uuu.lst
        echo SDPU: jump >> /tmp/uuu.lst
        # for images need SDPV
        echo SDPV: delay 1000 >> /tmp/uuu.lst
        echo SDPV: write -f ${bootloader_used_by_uuu} -skipspl >> /tmp/uuu.lst
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
    elif [ "$(echo ${1} | grep "product")" != "" ]; then
        img_name=${product_file}
    elif [ "$(echo ${1} | grep "bootloader")" != "" ]; then
        img_name=${bootloader_flashed_to_board}

    elif [ ${support_dtbo} -eq 1 ] && [ "$(echo ${1} | grep "boot")" != "" ]; then
            img_name="boot.img"
    elif [ "$(echo ${1} | grep "mcu_os")" != "" ]; then
        img_name="${soc_name}_mcu_demo.img"
    elif [ "$(echo ${1} | grep -E "dtbo|vbmeta|recovery")" != "" -a "${dtb_feature}" != "" ]; then
        img_name="${1%_*}-${soc_name}-${dtb_feature}.img"
    elif [ "$(echo ${1} | grep "gpt")" != "" ]; then
        img_name=${partition_file}
    elif [ "$(echo ${1} | grep "super")" != "" ]; then
        if [ ${dont_generate_super} -eq 0 ]; then
            make_super_image
        fi
        img_name=${super_file}
    else
        img_name="${1%_*}-${soc_name}.img"
    fi

    echo -e generate lines to flash ${RED}${img_name}${STD} to the partition of ${RED}${1}${STD}
    if [ "${img_name}" != "${super_file}" ] || [ ${dont_generate_super} -eq 1 ]; then
        rm -f /tmp/${img_name}
        ln -s ${sym_link_directory}${img_name} /tmp/${img_name}
    fi
    echo FB[-t 600000]: flash ${1} ${img_name} >> /tmp/uuu.lst
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

    if [ ${support_dynamic_partition} -eq 0 ]; then
        flash_partition ${system_partition}
        flash_partition ${vendor_partition}
        flash_partition ${product_partition}
    fi
    flash_partition ${vbmeta_partition}
}

function flash_partition_name
{
    boot_partition="boot"${1}
    recovery_partition="recovery"${1}
    system_partition="system"${1}
    vendor_partition="vendor"${1}
    product_partition="product"${1}
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
        bootloader_flashed_to_board=spl-${soc_name}${uboot_feature}.bin
        uboot_proper_to_be_flashed=bootloader-${soc_name}${uboot_feature}.img
        # specially handle xen related condition
        if [[ "${soc_name}" = imx8qm ]] && [[ "${dtb_feature}" = xen ]]; then
            uboot_proper_to_be_flashed=bootloader-${soc_name}-${dtb_feature}.img
        fi
    fi

    # for xen, no need to flash spl
    if [[ "${dtb_feature}" != xen ]]; then
        if [ ${support_dualslot} -eq 1 ]; then
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

    # since imx7ulp use uboot for uuu from BSP team,there is no hardcoded mcu_os partition. If m4 need to be flashed, flash it here.
    if [[ ${soc_name} == imx7ulp ]] && [[ ${flash_mcu} -eq 1 ]]; then
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
        if [[ ${flash_mcu} -eq 1 ]]; then
            flash_partition ${mcu_os_partition}
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
    # super partition does not have a/b slot, handle it individually
    if [ ${support_dynamic_partition} -eq 1 ]; then
        flash_partition ${super_partition}
    fi
}

# this function will invoke lpmake to create super.img, the super.img will
# be created in /tmp, make sure that there is enouth space
function make_super_image
{
    rm -rf /tmp/${super_file}
    # now dynamic partition is only enabled in dual slot condition
    if [ ${support_dualslot} -eq 1 ]; then
        if [ "${slot}" == "_a" ]; then
            lpmake_system_image_a="--image system_a=${sym_link_directory}${systemimage_file}"
            lpmake_vendor_image_a="--image vendor_a=${sym_link_directory}${vendor_file}"
            lpmake_product_image_a="--image product_a=${sym_link_directory}${product_file}"
        elif [ "${slot}" == "_b" ]; then
            lpmake_system_image_b="--image system_b=${sym_link_directory}${systemimage_file}"
            lpmake_vendor_image_b="--image vendor_b=${sym_link_directory}${vendor_file}"
            lpmake_product_image_b="--image product_b=${sym_link_directory}${product_file}"
        else
            lpmake_system_image_a="--image system_a=${sym_link_directory}${systemimage_file}"
            lpmake_vendor_image_a="--image vendor_a=${sym_link_directory}${vendor_file}"
            lpmake_product_image_a="--image product_a=${sym_link_directory}${product_file}"
            lpmake_system_image_b="--image system_b=${sym_link_directory}${systemimage_file}"
            lpmake_vendor_image_b="--image vendor_b=${sym_link_directory}${vendor_file}"
            lpmake_product_image_b="--image product_b=${sym_link_directory}${product_file}"
        fi
    fi

        ${sym_link_directory}lpmake --metadata-size 65536 --super-name super --metadata-slots 3 --device super:7516192768 \
            --group nxp_dynamic_partitions_a:3747610624 --group nxp_dynamic_partitions_b:3747610624 \
            --partition system_a:readonly:0:nxp_dynamic_partitions_a ${lpmake_system_image_a} \
            --partition system_b:readonly:0:nxp_dynamic_partitions_b ${lpmake_system_image_b} \
            --partition vendor_a:readonly:0:nxp_dynamic_partitions_a ${lpmake_vendor_image_a} \
            --partition vendor_b:readonly:0:nxp_dynamic_partitions_b ${lpmake_vendor_image_b} \
            --partition product_a:readonly:0:nxp_dynamic_partitions_a ${lpmake_product_image_a} \
            --partition product_b:readonly:0:nxp_dynamic_partitions_b ${lpmake_product_image_b} \
            --sparse --output /tmp/${super_file}
}

# parse command line
soc_name=""
uboot_feature=""
dtb_feature=""
card_size=0
slot=""
systemimage_file="system.img"
vendor_file="vendor.img"
product_file="product.img"
partition_file="partition-table.img"
super_file="super.img"
support_dtbo=0
support_recovery=0
support_dualslot=0
support_mcu_os=0
support_trusty=0
support_dynamic_partition=0
boot_partition="boot"
recovery_partition="recovery"
system_partition="system"
vendor_partition="vendor"
product_partition="product"
vbmeta_partition="vbmeta"
dtbo_partition="dtbo"
mcu_os_partition="mcu_os"
super_partition="super"

flash_mcu=0
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
bootloader_used_by_uuu=""
bootloader_flashed_to_board=""
yocto_image=""
intervene=0
support_dual_bootloader=0
dual_bootloader_partition=""
current_working_directory=""
sym_link_directory=""
yocto_image_sym_link=""
daemon_mode=0
dryrun=0
lpmake_system_image_a=""
lpmake_system_image_b=""
lpmake_vendor_image_a=""
lpmake_vendor_image_b=""
lpmake_product_image_a=""
lpmake_product_image_b=""
result_value=0
dont_generate_super=0

# We want to detect illegal feature input to some extent. Here it's based on SoC names. Since an SoC may be on a
# board running different set of images(android and automative for a example), so misuse the features of one set of
# images when flash another set of images can not be detect early with this scenario.
imx8mm_uboot_feature=(dual trusty-dual 4g-evk-uuu 4g ddr4-evk-uuu ddr4 evk-uuu trusty-4g trusty-secure-unlock trusty)
imx8mn_uboot_feature=(dual trusty-dual evk-uuu trusty-secure-unlock trusty ddr4-evk-uuu ddr4)
imx8mq_uboot_feature=(dual trusty-dual evk-uuu trusty-secure-unlock trusty)
imx8mp_uboot_feature=(dual trusty-dual evk-uuu trusty-secure-unlock trusty)
imx8qxp_uboot_feature=(mek-uuu trusty-secure-unlock trusty secure-unlock c0 trusty-c0 mek-c0-uuu)
imx8qm_uboot_feature=(mek-uuu trusty-secure-unlock trusty secure-unlock md hdmi)
imx7ulp_uboot_feature=(evk-uuu)

imx8mm_dtb_feature=(ddr4 m4 mipi-panel)
imx8mn_dtb_feature=(mipi-panel rpmsg ddr4 ddr4-mipi-panel ddr4-rpmsg)
imx8mq_dtb_feature=(dual mipi-panel mipi)
imx8mp_dtb_feature=(rpmsg hdmi lvds-panel lvds mipi-panel)
imx8qxp_dtb_feature=()
imx8qm_dtb_feature=(hdmi mipi-panel md xen)
imx7ulp_dtb_feature=(evk-mipi evk mipi)


echo -e This script is validated with ${RED}uuu 1.3.124${STD} version, it is recommended to align with this version.

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
        -u) uboot_feature=-$2; shift;;
        -d) dtb_feature=$2; shift;;
        -a) slot="_a" ;;
        -b) slot="_b" ;;
        -m) flash_mcu=1 ;;
        -e) erase=1 ;;
        -D) image_directory=$2; shift;;
        -t) target_dev=$2; shift;;
        -y) yocto_image=$2; shift;;
        -p) board=$2; shift;;
        -i) intervene=1 ;;
        -daemon) daemon_mode=1 ;;
        -dryrun) dryrun=1 ;;
        -super) dont_generate_super=1 ;;
        *)  echo -e >&2 ${RED}the option \"${1}\"  you specified is not supported, please check it${STD}
            help; exit;;
    esac
    shift
done

# Process of the uboot_feature parameter
if [[ "${uboot_feature}" = *"trusty"* ]] || [[ "${uboot_feature}" = *"secure"* ]]; then
    support_trusty=1;
fi
if [[ "${uboot_feature}" = *"dual"* ]]; then
    support_dual_bootloader=1;
fi


# TrustyOS can't boot from SD card
if [ "${target_dev}" = "sd" ] && [ ${support_trusty} -eq 1 ]; then
    echo -e >&2 ${RED}can not boot up from SD with trusty enabled${STD};
    help; exit 1;
fi

# -i option should not be used together with -daemon
if [ ${intervene} -eq 1 ] && [ ${daemon_mode} -eq 1 ]; then
    echo -daemon mode will be igonred
fi

# for specified directory, make sure there is a slash at the end
if [[ "${image_directory}" != "" ]]; then
     image_directory="${image_directory%/}/";
fi

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


# if card_size is not correctly set, exit.
if [ ${card_size} -ne 0 ] && [ ${card_size} -ne 7 ] && [ ${card_size} -ne 14 ] && [ ${card_size} -ne 28 ]; then
    echo -e >&2 ${RED}card size ${card_size} is not legal${STD};
    help; exit 1;
fi

# dual bootloader support will use different gpt, this is only for imx8m
if [ ${support_dual_bootloader} -eq 1 ] && [[ ${soc_name#imx8m} != ${soc_name} ]]; then
    if [ ${card_size} -gt 0 ]; then
        partition_file="partition-table-${card_size}GB-dual.img";
    else
        partition_file="partition-table-dual.img";
    fi
else
    if [ ${card_size} -gt 0 ]; then
        partition_file="partition-table-${card_size}GB.img";
    else
        partition_file="partition-table.img";
    fi
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
# check whether there is "super" in partition table
grep "73 00 75 00 70 00 65 00 72 00" /tmp/partition-table_3.txt > /dev/null \
        && support_dynamic_partition=1 && echo dynamic parttition is supported


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
            emmc_num=2; sd_num=1;
            board=evk ;;
    imx8mn)
            vid=0x1fc9; pid=0x0134; chip=MX8MN;
            uboot_env_start=0x2000; uboot_env_len=0x8;
            emmc_num=2; sd_num=1;
            board=evk ;;
    imx8mp)
            vid=0x1fc9; pid=0x0146; chip=MX8MP;
            uboot_env_start=0x2000; uboot_env_len=0x8;
            emmc_num=2; sd_num=1;
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
    if [[ "$(echo ${dtb_feature} | grep "ldo")" != "" ]]; then
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

# check whether provided spl/bootloader/uboot feature is legal
if [ -n "${uboot_feature}" ]; then
    uboot_feature_no_pre_hyphen=${uboot_feature#-}
    whether_in_array uboot_feature_no_pre_hyphen ${soc_name}_uboot_feature
    if [ ${result_value} != 0 ]; then
        echo -e >&2 ${RED}illegal parameter \"${uboot_feature_no_pre_hyphen}\" for \"-u\" option${STD}
        help; exit 1;
    fi
fi

# check whether provided dtb feature is legal
if [ -n "${dtb_feature}" ]; then
    dtb_feature_no_pre_hyphen=${dtb_feature#-}
    whether_in_array dtb_feature_no_pre_hyphen ${soc_name}_dtb_feature
    if [ ${result_value} != 0 ]; then
        echo -e >&2 ${RED}illegal parameter \"${dtb_feature}\" for \"-d\" option${STD}
        help; exit 1;
    fi
fi

# set sdp command name based on soc_name
if [[ ${soc_name#imx8q} != ${soc_name} ]] || [[ ${soc_name} == "imx8mn" ]] || [[ ${soc_name} == "imx8mp" ]]; then
    sdp="SDPS"
fi

# default bootloader image name
bootloader_used_by_uuu=u-boot-${soc_name}-${board}-uuu.imx
bootloader_flashed_to_board="u-boot-${soc_name}${uboot_feature}.imx"

# find the names of the bootloader used by uuu
if [ "${soc_name}" = imx8mm ] || [ "${soc_name}" = imx8mn ]; then
    if [[ "${uboot_feature}" = *"ddr4"* ]]; then
        bootloader_used_by_uuu=u-boot-${soc_name}-ddr4-${board}-uuu.imx
    elif [[ "${uboot_feature}" = *"4g"* ]]; then
        bootloader_used_by_uuu=u-boot-${soc_name}-4g-${board}-uuu.imx
    fi
fi

if [ "${soc_name}" = imx8qxp ]; then
    if [[ "${uboot_feature}" = *"c0"* ]]; then
        bootloader_used_by_uuu=u-boot-${soc_name}-${board}-c0-uuu.imx
    fi
fi



uuu_load_uboot

flash_android

# flash yocto image along with mek_8qm auto xen images
if [[ "${yocto_image}" != "" ]]; then
    if [ ${soc_name} != "imx8qm" ] || [ "${dtb_feature}" != "xen" ]; then
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

    xen_uboot_size_dec=`wc -c ${image_directory}spl-${soc_name}-${dtb_feature}.bin | cut -d ' ' -f1`
    xen_uboot_size_hex=`echo "obase=16;${xen_uboot_size_dec}" | bc`
    # write the xen spl from android team to FAT on SD card
    echo -e generate lines to write ${RED}spl-${soc_name}-${dtb_feature}.bin${STD} to ${RED}FAT${STD}
    rm -f /tmp/spl-${soc_name}-${dtb_feature}.bin
    ln -s ${sym_link_directory}spl-${soc_name}-${dtb_feature}.bin /tmp/spl-${soc_name}-${dtb_feature}.bin
    echo FB: ucmd setenv fastboot_buffer ${imx8qm_stage_base_addr} >> /tmp/uuu.lst
    echo FB: download -f spl-${soc_name}-${dtb_feature}.bin >> /tmp/uuu.lst
    echo FB: ucmd fatwrite mmc ${sd_num} ${imx8qm_stage_base_addr} spl-${soc_name}-${dtb_feature}.bin 0x${xen_uboot_size_hex} >> /tmp/uuu.lst

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

if [ ${dryrun} -eq 1 ]; then
    exit
fi

echo "uuu script generated, start to invoke uuu with the generated uuu script"
if [ ${daemon_mode} -eq 1 ]; then
    uuu -d /tmp/uuu.lst
else
    uuu /tmp/uuu.lst
fi

exit 0
