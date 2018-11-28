:: This script is used for flashing i.MX android images whit fastboot.

:: Do not output the command
@echo off

::---------------------------------------------------------------------------------
::Variables
::---------------------------------------------------------------------------------

:: For batch script, %0 is not script name in a so-called function, so save the script name here
set script_first_argument=%0
:: For users execute this script in powershell, clear the quation marks first.
set script_first_argument=%script_first_argument:"=%
:: reserve last 13 characters, which is the lenght of the name of this script file.
set script_name=%script_first_argument:~-25%

set soc_name=
set device_character=
set /A card_size=0
set slot=
set bootimage=boot.img
set systemimage_file=system.img
set vendor_file=vendor.img
set partition_file=partition-table.img
set /A support_dtbo=0
set /A support_recovery=0
set /A support_dualslot=0
set /A support_m4_os=0
set bootloader_partition=
set boot_partition=boot
set recovery_partition=recovery
set system_partition=system
set vendor_partition=vendor
set vbmeta_partition=vbmeta
set dtbo_partition=dtbo
set m4_os_partition=m4_os
set /A flash_m4=0
set /A statisc=0
set /A erase=0
set image_directory=
set fastboot_tool=fastboot
set target_dev=emmc
set sdp=SDP
set /A uboot_env_start=0
set /A uboot_env_len=0
set board=
set imx7ulp_evk_m4_sf_start_byte=0
set imx7ulp_evk_m4_sf_length_byte=0x20000
set imx7ulp_stage_base_addr=0x60800000


::---------------------------------------------------------------------------------
:: Parse command line, since there is no syntax like "switch case" in bat file, 
:: the way to process the command line is a bit redundant, still, it can work.
::---------------------------------------------------------------------------------
:: If no option provied when executing this script, show help message and exit.
if [%1] == [] (
    echo please provide more information with command script options
    call :help
    goto :eof
)

:parse_loop
if [%1] == [] goto :parse_end
if %1 == -h call :help & goto :eof
if %1 == -f set soc_name=%2& shift & shift & goto :parse_loop
if %1 == -c set /A card_size=%2& shift & shift & goto :parse_loop
if %1 == -d set device_character=%2& shift & shift & goto :parse_loop
if %1 == -a set slot=_a& shift & goto :parse_loop
if %1 == -b set slot=_b& shift & goto :parse_loop
if %1 == -m set /A flash_m4=1 & shift & goto :parse_loop
if %1 == -e set /A erase=1 & shift & goto :parse_loop
if %1 == -D set image_directory=%2& shift & shift & goto :parse_loop
if %1 == -t set target_dev=%2&shift &shift & goto :parse_loop
if %1 == -p set board=%2&shift &shift & goto :parse_loop
echo an option you specified is not supported, please check it
call :help & exit 1
:parse_end


:: If sdcard size is not correctly set, exit
if %card_size% neq 0 set /A statisc+=1
if %card_size% neq 7 set /A statisc+=1
if %card_size% neq 14 set /A statisc+=1
if %card_size% neq 28 set /A statisc+=1
if %statisc% == 4 echo card_size is not a legal value & exit 1

if %card_size% gtr 0 set partition_file=partition-table-%card_size%GB.img

:: if directory is specified, and the last character is not backslash, add one backslash
if not [%image_directory%] == [] if not %image_directory:~-1% == \ (
    set image_directory=%image_directory%\
)

