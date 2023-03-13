#!/usr/bin/env python

import yaml
import sys
import os
import re
import shutil

"""raised when the target file to create already exists"""
class File_Already_Exists_Exception(Exception):
    pass


def copy_file_based_on_configuration(reference_file, target_file, target_modules):
    """check whether the target file already exists"""
    if os.path.exists(target_file):
        raise File_Already_Exists_Exception('target file %s already exists'%os.path.split(target_file)[1])
    current_block_is_enabled = True
    with open(reference_file, 'r') as reference_file_fd:
        reference_file_lines = reference_file_fd.readlines()
        with open(target_file, 'w') as target_file_fd:
            for line in reference_file_lines:
                if re.search('#\s-{7}@block_.*-{7}', line):
                    """related to block_declaration line format"""
                    current_block = line[16:-8]
                    if target_modules.get(current_block) and target_modules[current_block] == 'y':
                        current_block_is_enabled = True
                    else:
                        current_block_is_enabled = False

                for file in modified_file_list:
                    if file in line:
                        line = line.replace(reference_product['soc_type'].lower(), target_product['soc_type'].lower())

                """for disabled modules, copy those lines with a '#' at the begining for debug purpose"""
                if current_block_is_enabled == True:
                    target_file_fd.writelines(line)
                else:
                    if re.match(r'^\s*[^#]', line):
                        target_file_fd.writelines("#" + line)
                    else:
                        target_file_fd.writelines(line)

def copy_directory(reference_directory, target_directory):
    if os.path.exists(target_directory):
        raise File_Already_Exists_Exception('target directory %s already exists'%os.path.split(target_directory)[1])

    shutil.copytree(reference_directory, target_directory)


def copy_repo_common_file():
    print('copy repo common files')
    if not os.path.exists(target_product_common_dir):
        os.makedirs(target_product_common_dir)

    reference_dir = os.path.join(os.path.split(reference_product_common_dir)[0], 'common')
    target_dir = os.path.join(os.path.split(target_product_common_dir)[0], 'common')
    copy_directory(reference_dir, target_dir)


def modify_repo_common_file():
    print('modify repo common files')
    """remove the directory of two modules to eliminate duplicate definition confliction"""
    wifioverlay_module_dir = os.path.join(os.path.split(target_product_common_dir)[0], 'common/wifi/WifiOverlay')
    shutil.rmtree(wifioverlay_module_dir)

    imx_recovery_ui_module_dir = os.path.join(os.path.split(target_product_common_dir)[0], 'common/recovery')
    shutil.rmtree(imx_recovery_ui_module_dir)

    """replace device/nxp with target_product['repo_path']"""
    kernel_mk = os.path.join(os.path.split(target_product_common_dir)[0], 'common/build/kernel.mk')
    with open(kernel_mk, 'r+') as kernel_mk_fd:
        lines = kernel_mk_fd.readlines()
        for i, line in enumerate(lines):
            if re.match(r'.*device/nxp.*', line):
                lines[i] = line.replace('device/nxp', target_product['repo_path'])

        kernel_mk_fd.seek(0)
        kernel_mk_fd.writelines(lines)
        kernel_mk_fd.truncate()

    imx_make_sh = os.path.join(os.path.split(target_product_common_dir)[0], 'common/tools/imx-make.sh')
    with open(imx_make_sh, 'r+') as imx_make_sh_fd:
        lines = imx_make_sh_fd.readlines()
        for i, line in enumerate(lines):
            if re.match(r'.*device/nxp.*', line):
                lines[i] = line.replace('device/nxp', target_product['repo_path'])

        imx_make_sh_fd.seek(0)
        imx_make_sh_fd.writelines(lines)
        imx_make_sh_fd.truncate()

    """create a symbolic link"""
    symbolic_link = os.path.join(android_root_path, target_product['manufacturer'] + '.sh')
    if not os.path.exists(symbolic_link):
        os.symlink(os.path.join(target_product['repo_path'], 'common/tools/imx-make.sh'), symbolic_link)


