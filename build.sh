#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Android Phenix Kernel Build Script

sudo apt-get install git ccache automake flex lzop bison \
gperf build-essential zip curl zlib1g-dev zlib1g-dev:i386 \
g++-multilib python-networkx libxml2-utils bzip2 libbz2-dev \
libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush \
schedtool dpkg-dev liblz4-tool make optipng maven libssl-dev \
pwgen libswitch-perl policycoreutils minicom libxml-sax-base-perl \
libxml-simple-perl bc libc6-dev-i386 lib32ncurses5-dev \
x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev xsltproc unzip

#Clang and Gcc
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b android-10.0.0_r35 --depth=1 toolchain
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-10.0.0_r35 --depth=1 toolchain-32
git clone --depth=1 https://github.com/kdrag0n/proton-clang clang

if [ ! -d libufdt ]; then
    wget https://android.googlesource.com/platform/system/libufdt/+archive/refs/tags/android-10.0.0_r35/utils.tar.gz
    mkdir -p libufdt
    tar xvzf utils.tar.gz -C libufdt
    rm utils.tar.gz
fi

#PATH=:"${KERNEL_DIR}/clang/clang-r383902c/bin:${PATH}:${KERNEL_DIR}/stock/bin:${PATH}:${KERNEL_DIR}/stock_32/bin:${PATH}"

mkdir out
export ARCH=arm64
export SUBARCH=arm64
export DTC_EXT=dtc
export CROSS_COMPILE=${PWD}/toolchain/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=${PWD}/toolchain-32/bin/arm-linux-androideabi-
export PATH=$PWD/clang/bin:$PATH

make O=out REAL_CC=${PWD}/clang/bin/clang CLANG_TRIPLE=aarch64-linux-gnu- vendor/phoenix_user_defconfig
make -j$(nproc --all) O=out REAL_CC=${PWD}/clang/bin/clang CLANG_TRIPLE=aarch64-linux-gnu- 2>&1 | tee kernel.log
