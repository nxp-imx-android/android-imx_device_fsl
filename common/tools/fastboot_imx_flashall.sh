#!/bin/bash -e

help() {

bn=`basename $0`
cat << EOF

Version: 1.5
Last change: generate super.img when flash images with dynamic partition feature

eg: sudo ./fastboot_imx_flashall.sh -f imx8mm -a -D ~/android10/evk_8mm/
eg: sudo ./fastboot_imx_flashall.sh -f imx7ulp -D ~/android10/evk_7ulp/

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
                           │   imx8mp       │  dual trusty-dual evk-uuu trusty-secure-unlock trusty                                                │
                           ├────────────────┼──────────────────────────────────────────────────────────────────────────────────────────────────────┤
                           │   imx8mq       │  dual trusty-dual evk-uuu trusty-secure-unlock trusty                                                │
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
  -l                lock the device after all image files being flashed
  -D directory      the directory of images
                        No need to use this option if images are in current working directory
  -s ser_num        the serial number of board
                        If only one board connected to computer, no need to use this option
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

function flash_partition
{
    if [ ${support_dual_bootloader} -eq 1 ] && [ "$(echo ${1} | grep "bootloader_")" != "" ]; then
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
    elif [ "$(echo ${1} | grep `echo ${mcu_os_partition}`)" != "" ]; then
        if [ "${soc_name}" = "imx7ulp" ]; then
            img_name="${soc_name}_m4_demo.img"
        else
            img_name="${soc_name}_mcu_demo.img"
        fi
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

    echo -e flash the file of ${GREEN}${img_name}${STD} to the partition of ${GREEN}${1}${STD}
    if [ "${img_name}" = "${super_file}" ] && [ ${dont_generate_super} -eq 0 ]; then
        ${fastboot_tool} flash ${1} "/tmp/${img_name}"
    else
        ${fastboot_tool} flash ${1} "${image_directory}${img_name}"
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
}

function flash_android
{
    # a precondition: the location of gpt partition and the partition for uboot or spl(in dual bootloader condition)
    # should be the same for the u-boot just boot up the board and the on to be flashed to the board
    flash_partition "gpt"

    ${fastboot_tool} getvar all 2>/tmp/fastboot_var.log
    grep -q "bootloader_a" /tmp/fastboot_var.log && support_dual_bootloader=1
    grep -q "dtbo" /tmp/fastboot_var.log && support_dtbo=1
    grep -q "recovery" /tmp/fastboot_var.log && support_recovery=1
    # use boot_b to check whether current gpt support a/b slot
    grep -q "boot_b" /tmp/fastboot_var.log && support_dualslot=1
    grep -q "super" /tmp/fastboot_var.log && support_dynamic_partition=1

    # some partitions are hard-coded in uboot, flash the uboot first and then reboot to check these partitions

    # uboot or spl&bootloader
    if [ ${support_dual_bootloader} -eq 1 ]; then
        bootloader_flashed_to_board="spl-${soc_name}${uboot_feature}.bin"
        uboot_proper_to_be_flashed="bootloader-${soc_name}${uboot_feature}.img"
    else
        bootloader_flashed_to_board="u-boot-${soc_name}${uboot_feature}.imx"
    fi

    # in the source code, if AB slot feature is supported, uboot partition name is bootloader0, otherwise it's bootloader
    if [ ${support_dualslot} -eq 1 ]; then
         flash_partition "bootloader0"
    else
         flash_partition "bootloader"
    fi

    # if a platform doesn't support dual slot but a slot is selected, ignore it.
    if [ ${support_dualslot} -eq 0 ] && [ "${slot}" != "" ]; then
        slot=""
    fi


    #if dual-bootloader feature is supported, we need to flash the u-boot proper then reboot to get hard-coded partition info
    if [ ${support_dual_bootloader} -eq 1 ]; then
        if [ "${slot}" != "" ]; then
            dual_bootloader_partition="bootloader"${slot}
            flash_partition ${dual_bootloader_partition}
            ${fastboot_tool} set_active ${slot#_}
        else
            dual_bootloader_partition="bootloader_a"
            flash_partition ${dual_bootloader_partition}
            dual_bootloader_partition="bootloader_b"
            flash_partition ${dual_bootloader_partition}
            ${fastboot_tool} set_active a
        fi
    fi

    # full uboot is flashed to the board and active slot is set, reboot to u-boot fastboot boot command
    ${fastboot_tool} reboot bootloader
    sleep 5

    ${fastboot_tool} getvar all 2>/tmp/fastboot_var.log
    grep -q `echo ${mcu_os_partition}` /tmp/fastboot_var.log && support_mcu_os=1

    if [ ${flash_mcu} -eq 1 -a ${support_mcu_os} -eq 1 ]; then
        flash_partition ${mcu_os_partition}
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
            lpmake_system_image_a="--image system_a=${image_directory}${systemimage_file}"
            lpmake_vendor_image_a="--image vendor_a=${image_directory}${vendor_file}"
            lpmake_product_image_a="--image product_a=${image_directory}${product_file}"
        elif [ "${slot}" == "_b" ]; then
            lpmake_system_image_b="--image system_b=${image_directory}${systemimage_file}"
            lpmake_vendor_image_b="--image vendor_b=${image_directory}${vendor_file}"
            lpmake_product_image_b="--image product_b=${image_directory}${product_file}"
        else
            lpmake_system_image_a="--image system_a=${image_directory}${systemimage_file}"
            lpmake_vendor_image_a="--image vendor_a=${image_directory}${vendor_file}"
            lpmake_product_image_a="--image product_a=${image_directory}${product_file}"
            lpmake_system_image_b="--image system_b=${image_directory}${systemimage_file}"
            lpmake_vendor_image_b="--image vendor_b=${image_directory}${vendor_file}"
            lpmake_product_image_b="--image product_b=${image_directory}${product_file}"
        fi
    fi

    ${image_directory}lpmake --metadata-size 65536 --super-name super --metadata-slots 3 --device super:7516192768 \
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
support_dual_bootloader=0
support_dynamic_partition=0
dual_bootloader_partition=""
bootloader_flashed_to_board=""
uboot_proper_to_be_flashed=""
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
lock=0
erase=0
image_directory=""
ser_num=""
fastboot_tool="fastboot"
RED='\033[0;31m'
STD='\033[0;0m'
GREEN='\033[0;32m'
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

# an array to collect the supported soc_names
supported_soc_names=(imx8qm imx8qxp imx8mq imx8mm imx8mn imx8mp imx7ulp)

if [ $# -eq 0 ]; then
    echo -e ${RED}no parameter specified, will directly exit after displaying help message${STD}
    help; exit 1;
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
        -l) lock=1 ;;
        -D) image_directory=$2; shift;;
        -s) ser_num=$2; shift;;
        -super) dont_generate_super=1 ;;
        *)  echo -e ${RED}$1${STD} is not an illegal option
            help; exit;;
    esac
    shift