def copy_android_product_common_file():
    print('copy android product common files')
    if not os.path.exists(target_product_common_dir):
        os.mkdir(target_product_common_dir)

    """make it simple, hardcode directories need to be copied"""
    entries = os.listdir(reference_product_common_dir)
    for entry in entries:
        reference_file = os.path.join(android_root_path, reference_product['AndroidProducts_root'], entry)
        target_file = os.path.join(android_root_path, target_product['AndroidProducts_root'], entry)

        if os.path.isfile(reference_file):
            copy_file_based_on_configuration(reference_file, target_file, target_modules)
        elif os.path.isdir(reference_file) and re.match(r'(permissions|sepolicy.*|etc)', entry):
            copy_directory(reference_file, target_file)


"""
modify the value of:
    PRODUCT_MAKEFILES
    COMMON_LUNCH_CHOICES
    PRODUCT_MANUFACTURER
    SOONG_CONFIG_IMXPLUGIN_PRODUCT_MANUFACTURER
"""
def modify_android_product_common_file():
    print('modify android product common files')
    subpath_to_replace = '$(CONFIG_REPO_PATH)/' + os.path.split(reference_product['AndroidProducts_root'])[1] + '/'
    subpath_replace_to = '$(CONFIG_REPO_PATH)/' + os.path.split(target_product['AndroidProducts_root'])[1] + '/'

    skip_insert_include_mkfile = 0
    skip_insert_lunch_choice = 0
    target_android_product_mk = os.path.join(android_root_path, target_product['AndroidProducts_root'], 'AndroidProducts.mk')

    if new_product_with_common_files:
        with open(target_android_product_mk, 'r+') as android_product_mkfile_fd:
            lines = android_product_mkfile_fd.readlines()
            for line in lines:
                if re.match(r'^\s*[^#]*\$\(LOCAL_DIR\)/.*' + target_product['name'] + ".mk", line):
                    skip_insert_include_mkfile = 1

                """in the AndroidProducts.mk we used, each product has two lunch choices explicitly 
                specified, firstly user build, then userdebug build"""
                if re.match(r'^\s*[^#]*'+target_product['name'] + '-user', line):
                    skip_insert_lunch_choice = 1
                if skip_insert_include_mkfile == 1 and skip_insert_lunch_choice == 1:
                    break

            for i, line in enumerate(lines):
                if re.match(r'^\s*[^#]*\$\(LOCAL_DIR\)/.*'+reference_product['name'] + ".mk", line) and skip_insert_include_mkfile == 0:
                    insert_line = line.replace(reference_product['name'], target_product['name'])
                    if not re.match(r'.*\\\s*\n$', insert_line):
                        insert_line = insert_line.replace('\n', ' \\\n')
                    lines.insert(i, insert_line)
                    break
            for i, line in enumerate(lines):
                if re.match(r'^\s*[^#]*' + reference_product['name'] + '-user', line) and skip_insert_lunch_choice == 0:
                    insert_line = line.replace(reference_product['name'], target_product['name'])
                    if not re.match(r'.*\\\s*\n$', insert_line):
                        insert_line = insert_line.replace('\n', ' \\\n')
                    lines.insert(i, insert_line)
                    lines.insert(i+1, insert_line.replace('-user', '-userdebug'))
                    break

            android_product_mkfile_fd.seek(0)
            android_product_mkfile_fd.writelines(lines)
            android_product_mkfile_fd.truncate()
    else:
        mkfiles_line = False
        lunch_choices_line = False
        written_lines = []
        with open(target_android_product_mk, 'r+') as android_product_mkfile_fd:
            lines = android_product_mkfile_fd.readlines()
            for line in lines:
                if re.match(r'\s*[^#]*PRODUCT_MAKEFILES\s*[:|]*=\s*\\', line):
                    written_lines.append(line)
                    mkfiles_line = True
                    continue
                if re.match(r'\s*[^#]*COMMON_LUNCH_CHOICES\s*[:|]*=\s*\\', line):
                    written_lines.append(line)
                    lunch_choices_line = True
                    continue

                if mkfiles_line == True and re.match(r'^\s*[^#]*\$\(LOCAL_DIR\)/.*' + reference_product['name'] + '.mk', line):
                    append_line = line.replace(reference_product['name'] + ".mk", target_product['name'] + '.mk').replace(reference_product['device'], target_product['device'])
                    written_lines.append(append_line)
                if  lunch_choices_line == True and re.match(r'^\s*[^#]*' + reference_product['name'] + '\-(user|userdebug|eng)', line):
                    written_lines.append(line.replace(reference_product['name'], target_product['name']))

                if (not mkfiles_line) and (not lunch_choices_line):
                    written_lines.append(line)

                if not re.match(r'.*\\\s*\n', line):
                    """make sure there is no back slash at the last line when assign value to PRODUCT_MAKEFILES and COMMON_LUNCH_CHOICES"""
                    if mkfiles_line == True:
                        append_line = written_lines.pop()
                        try:
                            append_line = re.match(r'(.*' + target_product['name'] + '.mk'+ ')(\s*\\\s*\n)', append_line).group(1) + '\n'
                        except AttributeError:
                            append_line = append_line
                        written_lines.append(append_line)
                        mkfiles_line = False
                    if lunch_choices_line == True:
                        append_line = written_lines.pop()
                        try:
                            append_line = re.match(r'(.*' + target_product['name'] + '\-(user|userdebug|eng)'+ ')(\s*\\\s*\n)', append_line).group(1) + '\n'
                        except AttributeError:
                            append_line = append_line
                        written_lines.append(append_line)
                        lunch_choices_line = False

            android_product_mkfile_fd.seek(0)
            android_product_mkfile_fd.writelines(written_lines)
            android_product_mkfile_fd.truncate()

    boardconfigcommon_mk = os.path.join(android_root_path, target_product['AndroidProducts_root'], 'BoardConfigCommon.mk')
    with open(boardconfigcommon_mk, 'r+') as boardconfigcommon_mk_fd:
        lines = boardconfigcommon_mk_fd.readlines()
        for i, line in enumerate(lines):
            if re.match(r'\s*SOONG_CONFIG_IMXPLUGIN_PRODUCT_MANUFACTURER\s*[:|]*=', line):
                lines[i] = 'SOONG_CONFIG_IMXPLUGIN_PRODUCT_MANUFACTURER = ' + target_product['manufacturer'] + '\n'
            if re.match(r'\s*PRODUCT_MANUFACTURER\s*[:|]*=', line):
                lines[i] = 'PRODUCT_MANUFACTURER = ' + target_product['manufacturer'] + '\n'
            if subpath_to_replace in line:
                lines[i] = line.replace(subpath_to_replace, subpath_replace_to)

        boardconfigcommon_mk_fd.seek(0)
        boardconfigcommon_mk_fd.writelines(lines)
        boardconfigcommon_mk_fd.truncate()

    productconfigcommon_mk = os.path.join(android_root_path, target_product['AndroidProducts_root'], 'ProductConfigCommon.mk')
    with open(productconfigcommon_mk, 'r+') as productconfigcommon_mk_fd:
        lines = productconfigcommon_mk_fd.readlines()
        for i, line in enumerate(lines):
            if re.match(r'\s*SOONG_CONFIG_IMXPLUGIN_PRODUCT_MANUFACTURER\s*[:|]*=', line):
                lines[i] = 'SOONG_CONFIG_IMXPLUGIN_PRODUCT_MANUFACTURER = ' + target_product['manufacturer'] + '\n'
            if re.match(r'\s*PRODUCT_MANUFACTURER\s*[:|]*=', line):
                lines[i] = 'PRODUCT_MANUFACTURER := ' + target_product['manufacturer'] + '\n'
            if subpath_to_replace in line:
                lines[i] = line.replace(subpath_to_replace, subpath_replace_to)

        productconfigcommon_mk_fd.seek(0)
        productconfigcommon_mk_fd.writelines(lines)
        productconfigcommon_mk_fd.truncate()


