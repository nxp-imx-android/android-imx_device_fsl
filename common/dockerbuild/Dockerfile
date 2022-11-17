FROM ubuntu:20.04
ARG userid
ARG groupid
ARG username

# If apt-get need http proxy in your host's network environment, you can refer to the line below.
# COPY apt.conf /etc/apt/apt.conf

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y tzdata git-core gnupg flex bison apt-utils build-essential zip curl zlib1g-dev liblz-dev gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig uuid uuid-dev liblzo2-2 liblzo2-dev lzop git u-boot-tools mtd-utils android-sdk-libsparse-utils android-sdk-ext4-utils device-tree-compiler gdisk m4 make libssl-dev libghc-gnutls-dev swig libdw-dev dwarves python bc cpio tar lz4 rsync ninja-build clang \
 && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && dpkg-reconfigure -f noninteractive tzdata

ENV GCC_CROSS_COMPILE_TOOL_CHAIN gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu
RUN curl -o ${GCC_CROSS_COMPILE_TOOL_CHAIN}.tar.xz https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/9.2-2019.12/binrel/${GCC_CROSS_COMPILE_TOOL_CHAIN}.tar.xz \
 && tar -xvJf ${GCC_CROSS_COMPILE_TOOL_CHAIN}.tar.xz -C /opt \
 && rm -rf ${GCC_CROSS_COMPILE_TOOL_CHAIN}.tar.xz

ENV AARCH64_GCC_CROSS_COMPILE=/opt/${GCC_CROSS_COMPILE_TOOL_CHAIN}/bin/aarch64-none-linux-gnu-

# If failed to connect to android.googlesource.com, you can refer to the line below.
# ENV https_proxy=http://username:password@example.com:8080
RUN git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 --single-branch --depth=1 -b android-13.0.0_r0.5 /opt/prebuilt-android-clang

ENV CLANG_PATH=/opt/prebuilt-android-clang

RUN groupadd -g $groupid $username \
 && useradd -m -u $userid -g $groupid $username \
 && echo $username >/root/username
ENV HOME=/home/$username
ENV USER=$username

ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /bin/bash -i