done

# check whether the soc_name is legal or not
if [ -n "${soc_name}" ]; then
    whether_in_array soc_name supported_soc_names
    if [ ${result_value} != 0 ]; then
        echo -e >&2 ${RED}illegal soc_name \"${soc_name}\"${STD}
        help; exit 1;
    fi
else
    echo -e >&2 ${RED}use \"-f\" option to specify the soc name${STD}
fi


# Process of the uboot_feature parameter
if [[ "${uboot_feature}" = *"dual"* ]]; then
    support_dual_bootloader=1;
fi

# if card_size is not correctly set, exit.
if [ ${card_size} -ne 0 ] && [ ${card_size} -ne 7 ] && [ ${card_size} -ne 14 ] && [ ${card_size} -ne 28 ]; then
    help; exit 1;
fi

# Android Automative by default support dual bootloader, no "dual" in its partition table name
if [ ${support_dual_bootloader} -eq 1 ]; then
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

# if directory is specified, make sure there is a slash at the end
if [[ "${image_directory}" = "" ]]; then
    image_directory=`pwd`
fi
image_directory="${image_directory%/}/"

if [[ "${ser_num}" != "" ]]; then
    fastboot_tool="fastboot -s ${ser_num}"
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

flash_android

if [ ${erase} -eq 1 ]; then
    if [ ${support_dualslot} -eq 0 ] ; then
        ${fastboot_tool} erase cache
    fi
    ${fastboot_tool} erase misc
    ${fastboot_tool} erase userdata
fi

if [ ${lock} -eq 1 ]; then
    ${fastboot_tool} oem lock
fi

if [ ${support_dualslot} -eq 1 ] && [ "${slot}" != "" ]; then
    ${fastboot_tool} set_active ${slot#_}
fi

echo
echo ">>>>>>>>>>>>>> Flashing successfully completed <<<<<<<<<<<<<<"

exit 0

