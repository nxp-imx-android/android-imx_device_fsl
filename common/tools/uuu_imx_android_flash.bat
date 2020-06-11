:: Do not output the command
@echo off

echo This script is validated with uuu 1.3.124 version, it is recommended to align with this version.

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
set uboot_feature=
set dtb_feature=
set /A card_size=0
set slot=
set bootimage=boot.img
set systemimage_file=system.img
set vendor_file=vendor.img
set product_file=product.img
set partition_file=partition-table.img
set super_file=super.img
set /A support_dtbo=0
set /A support_recovery=0
set /A support_dualslot=0
set /A support_mcu_os=0
set /A support_trusty=0
set /A support_dynamic_partition=0
set boot_partition=boot
set recovery_partition=recovery
set system_partition=system
set vendor_partition=vendor
set product_partition=product
set vbmeta_partition=vbmeta
set dtbo_partition=dtbo
set mcu_os_partition=mcu_os
set super_partition=super
set /A flash_mcu=0
set /A statisc=0
set /A erase=0
set image_directory=

set target_dev=emmc
set sdp=SDP
set /A uboot_env_start=0
set /A uboot_env_len=0
set board=
set imx7ulp_evk_m4_sf_start_byte=0
set imx7ulp_evk_m4_sf_length_byte=0x20000
set imx7ulp_stage_base_addr=0x60800000
set imx8qm_stage_base_addr=0x98000000
set bootloader_used_by_uuu=
set bootloader_flashed_to_board=
set yocto_image=
set /A error_level=0
set /A intervene=0
set /A support_dual_bootloader=0
set dual_bootloader_partition=
set /A daemon_mode=0
set /A flag=1
set /A dryrun=0
set lpmake_system_image_a=
set lpmake_system_image_b=
set lpmake_vendor_image_a=
set lpmake_vendor_image_b=
set lpmake_product_image_a=
set lpmake_product_image_b=
set /A dont_generate_super=0


:: We want to detect illegal feature input to some extent. Here it's based on SoC names. Since an SoC may be on a
:: board running different set of images(android and automative for a example), so misuse the features of one set of
:: images when flash another set of images can not be detect early with this scenario.
set imx8mm_uboot_feature=dual trusty-dual 4g-evk-uuu 4g ddr4-evk-uuu ddr4 evk-uuu trusty-4g trusty-secure-unlock trusty
set imx8mn_uboot_feature=dual trusty-dual evk-uuu trusty-secure-unlock trusty ddr4-evk-uuu ddr4
set imx8mp_uboot_feature=dual trusty-dual evk-uuu trusty-secure-unlock trusty
set imx8mq_uboot_feature=dual trusty-dual evk-uuu trusty-secure-unlock trusty
set imx8qxp_uboot_feature=mek-uuu trusty-secure-unlock trusty secure-unlock c0 trusty-c0 mek-c0-uuu
set imx8qm_uboot_feature=mek-uuu trusty-secure-unlock trusty secure-unlock md hdmi
set imx7ulp_uboot_feature=evk-uuu

set imx8mm_dtb_feature=ddr4 m4 mipi-panel
set imx8mn_dtb_feature=mipi-panel rpmsg ddr4 ddr4-mipi-panel ddr4-rpmsg
set imx8mp_dtb_feature=rpmsg hdmi lvds-panel lvds mipi-panel
set imx8mq_dtb_feature=dual mipi-panel mipi
set imx8qxp_dtb_feature=
set imx8qm_dtb_feature=hdmi mipi-panel md xen
set imx7ulp_dtb_feature=evk-mipi evk mipi

::---------------------------------------------------------------------------------
:: Parse command line, since there is no syntax like "switch case" in bat file,
:: the way to process the command line is a bit redundant, still, it can work.
::---------------------------------------------------------------------------------
:: If no option provided when executing this script, show help message and exit.
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
if %1 == -u set uboot_feature=-%2& shift & shift & goto :parse_loop
if %1 == -d set dtb_feature=%2& shift & shift & goto :parse_loop
if %1 == -a set slot=_a& shift & goto :parse_loop
if %1 == -b set slot=_b& shift & goto :parse_loop
if %1 == -m set /A flash_mcu=1 & shift & goto :parse_loop
if %1 == -e set /A erase=1 & shift & goto :parse_loop
if %1 == -D set image_directory=%2& shift & shift & goto :parse_loop
if %1 == -t set target_dev=%2&shift &shift & goto :parse_loop
if %1 == -p set board=%2&shift &shift & goto :parse_loop
if %1 == -y set yocto_image=%2&shift &shift & goto :parse_loop
if %1 == -i set /A intervene=1 & shift & goto :parse_loop
if %1 == -daemon set /A daemon_mode=1 & shift & goto :parse_loop
if %1 == -dryrun set /A dryrun=1 & shift & goto :parse_loop
if %1 == -super set /A dont_generate_super=1 & shift & goto :parse_loop
echo unknown option "%1", please check it.
call :help & set /A error_level=1 && goto :exit
:parse_end