:: get device and board specific parameter, for now, this step can't make sure the soc_name is definitely correct
if not [%soc_name:imx8qm=%] == [%soc_name%] (
    set vid=0x1fc9& set pid=0x0129& set chip=MX8QM
    set uboot_env_start=0x2000& set uboot_env_len=0x10
    set emmc_num=0& set sd_num=1
    set board=mek
    goto :device_info_end
)
if not [%soc_name:imx8qxp=%] == [%soc_name%] (
    set vid=0x1fc9& set pid=0x012f& set chip=MX8QXP
    set uboot_env_start=0x2000& set uboot_env_len=0x10
    set emmc_num=0& set sd_num=1
    set board=mek
    goto :device_info_end
)
if not [%soc_name:imx8mq=%] == [%soc_name%] (
    set vid=0x1fc9& set pid=0x012b& set chip=MX8MQ
    set uboot_env_start=0x2000& set uboot_env_len=0x8
    set emmc_num=0& set sd_num=1
    set board=evk
    goto :device_info_end
)
if not [%soc_name:imx8mm=%] == [%soc_name%] (
    set vid=0x1fc9& set pid=00x0134& set chip=MX8MM
    set uboot_env_start=0x2000& set uboot_env_len=0x8
    set emmc_num=1& set sd_num=0
    set board=evk
    goto :device_info_end
)
if not [%soc_name:imx7ulp=%] == [%soc_name%] (
    set vid=0x1fc9& set pid=0x0126& set chip=MX7ULP
    set uboot_env_start=0x700& set uboot_env_len=0x10
    set sd_num=0
    set board=evk
    if [%target_dev%] == [emmc] (
        call :target_dev_not_support
    )
    goto :device_info_end
)
if not [%soc_name:imx7d=%] == [%soc_name%] (
    set vid=0x15a2& set pid=0x0076& set chip=MX7D
    set uboot_env_start=0x700& set uboot_env_len=0x10
    set sd_num=0
    set board=sabresd
    if [%target_dev%] == [emmc] (
        call :target_dev_not_support
    )
    goto :device_info_end
)
if not [%soc_name:imx6sx=%] == [%soc_name%] (
    set vid=0x15a2& set pid=0x0071& set chip=MX6SX
    set uboot_env_start=0x700& set uboot_env_len=0x10
    set sd_num=2
    set board=sabresd
    if [%target_dev%] == [emmc] (
        call :target_dev_not_support
    )
    goto :device_info_end
)
if not [%soc_name:imx6dl=%] == [%soc_name%] (
    set vid=0x15a2& set pid=0x0061& set chip=MX6DL
    set uboot_env_start=0x700& set uboot_env_len=0x10
    set emmc_num=2& set sd_num=1
    call :board_info_test
    if [%target_dev%] == [emmc] (
        if [%board%] == [sabreauto] call :target_dev_not_support
    )
    goto :device_info_end
)
if not [%soc_name:imx6q=%] == [%soc_name%] (
    set vid=0x15a2& set pid=0x0054& set chip=MX6Q
    set uboot_env_start=0x700& set uboot_env_len=0x10
    set emmc_num=2& set sd_num=1
    call :board_info_test
    if [%target_dev%] == [emmc] (
        if [%board%] == [sabreauto] call :target_dev_not_support
    )
    goto :device_info_end
)
echo please check whether the soc_name you specified is correct
call :help & exit 1
:device_info_end

:: set target_num based on target_dev
if [%target_dev%] == [emmc] (
    set target_num=%emmc_num%
)else (
    set target_num=%sd_num%
)

:: set sdp command name based on soc_name
if not [%soc_name:imx8q=%] == [%soc_name%] (
    set sdp=SDPS
)


::---------------------------------------------------------------------------------
:: Invoke function to flash android images
::---------------------------------------------------------------------------------
call :uuu_load_uboot

call :flash_android

:: make sure device is locked for boards don't use tee
%fastboot_tool% erase fbmisc || exit 1

if %erase% == 1 (
    %fastboot_tool% erase userdata || exit 1
    %fastboot_tool% erase misc || exit 1
    if %soc_name:imx8=% == %soc_name% (
        %fastboot_tool% erase cache || exit 1
    )
)

if not [%slot%] == [] if %support_dualslot% == 1 (
    %fastboot_tool% set_active %slot:~-1% || exit 1
)

echo #######ALL IMAGE FILES FLASHED#######


::---------------------------------------------------------------------------------
:: The execution will end.
::---------------------------------------------------------------------------------
goto :eof


::----------------------------------------------------------------------------------
:: Function definition
::----------------------------------------------------------------------------------