def copy_product_file():
    print('copy product files')
    """create the directory to hold target product files if it does not exist"""
    if not os.path.exists(target_product_dir):
        os.mkdir(target_product_dir)

    entries = os.listdir(reference_product_dir)

    """there may be more than one makefile which contain the definition of PRODUCT_NAME
    and we may not need all of them"""
    device_mkfile_dict = dict()
    for entry in entries:
        reference_file = os.path.join(android_root_path, reference_product['AndroidProducts_root'], reference_product['device'], entry)
        if os.path.isfile(reference_file) and re.match(r'.*.mk', entry):
            with open(reference_file, 'r+') as reference_file_fd:
                lines = reference_file_fd.readlines()
                for line in lines:
                    if re.match(r'\s*PRODUCT_NAME.*=', line):
                        device_mkfile_dict[entry] = 1
                        continue

    mkfile_to_check = reference_product['name'] + ".mk"
    mkfile_to_check_path = os.path.join(android_root_path, reference_product['AndroidProducts_root'], reference_product['device'], mkfile_to_check)
    device_mkfile_dict[mkfile_to_check] = 0

    while True:
        mkfile_include_found = False
        with open(mkfile_to_check_path, 'r+') as mkfile_to_check_fd:
            lines = mkfile_to_check_fd.readlines()
            for line in lines:
                for device_mkfile in device_mkfile_dict:
                    if re.match(r'.*include.*' + device_mkfile, line) or re.match(r'.*call inherit-product.*' + device_mkfile, line):
                        device_mkfile_dict[device_mkfile] = 0
                        mkfile_to_check = device_mkfile
                        mkfile_to_check_path = os.path.join(android_root_path, reference_product['AndroidProducts_root'], reference_product['device'], mkfile_to_check)
                        mkfile_include_found = True
                        """asume that only one device makefile is included"""
                        break
                if mkfile_include_found:
                    break
        """to end the while True loop"""
        if mkfile_include_found:
            continue
        else:
            break

    for entry in entries:
        if reference_product['soc_type'].lower() in entry:
            modified_file_list.append(entry)

    for entry in entries:
        if entry in device_mkfile_dict and device_mkfile_dict[entry] == 1:
            continue

        """TODO: files copied in the skiped mkfiles should also be skipped"""

        reference_file = os.path.join(android_root_path, reference_product['AndroidProducts_root'], reference_product['device'], entry)

        renamed_entry = entry
        if reference_product['name'] in entry:
            renamed_entry = entry.replace(reference_product['name'], target_product['name'])

        if reference_product['soc_type'].lower() in entry:
            renamed_entry = entry.replace(reference_product['soc_type'].lower(), target_product['soc_type'].lower())

        target_file = os.path.join(android_root_path, target_product['AndroidProducts_root'], target_product['device'], renamed_entry)

        if os.path.isfile(reference_file):
            copy_file_based_on_configuration(reference_file, target_file, target_modules)
        elif os.path.isdir(reference_file):
            copy_directory(reference_file, target_file)

