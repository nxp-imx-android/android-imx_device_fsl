#!/bin/bash

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
unpack_log_file="unpack.log"
./unpack_bootimg --boot_img ${boot_img} --out ${unpack_out_dir} > ${unpack_log_file}

key_os_version="os version: "
key_os_patch_level="os patch level: "
key_header_version="boot image header version: "

os_version=`grep "$key_os_version" $unpack_log_file`
os_version=${os_version#*${key_os_version}}
os_patch_level=`grep "$key_os_patch_level" $unpack_log_file`
os_patch_level=${os_patch_level#*${key_os_patch_level}}
header_version=`grep "$key_header_version" $unpack_log_file`
header_version=${header_version#*${key_header_version}}

echo "Replace ${Image} in ${boot_img} ..."
./mkbootimg --kernel ${Image} --ramdisk ${unpack_out_dir}/ramdisk --os_version ${os_version} --os_patch_level ${os_patch_level} \
    --header_version ${header_version} --output ${new_boot_img}

echo "Done: ${new_boot_img}"

# clear
rm -rf ${unpack_out_dir} ${unpack_log_file}