:help
echo.
echo Version: 1.1
echo Last change: erase fbmisc partiton even if -e option not used
echo current suport platforms: sabresd_6dq, sabreauto_6q, sabresd_6sx, evk_7ulp, sabresd_7d
echo                           evk_8mm, evk_8mq, mek_8q, mek_8q_car
echo.
echo eg: uuu_imx_android_flash.bat -f imx8qm -a -e -D C:\Users\user_01\images\2018.11.10\imx_pi9.0\mek_8q\
echo eg: uuu_imx_android_flash.bat -f imx6qp -e -D C:\Users\user_01\images\2018.11.10\imx_pi9.0\sabresd_6dq\ -p sabresd
echo.
echo Usage: %script_name% ^<option^>
echo.
echo options:
echo  -h                displays this help message
echo  -f soc_name       flash android image file with soc_name
echo  -a                only flash image to slot_a
echo  -b                only flash image to slot_b
echo  -c card_size      optional setting: 7 / 14 / 28
echo                        If not set, use partition-table.img (default)
echo                        If set to  7, use partition-table-7GB.img  for  8GB SD card
echo                        If set to 14, use partition-table-14GB.img for 16GB SD card
echo                        If set to 28, use partition-table-28GB.img for 32GB SD card
echo                    Make sure the corresponding file exist for your platform
echo  -m                flash m4 image
echo  -d dev            flash dtbo, vbmeta and recovery image file with dev
echo                        If not set, use default dtbo, vbmeta and recovery image
echo  -e                erase user data after all image files being flashed
echo  -D directory      the directory of of images
echo                        No need to use this option if images and this script are in same directory
echo  -t target_dev     emmc or sd, emmc is default target_dev, make sure target device exist
echo  -p board          specify board for imx6dl, imx6q, imx6qp, since they are in both sabresd and sabreauto
echo                        For imx6dl, imx6q, imx6qp, this is mandatory, other chips, no need to use this option
goto :eof

:target_dev_not_support
echo %soc_name%-%board% does not support %target_dev% as target device
echo change target device automatically
set target_dev=sd
goto :eof


:: test whether board info is specified for imx6dl, imx6q and imx6qp
:board_info_test
if [%board%] == [] (
    if [%device_character%] == [ldo] (
        set board=sabresd
    ) else (
        echo board info need to be specified for %soc_name% with -p option, it can be sabresd or sabreauto
        call :help & exit 1
    )
)
goto :eof

:uuu_load_uboot
uuu CFG: FB: -vid %vid% -pid %pid%
if [%device_character%] == [ldo] goto :load_uboot_device_character
if [%device_character%] == [epdc] goto :load_uboot_device_character
goto :load_uboot_no_device_character

:load_uboot_device_character
uuu %sdp%: boot -f .\u-boot-%soc_name%-%device_character%-%board%-uuu.imx
goto :load_uboot_device_character_end

:load_uboot_no_device_character
uuu %sdp%: boot -f .\u-boot-%soc_name%-%board%-uuu.imx
goto :load_uboot_device_character_end

:load_uboot_device_character_end

if not [%soc_name:imx8m=%] == [%soc_name%] (
    uuu SDPU: delay 1000
    uuu SDPU: write -f .\u-boot-%soc_name%-%board%-uuu.imx -offset 0x57c00
    uuu SDPU: jump
)
uuu FB: ucmd setenv fastboot_dev mmc
uuu FB: ucmd setenv mmcdev %target_num%
uuu FB: ucmd mmc dev %target_num%

:: erase environment variables of uboot
if [%target_dev%] == [emmc] (
    uuu FB: ucmd mmc dev %target_num% 0 || exit 1
)
uuu FB: ucmd mmc erase %uboot_env_start% %uboot_env_len%
if [%target_dev%] == [emmc] (
    uuu FB: ucmd mmc partconf %target_num% 1 1 1 || exit 1
)

goto :eof

:flash_partition
:: if there is slot information, delete it.
set local_str=%1
set local_str=%local_str:_a=%
set local_str=%local_str:_b=%

set img_name=%local_str%-%soc_name%.img

if not [%local_str:system=%] == [%local_str%] (
    set img_name=%systemimage_file%
    goto :start_to_flash
)
if not [%local_str:vendor=%] == [%local_str%] (
    set img_name=%vendor_file%
    goto :start_to_flash
)
if not [%local_str:m4_os=%] == [%local_str%] (
    set img_name=%soc_name%_m4_demo.img
    goto :start_to_flash
)
if not [%local_str:vbmeta=%] == [%local_str%] if not [%device_character%] == [] (
    set img_name=%local_str%-%soc_name%-%device_character%.img
    goto :start_to_flash
)
if not [%local_str:dtbo=%] == [%local_str%] if not [%device_character%] == [] (
    set img_name=%local_str%-%soc_name%-%device_character%.img
    goto :start_to_flash
)
if not [%local_str:recovery=%] == [%local_str%] if not [%device_character%] == [] (
    set img_name=%local_str%-%soc_name%-%device_character%.img
    goto :start_to_flash
)
if not [%local_str:bootloader=%] == [%local_str%] (
    if [%device_character%] == [ldo] goto :uboot_device_character
    if [%device_character%] == [epdc] goto :uboot_device_character
    goto :uboot_no_device_character

:uboot_device_character
    set img_name=u-boot-%soc_name%-%device_character%.imx
    goto :uboot_device_character_end

:uboot_no_device_character
    set img_name=u-boot-%soc_name%.imx
    goto :uboot_device_character_end

:uboot_device_character_end
    goto :start_to_flash
)


