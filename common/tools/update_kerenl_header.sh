#!/bin/bash

# usage: cd android_dir & ./common/tools/update_kerenl_header.sh
# if user add imx special user header file, you can use below way to update:
# cd android_dir & touch device/fsl/common/kernel-headers/linux/new_uapi &
# ./common/tools/update_kerenl_header.sh

bionic_uapi_tool_path="bionic/libc/kernel/tools"
bionic_kernel_header_path="bionic/libc/kernel/uapi/linux"
imx_kernel_header_path="device/fsl/common/kernel-headers/linux/"

function prepare_work
{
mkdir -p imx_kernel/common
cp -r vendor/nxp-opensource/kernel_imx/* imx_kernel/common/.
}

function clean_work
{
cd external/kernel-headers
git checkout .
git clean -df
cd ../../
cd bionic
git checkout .
git clean -df
cd ../
rm imx_kernel -rf
}

prepare_work

${bionic_uapi_tool_path}/generate_uapi_headers.sh --use-kernel-dir imx_kernel
${bionic_uapi_tool_path}/update_all.py

for file in $(ls ${imx_kernel_header_path})
do
    cp ${bionic_kernel_header_path}/$file device/fsl/common/kernel-headers/linux/.
done

clean_work