"""
mainly to modify the value of:
    CONFIG_REPO_PATH
    PRODUCT_NAME
    PRODUCT_DEVICE
    PRODUCT_MODEL
    TARGET_BOOTLOADER_BOARD_NAME
    BOARD_SOC_TYPE
    SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE
"""
def modify_product_file():
    print('modify product files')
    subpath_to_replace = '$(CONFIG_REPO_PATH)/' + os.path.split(reference_product['AndroidProducts_root'])[1] + '/'
    subpath_replace_to = '$(CONFIG_REPO_PATH)/' + os.path.split(target_product['AndroidProducts_root'])[1] + '/'
    """target product makefile"""
    target_product_mk = os.path.join(android_root_path, target_product['AndroidProducts_root'], target_product['device'], target_product['name'] + ".mk")
    with open(target_product_mk, 'r+') as target_product_mk_fd:
        lines = target_product_mk_fd.readlines()
        for i, line in enumerate(lines):
            if re.match(r'\s*CONFIG_REPO_PATH\s*[:|]*=', line):
                lines[i] = 'CONFIG_REPO_PATH := ' + target_product['repo_path'] + '\n'
                continue
            if re.match(r'\s*PRODUCT_NAME\s*[:|]*=', line):
                lines[i] = 'PRODUCT_NAME := ' + target_product['name'] + '\n'
                continue
            if re.match(r'\s*PRODUCT_DEVICE\s*[:|]*=', line):
                lines[i] = 'PRODUCT_DEVICE := ' + target_product['device'] + '\n'
                continue
            if re.match(r'\s*PRODUCT_MODEL\s*[:|]*=', line):
                lines[i] = 'PRODUCT_MODEL := ' + target_product['device'].upper() + '\n'
                continue
            if re.match(r'\s*TARGET_BOOTLOADER_BOARD_NAME\s*:=', line):
                lines[i] = 'TARGET_BOOTLOADER_BOARD_NAME := ' + target_product['device'].upper() + '\n'
                continue
            if subpath_to_replace in line:
                replace_line = line.replace(subpath_to_replace, subpath_replace_to)
                lines[i] = replace_line
                continue

        target_product_mk_fd.seek(0)
        target_product_mk_fd.writelines(lines)
        target_product_mk_fd.truncate()

    """target product BoardConfig makefile"""
    target_boardconfig_mk = os.path.join(android_root_path, target_product['AndroidProducts_root'], target_product['device'], "BoardConfig.mk")
    with open(target_boardconfig_mk, 'r+') as target_boardconfig_mk_fd:
        lines = target_boardconfig_mk_fd.readlines()
        for i, line in enumerate(lines):
            if re.match(r'\s*BOARD_SOC_TYPE\s*[:|]*=', line):
                lines[i] = 'BOARD_SOC_TYPE := ' + target_product['soc_type'] + '\n'
                continue
            if re.match(r'\s*SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE\s*[:|]*=', line):
                lines[i] = 'SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE = ' + target_product['soc_type'] + '\n'
                continue
            if subpath_to_replace in line:
                replace_line = line.replace(subpath_to_replace, subpath_replace_to)
                lines[i] = replace_line
                continue
        target_boardconfig_mk_fd.seek(0)
        target_boardconfig_mk_fd.writelines(lines)
        target_boardconfig_mk_fd.truncate()