if %support_dtbo% == 1 (
    if not [%local_str:boot=%] == [%local_str%] (
        set img_name=%bootimage%
        goto :start_to_flash
    )
)

if not [%local_str:gpt=%] == [%local_str%] (
    set img_name=%partition_file%
    goto :start_to_flash
)

:start_to_flash
echo flash the file of %img_name% to the partition of %1
%fastboot_tool% flash %1 %image_directory%%img_name% || exit 1
goto :eof


:flash_userpartitions
if %support_dtbo% == 1 call :flash_partition %dtbo_partition%
if %support_recovery% == 1 call :flash_partition %recovery_partition%
call :flash_partition %boot_partition%
call :flash_partition %system_partition%
call :flash_partition %vendor_partition%
call :flash_partition %vbmeta_partition%
goto :eof


:flash_partition_name
set boot_partition=boot%1
set recovery_partition=recovery%1
set system_partition=system%1
set vendor_partition=vendor%1
set vbmeta_partition=vbmeta%1
set dtbo_partition=dtbo%1
goto :eof

:flash_android
:: for xen mode, no need to flash bootloader
if not [%device_character%] == [xen] (
    if not %soc_name:imx8=% == %soc_name% (
        set bootloader_partition=bootloader0
    ) else (
        set bootloader_partition=bootloader
    )
)
call :flash_partition %bootloader_partition%

call :flash_partition gpt

:: force to load the gpt just flashed, since for imx6 and imx7, we use uboot from BSP team,
:: so partition table is not automatically loaded after gpt partition is flashed.
uuu FB: ucmd setenv fastboot_dev sata
uuu FB: ucmd setenv fastboot_dev mmc

%fastboot_tool% getvar all 2> fastboot_var.log || exit 1

find "dtbo" fastboot_var.log > nul && set /A support_dtbo=1

find "recovery" fastboot_var.log > nul && set /A support_recovery=1

::use boot_b to check whether current gpt support a/b slot
find "boot_b" fastboot_var.log > nul && set /A support_dualslot=1

:: since imx7ulp uboot from bsp team is used for uuu, m4 os partiton for imx7ulp_evd doesn't exist here
find "m4_os" fastboot_var.log > nul && set /A support_m4_os=1


if %support_dualslot% == 0 (
    if not [%slot%] == [] (
        echo ab slot feature not supported, the slot you specified will be ignored
        set slot=
    )
)


if %flash_m4% == 1 if %support_m4_os% == 1 call :flash_partition %m4_os_partition%

::since imx7ulp use uboot for uuu from BSP team, if m4 need to be flashed, flash it here.
if [%soc_name%] == [imx7ulp] (
    if [%flash_m4%] == [1] (
        :: download m4 image to sdram
        %fastboot_tool% stage %image_directory%%soc_name%_m4_demo.img

        uuu FB: ucmd sf probe
        echo uuu_version 1.1.81 > m4.lst
        echo CFG: %sdp%: -chip %chip% -vid %vid% -pid %pid% >> m4.lst
        echo FB[-t 30000]: ucmd sf erase %imx7ulp_evk_m4_sf_start_byte% %imx7ulp_evk_m4_sf_length_byte% >> m4.lst
        echo FB[-t 30000]: ucmd sf write %imx7ulp_stage_base_addr% %imx7ulp_evk_m4_sf_start_byte% %imx7ulp_evk_m4_sf_length_byte% >> m4.lst
        echo FB: done >> m4.lst
        :: write the image to spi nor-flash
        echo flash the file of imx7ulp_m4_demo.img to the partition of m4_os
        uuu m4.lst
        del m4.lst
    )
)


if [%slot%] == [] (
    if %support_dualslot% == 1 (
:: flash image to both a and b slot
        call :flash_partition_name _a
        call :flash_userpartitions

        call :flash_partition_name _b
        call :flash_userpartitions
    ) else (
        call :flash_partition_name
        call :flash_userpartitions
    )
)
if not [%slot%] == [] (
    call :flash_partition_name %slot%
    call :flash_userpartitions
)


del fastboot_var.log

goto :eof