:: avoid substring judgement error
set uboot_feature_test=A%uboot_feature%

:: Process of the uboot_feature parameter
if not [%uboot_feature_test:trusty=%] == [%uboot_feature_test%] set /A support_trusty=1
if not [%uboot_feature_test:secure=%] == [%uboot_feature_test%] set /A support_trusty=1
if not [%uboot_feature_test:dual=%] == [%uboot_feature_test%] set /A support_dual_bootloader=1

:: TrustyOS can't boot from SD card
if [%target_dev%] == [sd] (
    if [%support_trusty%] equ [1] (
        echo can not boot up from SD with trusty enabled
        call :help & set /A error_level=1 && goto :exit
    )
)

:: -i option should not be used together with -daemon
if [%intervene%] equ [1] (
    if [%daemon_mode%] equ [1] (
        echo -daemon mode will be igonred
    )
)

:: if directory is specified, and the last character is not backslash, add one backslash
if not [%image_directory%] == [] if not %image_directory:~-1% == \ (
    set image_directory=%image_directory%\
)

:: If sdcard size is not correctly set, exit
if %card_size% neq 0 set /A statisc+=1
if %card_size% neq 7 set /A statisc+=1
if %card_size% neq 14 set /A statisc+=1
if %card_size% neq 28 set /A statisc+=1
if %statisc% == 4 echo card_size is not a legal value & set /A error_level=1 && goto :exit

:: dual bootloader support will use different gpt, this is only for imx8m
if [%support_dual_bootloader%] equ [1] (
    if not [%soc_name:imx8m=%] == [%soc_name%] (
        if %card_size% == 0 (
            set partition_file=partition-table-dual.img
        )else (
            set partition_file=partition-table-%card_size%GB-dual.img
        )
    )else (
        if %card_size% gtr 0 set partition_file=partition-table-%card_size%GB.img
    )
)else (
    if %card_size% gtr 0 set partition_file=partition-table-%card_size%GB.img
)


:: dump the partition table image file into text file and check whether some partition names are in it
if exist partition-table_1.txt (
    del partition-table_1.txt
)
certutil -encodehex %image_directory%%partition_file% partition-table_1.txt > nul
:: get the last column, it's ASCII character of the values in partition table file. none-printable value displays as a dot
if exist partition-table_2.txt (
    del partition-table_2.txt
)
:: put all the lines in a file into one line
for /f "tokens=17 delims= " %%I in (partition-table_1.txt) do echo %%I>> partition-table_2.txt
if exist partition-table_3.txt (
    del partition-table_3.txt
)
for /f "delims=" %%J in (partition-table_2.txt) do (
    set /p="%%J"<nul>>partition-table_3.txt 2>nul
)

:: check whether there is "bootloader_b" in partition file
find "b.o.o.t.l.o.a.d.e.r._.b." partition-table_3.txt > nul && set /A support_dual_bootloader=1 && echo dual bootloader is supported
:: check whether there is "dtbo" in partition file
find "d.t.b.o." partition-table_3.txt > nul && set /A support_dtbo=1 && echo dtbo is supported
:: check whether there is "recovery" in partition file
find "r.e.c.o.v.e.r.y." partition-table_3.txt > nul && set /A support_recovery=1 && echo recovery is supported
:: check whether there is "boot_b" in partition file
find "b.o.o.t._.b." partition-table_3.txt > nul && set /A support_dualslot=1 && echo dual slot is supported
:: check whether there is "super" in partition table
find "s.u.p.e.r." partition-table_3.txt > nul && set /A support_dynamic_partition=1 && echo dynamic partition is supported

