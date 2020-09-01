#!/bin/bash

BOARD_KERNEL_OFFSET=0x00080000
help()
{
    echo "Usage: Using Image to replace old one in boot.img, then generate new_boot.img"
    echo "       $0 -b boot.img -i Image -o new_boot.img"
    echo "           boot.img    : old android boot image"
    echo "           Image       : new kernel Image"
    echo "           new_boot.img: new android boot image"
    echo " "
    echo "       Note:"
    echo "           This script depends on two binaries: unpack_bootimg and mkbootimg."
    echo "           Both of them are built from ANDROID source code: mmm system/tools/mkbootimg."
    echo "           Then copy them from out/host/linux/bin to current directory."
}

if [ $# -lt 6 ]; then
    help
    exit 1;
fi

while getopts 'b:i:o:h' OPTION; do
  case "$OPTION" in
    b) boot_img="$OPTARG"
       ;;
    i) Image="$OPTARG"
       ;;
    o) new_boot_img="$OPTARG"
       ;;
    h) help
      exit 1;
      ;;
  esac
done

if [ ! -f ${boot_img} -o ! -f ${Image} ]; then
    echo "Can't find ${boot_img} or ${Image}"
	help
	exit 1;
fi

unpack_out_dir="unpack_out"
unpack_log_temp_file="unpack.log.tmp"
unpack_log_file="unpack.log"

./unpack_bootimg --boot_img ${boot_img} --out ${unpack_out_dir} > ${unpack_log_temp_file}
# remove all invisible characters
sed $'s/[^[:print:]\t]//g' ${unpack_log_temp_file} > ${unpack_log_file}
rm ${unpack_log_temp_file}

key_os_version="os version: "
key_os_patch_level="os patch level: "
key_header_version="boot image header version: "
key_cmdline="command line args: "
key_additional_cmdline="additional command line args: "
key_kernel_load_address="kernel load address: "
key_ramdisk_load_address="ramdisk load address: "

os_version=`grep "$key_os_version" $unpack_log_file`
os_version=${os_version#*${key_os_version}}
os_patch_level=`grep "$key_os_patch_level" $unpack_log_file`
os_patch_level=${os_patch_level#*${key_os_patch_level}}"-05"
header_version=`grep "$key_header_version" $unpack_log_file`
header_version=${header_version#*${key_header_version}}
cmdline=`grep "$key_cmdline" $unpack_log_file | grep -v "${key_additional_cmdline}"`
cmdline=${cmdline#*${key_cmdline}}
kernel_load_address=`grep "$key_kernel_load_address" $unpack_log_file`
kernel_load_address=${kernel_load_address#*${key_kernel_load_address}}
ramdisk_load_address=`grep "$key_ramdisk_load_address" $unpack_log_file`
ramdisk_load_address=${ramdisk_load_address#*${key_ramdisk_load_address}}
kernel_offset=${BOARD_KERNEL_OFFSET}
board_kernel_base=$((${kernel_load_address}-${kernel_offset}))
ramdisk_offset=$((${ramdisk_load_address}-${board_kernel_base}))

echo "os version: $os_version"
echo "os patch level: $os_patch_level"
echo "header version: $header_version"

echo "Replace ${Image} in ${boot_img} ..."
if [ ${header_version} != "3" ]; then
    echo "cmdline: $cmdline"
    echo "kernel load address: $kernel_load_address"
    echo "ramdisk load address: $ramdisk_load_address"
    echo "kernel offset: $kernel_offset"
    echo "ramdisk offset: $ramdisk_offset"

    ./mkbootimg --kernel ${Image} --ramdisk ${unpack_out_dir}/ramdisk --os_version ${os_version} --os_patch_level ${os_patch_level} \
    --header_version ${header_version} --cmdline "${cmdline}" --base ${board_kernel_base} --kernel_offset ${kernel_offset} \
    --ramdisk_offset ${ramdisk_offset} --output ${new_boot_img}
else
    ./mkbootimg --kernel ${Image} --ramdisk ${unpack_out_dir}/ramdisk --os_version ${os_version} --os_patch_level ${os_patch_level} \
    --header_version ${header_version} --output ${new_boot_img}
fi

echo "Done: ${new_boot_img}"

# clear
rm -rf ${unpack_out_dir} ${unpack_log_file}