if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("need to specify a yaml config file")
        exit()

    """infer the root directory of android source code, as this tool is executed under device/nxp"""
    android_root_path=os.path.abspath(os.path.join(os.getcwd(), "../.."))


    yaml_config_file=sys.argv[1]
    with open(yaml_config_file, 'r') as config_file_fd:
        raw_config = yaml.safe_load(config_file_fd.read())

    reference_product = raw_config['reference_product']

    target_product = raw_config['target_product']
    target_modules = raw_config['modules']

    reference_product_dir = os.path.join(android_root_path, reference_product['AndroidProducts_root'], reference_product['device'])
    target_product_dir = os.path.join(android_root_path, target_product['AndroidProducts_root'], target_product['device'])

    reference_product_common_dir = os.path.join(android_root_path, reference_product['AndroidProducts_root'])
    target_product_common_dir = os.path.join(android_root_path, target_product['AndroidProducts_root'])

    modified_file_list = list()
    try:
        if target_product['repo_path'] != 'device/nxp':
            copy_repo_common_file()
            modify_repo_common_file()

        if target_product['AndroidProducts_root'] != reference_product['AndroidProducts_root']:
            new_product_with_common_files = False
            copy_android_product_common_file()
        else:
            new_product_with_common_files = True

        modify_android_product_common_file()

        copy_product_file()
        modify_product_file()
    except File_Already_Exists_Exception as e:
        print(str(e))
        raise

