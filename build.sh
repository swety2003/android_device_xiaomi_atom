#!/bin/bash

echo
echo "--------------------------------------"
echo "    Pixel Experience 13.0 Buildbot    "
echo "                  by                  "
echo "                ponces                "
echo "--------------------------------------"
echo

set -e

BL=$PWD
BD=$PWD/builds

initRepos() {
    if [ ! -f .repo/manifest.xml ]; then
        echo "--> Initializing workspace"
        repo init -u https://github.com/PixelExperience/manifest -b thirteen-plus
        echo

        echo "--> Preparing local manifest"
        mkdir -p .repo/local_manifests
        cp $BL/manifest.xml .repo/local_manifests/pixel.xml
        echo
    fi
}

syncRepos() {
    echo "--> Syncing repos"
    repo sync -c --force-sync --no-clone-bundle --no-tags -j$(nproc --all)
    echo
}

applyPatches() {
    echo "--> Applying prerequisite patches"
    bash $BL/patch/patch.sh
    echo
}

setupEnv() {
    echo "--> Setting up build environment"
    source build/envsetup.sh &>/dev/null
    mkdir -p $BD
    echo
}

# buildTrebleApp() {
#     echo "--> Building treble_app"
#     cd treble_app
#     bash build.sh release
#     cp TrebleApp.apk ../vendor/hardware_overlay/TrebleApp/app.apk
#     cd ..
#     echo
# }

buildUserDebug() {
    echo "--> Building aosp_atom-userdebug"
    lunch aosp_atom-userdebug
    mka systemimage
    mka productimage
    # mv $OUT/system.img $BD/aosp_atom-userdebug.img
    echo
}

buildUser() {
    echo "--> Building aosp_atom-user"
    lunch aosp_atom-user
    mka systemimage
    mka productimage
    mka vendorimage
    # mv $OUT/system.img $BD/aosp_atom-user.img
    echo
}

buildVndkliteVariant() {
    echo "--> Building treble_arm64_bvN-vndklite"
    cd sas-creator
    sudo bash lite-adapter.sh 64 $BD/system-treble_arm64_bvN.img
    cp s.img $BD/system-treble_arm64_bvN-vndklite.img
    sudo rm -rf s.img d tmp
    cd ..
    echo
}

generatePackages() {
    echo "--> Generating packages"
    xz -cv $BD/system-treble_arm64_bvN.img -T0 > $BD/PixelExperience_arm64-ab-13.0-$BUILD_DATE-UNOFFICIAL.img.xz
    xz -cv $BD/system-treble_arm64_bvN-vndklite.img -T0 > $BD/PixelExperience_arm64-ab-vndklite-13.0-$BUILD_DATE-UNOFFICIAL.img.xz
    xz -cv $BD/system-treble_arm64_bvN-slim.img -T0 > $BD/PixelExperience_arm64-ab-slim-13.0-$BUILD_DATE-UNOFFICIAL.img.xz
    rm -rf $BD/system-*.img
    echo
}

START=`date +%s`
BUILD_DATE="$(date +%Y%m%d)"


# prepare
# mv BoardConfig.mk ./debice/xiaomi/atom
# mv -r sepolicy/ device/xiaomi/atom/
# git clone https://github.com/PixelExperience/device_mediatek_sepolicy_vndr
# mkdir device/mediatek
# mkdir device/mediatek/sepolicy_vndr
# mv -r device_mediatek_sepolicy_vndr/* device/mediatek/sepolicy_vndr/

# mkdir kernel/xiaomi/    
# mkdir kernel/xiaomi/atom
# git clone --depth=1 https://github.com/xiaomi-mt6885-devs/android_kernel_xiaomi_mt6885
# mv -r Xiaomi_Kernel_OpenSource/* kernel/xiaomi/atom/

# mv -r sepolicy/ device/xiaomi/atom
# mv -r fingerprint/ device/xiaomi/atom
# cp -r configs/ device/xiaomi/atom
# cp framework_manifest.xml device/xiaomi/atom/
# cp compatibility_matrix.xml device/xiaomi/atom/

# initRepos
# syncRepos
# applyPatches


setupEnv
buildUser
# buildSlimVariant
# buildVndkliteVariant
# generatePackages

END=`date +%s`
ELAPSEDM=$(($(($END-$START))/60))
ELAPSEDS=$(($(($END-$START))-$ELAPSEDM*60))

echo "--> Buildbot completed in $ELAPSEDM minutes and $ELAPSEDS seconds"
echo