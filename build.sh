#!/bin/bash

set -e

platform=${1:-all} # can be original, go, 2 or all (default)
version=$(cat src/version)

if [[ ${platform} == "all" ]]; then
    echo "Building the firmware for all platforms"
    ./build.sh original
    ./build.sh go
    ./build.sh 2
    echo "All Done!"
    exit 0
else
    echo "Building for ${platform} platform"
fi

echo "Preparing the openwrt directory..."
resources/clone_or_update.bash
cp src/feeds.conf openwrt/
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
cd -

rm -rf openwrt/files/*
mkdir -p openwrt/files/etc output
cp -R "src/files/${platform}"/* "openwrt/files/"
sed -e "s,@VERSION@,${version}," -e "s,@HOME_DIR@,$HOME," "src/.config.${platform}" >openwrt/.config
sed -e "s,@VERSION@,${version}," "src/files/${platform}/etc/config/update" >openwrt/files/etc/config/update
sed "s,@VERSION@,${version}," "src/files/${platform}/etc/banner" >openwrt/files/etc/banner

echo "Building the firmware"
cd openwrt
make defconfig
make -j $(($(grep -c processor /proc/cpuinfo)))
cd -
echo "Firmware built!"
if [[ ${platform} == "original" ]]; then
    cp openwrt/bin/targets/ramips/mt7620/invizbox-openwrt-ramips-mt7620-invizbox_invizbox-squashfs-sysupgrade.bin "output/InvizBox-${version}-sysupgrade.bin"
elif [[ ${platform} == "go" ]]; then
    cp openwrt/bin/targets/ramips/mt7621/invizbox-openwrt-ramips-mt7621-invizbox_invizboxgo-squashfs-sysupgrade.bin "output/InvizBox-Go-${version}-sysupgrade.bin"
elif [[ ${platform} == "2" ]]; then
    cp openwrt/bin/targets/sunxi/cortexa7/invizbox-openwrt-sunxi-cortexa7-invizbox_invizbox-2-squashfs-sdcard.img.gz "output/InvizBox-2-${version}-sysupgrade.bin"
fi
echo "Finished building for ${platform} platform"