del partition-table_1.txt
del partition-table_2.txt
del partition-table_3.txt

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
    if [%board%] == [] (
        set board=evk
    )
    goto :device_info_end
)
if not [%soc_name:imx8mm=%] == [%soc_name%] (
    set vid=0x1fc9& set pid=00x0134& set chip=MX8MM
    set uboot_env_start=0x2000& set uboot_env_len=0x8
    set emmc_num=2& set sd_num=1
    set board=evk
    goto :device_info_end
)
if not [%soc_name:imx8mn=%] == [%soc_name%] (
    set vid=0x1fc9& set pid=00x013e& set chip=MX8MN
    set uboot_env_start=0x2000& set uboot_env_len=0x8
    set emmc_num=2& set sd_num=1
    set board=evk
    goto :device_info_end
)
if not [%soc_name:imx8mp=%] == [%soc_name%] (
    set vid=0x1fc9& set pid=00x0146& set chip=MX8MP
    set uboot_env_start=0x2000& set uboot_env_len=0x8
    set emmc_num=2& set sd_num=1
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
call :help & set /A error_level=1 && goto :exit
:device_info_end

:: set target_num based on target_dev
if [%target_dev%] == [emmc] (
    set target_num=%emmc_num%
)else (
    set target_num=%sd_num%
)

:: check whether provided spl/bootloader/uboot feature is legal
set uboot_feature_no_pre_hyphen=%uboot_feature:~1%
if not [%uboot_feature%] == [] (
    setlocal enabledelayedexpansion
    call :whether_in_array uboot_feature_no_pre_hyphen %soc_name%_uboot_feature
    if !flag! neq 0 (
        echo illegal parameter "%uboot_feature_no_pre_hyphen%" for "-u" option
        call :help & set /A error_level=1 && goto :exit
    )
    endlocal
)

:: check whether provided dtb feature is legal
if not [%dtb_feature%] == [] (
    setlocal enabledelayedexpansion
    call :whether_in_array dtb_feature %soc_name%_dtb_feature
    if !flag! neq 0 (
        echo illegal parameter "%dtb_feature%" for "-d" option
        call :help & set /A error_level=1 && goto :exit
    )
    endlocal
)

:: set sdp command name based on soc_name, now imx8q, imx8mp and imx8mn need to
:: use SDPS.
if not [%soc_name:imx8q=%] == [%soc_name%] goto :with_sdps
if [%soc_name%] == [imx8mn] goto :with_sdps
if [%soc_name%] == [imx8mp] goto :with_sdps
goto :without_sdps
:with_sdps
set sdp=SDPS
:without_sdps

:: default bootloader image name
set bootloader_used_by_uuu=u-boot-%soc_name%-%board%-uuu.imx
set bootloader_flashed_to_board=u-boot-%soc_name%%uboot_feature%.imx


:: find the names of the bootloader used by uuu
if [%soc_name%] == [imx8mm] (
    if not [%uboot_feature_test:ddr4=%] == [%uboot_feature_test%] (
        set bootloader_used_by_uuu=u-boot-%soc_name%-ddr4-%board%-uuu.imx
    ) else (
        if not [%uboot_feature_test:4g=%] == [%uboot_feature_test%] (
            set bootloader_used_by_uuu=u-boot-%soc_name%-4g-%board%-uuu.imx
        )
    )
)

if [%soc_name%] == [imx8mn] (
    if not [%uboot_feature_test:ddr4=%] == [%uboot_feature_test%] (
        set bootloader_used_by_uuu=u-boot-%soc_name%-ddr4-%board%-uuu.imx
    )
)

if [%soc_name%] == [imx8qxp] (
    if not [%uboot_feature_test:c0=%] == [%uboot_feature_test%] (
        set bootloader_used_by_uuu=u-boot-%soc_name%-%board%-c0-uuu.imx
    )
)

::---------------------------------------------------------------------------------
:: Invoke function to flash android images
::---------------------------------------------------------------------------------
call :uuu_load_uboot || set /A error_level=1 && goto :exit

call :flash_android || set /A error_level=1 && goto :exit

:: flash yocto image along with mek_8qm auto xen images
if not [%yocto_image%] == [] (
    if [%soc_name%] == [imx8qm] (
        if [%dtb_feature%] == [xen] (
            setlocal enabledelayedexpansion
            set target_num=%sd_num%
            echo FB: ucmd setenv fastboot_dev mmc >> uuu.lst
            echo FB: ucmd setenv mmcdev !target_num! >> uuu.lst
            echo FB: ucmd mmc dev !target_num! >> uuu.lst
            :: flash the yocto image to "all" partition of SD card
            echo generate lines to flash %yocto_image% to the partition of all
            if exist yocto_image_with_xen_support.link (
                del yocto_image_with_xen_support.link
            )
            cmd /c mklink yocto_image_with_xen_support.link %yocto_image% > nul
            echo FB[-t 600000]: flash -raw2sparse all yocto_image_with_xen_support.link >> uuu.lst
            :: replace uboot from yocto team with the one from android team
            echo generate lines to flash u-boot-imx8qm-xen-dom0.imx to the partition of bootloader0 on SD card
            if exist u-boot-imx8qm-xen-dom0.imx.link (
                del u-boot-imx8qm-xen-dom0.imx.link
            )
            cmd /c mklink u-boot-imx8qm-xen-dom0.imx.link %image_directory%u-boot-imx8qm-xen-dom0.imx > nul
            echo FB: flash bootloader0 u-boot-imx8qm-xen-dom0.imx.link >> uuu.lst
            :: write the xen spl from android team to FAT on SD card
            set xen_uboot_name=spl-%soc_name%-%dtb_feature%.bin
            for /f "usebackq" %%A in ('%image_directory%!xen_uboot_name!') do set xen_uboot_size_dec=%%~zA
            :: directly pass the name of variable, just like pointer in C program
            call :dec_to_hex !xen_uboot_size_dec! xen_uboot_size_hex
            echo generate lines to write spl-%soc_name%-%dtb_feature%.bin to FAT on SD card
            if exist !xen_uboot_name!.link (
                del !xen_uboot_name!.link
            )
            cmd /c mklink !xen_uboot_name!.link %image_directory%!xen_uboot_name! > nul
            echo FB: ucmd setenv fastboot_buffer %imx8qm_stage_base_addr% >> uuu.lst
            echo FB: download -f !xen_uboot_name!.link >> uuu.lst
            echo FB: ucmd fatwrite mmc %sd_num% %imx8qm_stage_base_addr% !xen_uboot_name! 0x!xen_uboot_size_hex! >> uuu.lst

            set target_num=%emmc_num%
            echo FB: ucmd setenv fastboot_dev mmc >> uuu.lst
            echo FB: ucmd setenv mmcdev !target_num! >> uuu.lst
            echo FB: ucmd mmc dev !target_num! >> uuu.lst
            endlocal
        )
    ) else (
        echo -y option only applies for imx8qm xen images
        call :help & exit set /A error_level=1 && goto :exit
    )
)

echo FB[-t 600000]: erase misc>> uuu.lst

:: make sure device is locked for boards don't use tee
echo FB[-t 600000]: erase presistdata>> uuu.lst
echo FB[-t 600000]: erase fbmisc>> uuu.lst

if not [%slot%] == [] if %support_dualslot% == 1 (
    echo FB: set_active %slot:~-1%>> uuu.lst
)

if %erase% == 1 (
    if %support_recovery% == 1 (
        echo FB[-t 600000]: erase cache>> uuu.lst
    )
    echo FB[-t 600000]: erase userdata>> uuu.lst
)

echo FB: done >> uuu.lst

if [%dryrun%] == [1] (
    goto :exit
)

echo uuu script generated, start to invoke uuu with the generated uuu script

if %daemon_mode% equ 1 (
    uuu -d uuu.lst
) else (
    uuu uuu.lst
    del *.link
    del uuu.lst
)


::---------------------------------------------------------------------------------
:: The execution will end.
::---------------------------------------------------------------------------------
goto :eof


::----------------------------------------------------------------------------------
:: Function definition
::----------------------------------------------------------------------------------

:help
echo.
echo Version: 1.7
echo Last change: generate super.img when flash images with dynamic partition feature
echo currently suported platforms: evk_7ulp, evk_8mm, evk_8mq, evk_8mn, evk_8mp, aiy_8mq, mek_8q, mek_8q_car
echo.
echo eg: uuu_imx_android_flash.bat -f imx8qm -a -e -D C:\Users\user_01\images\android10\mek_8q\ -t emmc -u trusty -d mipi-panel
echo.
echo Usage: %script_name% ^<option^>
echo.
echo options:
echo  -h                displays this help message
echo  -f soc_name       flash android image file with soc_name
echo  -a                only flash image to slot_a
echo  -b                only flash image to slot_b
echo  -c card_size      optional setting: 14 / 28
echo                        If not set, use partition-table.img/partition-table-dual.img (default)
echo                        If set to 14, use partition-table-14GB.img for 16GB SD card
echo                        If set to 28, use partition-table-28GB.img/partition-table-28GB-dual.img for 32GB SD card
echo                    Make sure the corresponding file exist for your platform
echo  -m                flash mcu image
echo  -u uboot_feature  flash uboot or spl&bootloader image with "uboot_feature" in their names
echo                        For Standard Android:
echo                            If the parameter after "-u" option contains the string of "dual", then spl&bootloader image will be flashed,
echo                            otherwise uboot image will be flashed
echo                        For Android Automative:
echo                            only dual bootloader feature is supported, by default spl&bootloader image will be flashed
echo                        Below table lists the legal value supported now based on the soc_name provided:
echo                           ©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©Ð©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´
echo                           ©¦   soc_name     ©¦  legal parameter after "-u"                                                                          ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8mm       ©¦  dual trusty-dual 4g-evk-uuu 4g ddr4-evk-uuu ddr4 evk-uuu trusty-4g trusty-secure-unlock trusty      ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8mn       ©¦  dual trusty-dual evk-uuu trusty-secure-unlock trusty ddr4-evk-uuu ddr4                              ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8mp       ©¦  dual trusty-dual evk-uuu trusty-secure-unlock trusty                                                ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8mq       ©¦  dual trusty-dual evk-uuu trusty-secure-unlock                                                      ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8qxp      ©¦  mek-uuu trusty-secure-unlock trusty secure-unlock c0 trusty-c0 mek-c0-uuu                          ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8qm       ©¦  mek-uuu trusty-secure-unlock trusty secure-unlock md hdmi                                          ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx7ulp      ©¦  evk-uuu                                                                                             ©¦
echo                           ©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©Ø©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼
echo
echo  -d dtbo_feature   flash dtbo, vbmeta and recovery image file with "dtb_feature" in their names
echo                        If not set, default dtbo, vbmeta and recovery image will be flashed
echo                        Below table lists the legal value supported now based on the soc_name provided:
echo                           ©°©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©Ð©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©´
echo                           ©¦   soc_name     ©¦  legal parameter after "-d"                                                                          ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8mm       ©¦  ddr4 m4 mipi-panel                                                                                  ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8mn       ©¦  mipi-panel rpmsg ddr4 ddr4-mipi-panel ddr4-rpmsg                                                    ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8mp       ©¦  rpmsg hdmi lvds-panel lvds mipi-panel                                                               ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8mq       ©¦  dual mipi-panel mipi                                                                                ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8qxp      ©¦                                                                                                      ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx8qm       ©¦  hdmi mipi-panel md xen                                                                              ©¦
echo                           ©À©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©à©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©È
echo                           ©¦   imx7ulp      ©¦  evk-mipi evk mipi                                                                                   ©¦
echo                           ©¸©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©Ø©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¤©¼
echo
echo  -e                erase user data after all image files being flashed
echo  -D directory      the directory of of images
echo                        No need to use this option if images are in current working directory
echo  -t target_dev     emmc or sd, emmc is default target_dev, make sure target device exist
echo  -p board          specify board for imx6dl, imx6q, imx6qp and imx8mq, since more than one platform we maintain Android on use these chips
echo                        For imx6dl, imx6q, imx6qp, this is mandatory, it can be followed with sabresd or sabreauto
echo                        For imx8mq, this option is only used internally. No need for other users to use this option
echo                        For other chips, this option doesn't work
echo  -y yocto_image    flash yocto image together with imx8qm auto xen images. The parameter follows "-y" option should be a full path name
echo                        including the name of yocto sdcard image, this parameter could be a relative path or an absolute path
echo  -i                with this option used, after uboot for uuu loaded and executed to fastboot mode with target device chosen, this script will stop
echo                        This option is for users to manually flash the images to partitions they want to
echo  -daemon           after uuu script generated, uuu will be invoked with daemon mode. It is used for flash multi boards
echo  -dryrun           only generate the uuu script under /tmp direcbory but not flash images
echo  -super            do not generate super.img when flash the images with dynamic partition feature enabled.
echo                        Under the condition that dynamic partition feature are enabled:
echo                          if this option is not used, super.img will be generated under current working directory and flashed to the board.
echo                          if this option is used, make sure super.img already exists together with other images.
goto :eof


:: this function checks whether the value of first parameter is in the array value of second parameter.
:: pass the name of the (array)variable to this function. the first is potential element, the second one is array,
:: a global flag is used to store the result. make sure the first parameter is not empty
:whether_in_array
for /F "tokens=*" %%F in ('echo %%%1%%') do (
set potential_element=%%F
)

for /F "tokens=*" %%F in ('echo %%%2%%') do (
set array_passed_in=%%F
)

(for %%a in (%array_passed_in%) do (
   if %%a == %potential_element% (
        set /A flag=0
        goto :eof
   )
))
set /A flag=1
goto :eof


:target_dev_not_support
echo %soc_name%-%board% does not support %target_dev% as target device
echo change target device automatically
set target_dev=sd
goto :eof


:: test whether board info is specified for imx6dl, imx6q and imx6qp
:board_info_test
if [%board%] == [] (
    if [%dtb_feature%] == [ldo] (
        set board=sabresd
    ) else (
        echo board info need to be specified for %soc_name% with -p option, it can be sabresd or sabreauto
        call :help & set /A error_level=1 && goto :exit
    )
)
goto :eof

:uuu_load_uboot
echo uuu_version 1.3.74 > uuu.lst

if exist %bootloader_used_by_uuu%.link (
    del %bootloader_used_by_uuu%.link
)
cmd /c mklink %bootloader_used_by_uuu%.link %image_directory%%bootloader_used_by_uuu% > nul
echo %sdp%: boot -f %bootloader_used_by_uuu%.link >> uuu.lst


:: for uboot by uuu which enabled SPL
if not [%soc_name:imx8m=%] == [%soc_name%] (
    :: for images need SDPU
    echo SDPU: delay 1000 >> uuu.lst
    echo SDPU: write -f %bootloader_used_by_uuu%.link -offset 0x57c00 >> uuu.lst
    echo SDPU: jump >> uuu.lst
    :: for images need SDPV
    echo SDPV: delay 1000 >> uuu.lst
    echo SDPV: write -f %bootloader_used_by_uuu%.link -skipspl >> uuu.lst
    echo SDPV: jump >> uuu.lst
)

echo FB: ucmd setenv fastboot_dev mmc >> uuu.lst
echo FB: ucmd setenv mmcdev %target_num% >> uuu.lst
echo FB: ucmd mmc dev %target_num% >> uuu.lst

:: erase environment variables of uboot
if [%target_dev%] == [emmc] (
    echo FB: ucmd mmc dev %target_num% 0 >> uuu.lst
)
echo FB: ucmd mmc erase %uboot_env_start% %uboot_env_len% >> uuu.lst
if [%target_dev%] == [emmc] (
    echo FB: ucmd mmc partconf %target_num% 1 1 1 >> uuu.lst
)

if %intervene% == 1 (
:: in fact, it's not an error, but to align the behaviour of cmd and powershell, a non-zero error value is used.
    echo FB: done >> uuu.lst
    uuu uuu.lst
    set /A error_level=1 && goto :exit
)

goto :eof

:flash_partition
set partition_to_be_flashed=%1
:: if there is slot information, delete it.
set local_str=%1
set local_str=%local_str:_a=%
set local_str=%local_str:_b=%

set img_name=%local_str%-%soc_name%.img

if not [%partition_to_be_flashed:bootloader_=%] == [%partition_to_be_flashed%] (
    set img_name=%uboot_proper_to_be_flashed%
    goto :start_to_flash
)

if not [%partition_to_be_flashed:system=%] == [%partition_to_be_flashed%] (
    set img_name=%systemimage_file%
    goto :start_to_flash
)
if not [%partition_to_be_flashed:vendor=%] == [%partition_to_be_flashed%] (
    set img_name=%vendor_file%
    goto :start_to_flash
)
if not [%partition_to_be_flashed:product=%] == [%partition_to_be_flashed%] (
    set img_name=%product_file%
    goto :start_to_flash
)
if not [%partition_to_be_flashed:mcu_os=%] == [%partition_to_be_flashed%] (
    set img_name=%soc_name%_mcu_demo.img
    goto :start_to_flash
)
if not [%partition_to_be_flashed:vbmeta=%] == [%partition_to_be_flashed%] if not [%dtb_feature%] == [] (
    set img_name=%local_str%-%soc_name%-%dtb_feature%.img
    goto :start_to_flash
)
if not [%partition_to_be_flashed:dtbo=%] == [%partition_to_be_flashed%] if not [%dtb_feature%] == [] (
    set img_name=%local_str%-%soc_name%-%dtb_feature%.img
    goto :start_to_flash
)
if not [%partition_to_be_flashed:recovery=%] == [%partition_to_be_flashed%] if not [%dtb_feature%] == [] (
    set img_name=%local_str%-%soc_name%-%dtb_feature%.img
    goto :start_to_flash
)
if not [%partition_to_be_flashed:bootloader=%] == [%partition_to_be_flashed%] (
    set img_name=%bootloader_flashed_to_board%
    goto :start_to_flash
)
if not [%partition_to_be_flashed:super=%] == [%partition_to_be_flashed%] (
    if %dont_generate_super% == 0 (
        call :make_super_image
    )
    set img_name=%super_file%
    goto :start_to_flash
)


if %support_dtbo% == 1 (
    if not [%partition_to_be_flashed:boot=%] == [%partition_to_be_flashed%] (
        set img_name=%bootimage%
        goto :start_to_flash
    )
)

if not [%partition_to_be_flashed:gpt=%] == [%partition_to_be_flashed%] (
    set img_name=%partition_file%
    goto :start_to_flash
)

:start_to_flash
echo generate lines to flash %img_name% to the partition of %1
if [%img_name%] == [%super_file%] (
    if %dont_generate_super% == 0 (
        echo FB[-t 600000]: flash %1 %img_name% >> uuu.lst
    ) else (
        if exist %img_name%.link (
            del %img_name%.link
        )
        cmd /c mklink %img_name%.link %image_directory%%img_name% > nul
        echo FB[-t 600000]: flash %1 %img_name%.link >> uuu.lst
    )
) else (
    if exist %img_name%.link (
        del %img_name%.link
    )
    cmd /c mklink %img_name%.link %image_directory%%img_name% > nul
    echo FB[-t 600000]: flash %1 %img_name%.link >> uuu.lst
)
goto :eof


:flash_userpartitions
if %support_dual_bootloader% == 1 call :flash_partition %dual_bootloader_partition% || set /A error_level=1 && goto :exit
if %support_dtbo% == 1 call :flash_partition %dtbo_partition% || set /A error_level=1 && goto :exit
if %support_recovery% == 1 call :flash_partition %recovery_partition% || set /A error_level=1 && goto :exit
call :flash_partition %boot_partition% || set /A error_level=1 && goto :exit
if %support_dynamic_partition% == 0 ( 
    call :flash_partition %system_partition% || set /A error_level=1 && goto :exit
    call :flash_partition %vendor_partition% || set /A error_level=1 && goto :exit
    call :flash_partition %product_partition% || set /A error_level=1 && goto :exit
)
call :flash_partition %vbmeta_partition% || set /A error_level=1 && goto :exit
goto :eof


:flash_partition_name
set boot_partition=boot%1
set recovery_partition=recovery%1
set system_partition=system%1
set vendor_partition=vendor%1
set product_partition=product%1
set vbmeta_partition=vbmeta%1
set dtbo_partition=dtbo%1
if %support_dual_bootloader% == 1 set dual_bootloader_partition=bootloader%1
goto :eof

:flash_android

:: if dual bootloader is supported, the name of the bootloader flashed to the board need to be updated
if %support_dual_bootloader% == 1 (
    set bootloader_flashed_to_board=spl-%soc_name%%uboot_feature%.bin
    set uboot_proper_to_be_flashed=bootloader-%soc_name%%uboot_feature%.img
    :: # specially handle xen related condition
    if [%dtb_feature%] == [xen] (
        if [%soc_name%] == [imx8qm] (
            set uboot_proper_to_be_flashed=bootloader-%soc_name%-%dtb_feature%.img
        )
    )
)

:: for xen mode, no need to flash spl
if not [%dtb_feature%] == [xen] (
    if [%support_dualslot%] == [1]	(
        call :flash_partition bootloader0 || set /A error_level=1 && goto :exit
    ) else (
        call :flash_partition bootloader || set /A error_level=1 && goto :exit
    )
)

call :flash_partition gpt || set /A error_level=1 && goto :exit
:: force to load the gpt just flashed, since for imx6 and imx7, we use uboot from BSP team,
:: so partition table is not automatically loaded after gpt partition is flashed.
echo FB: ucmd setenv fastboot_dev sata >> uuu.lst
echo FB: ucmd setenv fastboot_dev mmc >> uuu.lst

if %support_dualslot% == 0 (
    if not [%slot%] == [] (
        echo ab slot feature not supported, the slot you specified will be ignored
        set slot=
    )
)

::since imx7ulp use uboot for uuu from BSP team, there is no hardcoded mcu_os partition. If m4 need to be flashed, flash it here.
if [%soc_name%] == [imx7ulp] (
    if [%flash_m4%] == [1] (
        :: download m4 image to sdram
        if exist %soc_name%_m4_demo.img.link (
            del %soc_name%_m4_demo.img.link
        )
        cmd /c mklink %soc_name%_m4_demo.img.link %image_directory%%soc_name%_m4_demo.img > nul
        echo generate lines to flash %soc_name%_m4_demo.img to the partition of m4_os
        echo FB: ucmd setenv fastboot_buffer %imx7ulp_stage_base_addr% >> uuu.lst
        echo FB: download -f %soc_name%_m4_demo.img.link >> uuu.lst
        echo FB: ucmd sf probe >> uuu.lst
        echo FB[-t 30000]: ucmd sf erase %imx7ulp_evk_m4_sf_start_byte% %imx7ulp_evk_m4_sf_length_byte% >> uuu.lst
        echo FB[-t 30000]: ucmd sf write %imx7ulp_stage_base_addr% %imx7ulp_evk_m4_sf_start_byte% %imx7ulp_evk_m4_sf_length_byte% >> uuu.lst
    )
) else (
    if %flash_mcu% == 1 call :flash_partition %mcu_os_partition%
)

if [%slot%] == [] (
    if %support_dualslot% == 1 (
:: flash image to both a and b slot
        call :flash_partition_name _a || set /A error_level=1 && goto :exit
        call :flash_userpartitions || set /A error_level=1 && goto :exit

        call :flash_partition_name _b || set /A error_level=1 && goto :exit
        call :flash_userpartitions || set /A error_level=1 && goto :exit
    ) else (
        call :flash_partition_name || set /A error_level=1 && goto :exit
        call :flash_userpartitions || set /A error_level=1 && goto :exit
    )
)
if not [%slot%] == [] (
    call :flash_partition_name %slot% || set /A error_level=1 && goto :exit
    call :flash_userpartitions || set /A error_level=1 && goto :exit
)

::super partition does not have a/b slot, handle it individually
if %support_dynamic_partition% == 1 (
    call :flash_partition %super_partition%
)

goto :eof

:dec_to_hex
set base_num=0123456789abcdef
(for /f "usebackq" %%A in ('%1') do call :post_dec_to_hex %%A) > temp_hex.txt
set /P %2=<temp_hex.txt
del temp_hex.txt
goto :eof
:post_dec_to_hex
set dec=%1
set hex=
setlocal enabledelayedexpansion
:division_modular_loop
set /a mod = dec %% 16,dec /= 16
set hex=!base_num:~%mod%,1!!hex!
if not [!dec!] == [0] (
    goto :division_modular_loop
)
echo !hex!
goto :eof

:: this function will invoke lpmake to create super.img, the super.img will
:: be created in current directory
:make_super_image
if exist %super_file% (
    del %super_file%
)
:: now dynamic partition is only enabled in dual slot condition
if %support_dualslot% == 1 (
    setlocal enabledelayedexpansion
    if [%slot%] == [_a] (
        set lpmake_system_image_a=--image system_a=%image_directory%%systemimage_file%
        set lpmake_vendor_image_a=--image vendor_a=%image_directory%%vendor_file%
        set lpmake_product_image_a=--image product_a=%image_directory%%product_file%
    )
    if [%slot%] == [_b] (
        set lpmake_system_image_b=--image system_b=%image_directory%%systemimage_file%
        set lpmake_vendor_image_b=--image vendor_b=%image_directory%%vendor_file%
        set lpmake_product_image_b=--image product_b=%image_directory%%product_file%
    )
    if [%slot%] == [] (
        set lpmake_system_image_a=--image system_a=%image_directory%%systemimage_file%
        set lpmake_vendor_image_a=--image vendor_a=%image_directory%%vendor_file%
        set lpmake_product_image_a=--image product_a=%image_directory%%product_file%
        set lpmake_system_image_b=--image system_b=%image_directory%%systemimage_file%
        set lpmake_vendor_image_b=--image vendor_b=%image_directory%%vendor_file%
        set lpmake_product_image_b=--image product_b=%image_directory%%product_file%
    )
    %image_directory%lpmake.exe --metadata-size 65536 --super-name super --metadata-slots 3 --device super:7516192768 ^
        --group nxp_dynamic_partitions_a:3747610624 --group nxp_dynamic_partitions_b:3747610624 ^
        --partition system_a:readonly:0:nxp_dynamic_partitions_a !lpmake_system_image_a! ^
        --partition system_b:readonly:0:nxp_dynamic_partitions_b !lpmake_system_image_b! ^
        --partition vendor_a:readonly:0:nxp_dynamic_partitions_a !lpmake_vendor_image_a! ^
        --partition vendor_b:readonly:0:nxp_dynamic_partitions_b !lpmake_vendor_image_b! ^
        --partition product_a:readonly:0:nxp_dynamic_partitions_a !lpmake_product_image_a! ^
        --partition product_b:readonly:0:nxp_dynamic_partitions_b !lpmake_product_image_b! ^
        --sparse --output !super_file!

::delete the temporary raw data files
    del %TMP%\TemporaryFile-*
)

goto :eof

:exit
exit /B %error_level%
