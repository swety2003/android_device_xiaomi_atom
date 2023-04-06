#!/bin/sh
PATCH_LOC=$PWD/patch
PATCH_TARGET=$PWD
cd $PATCH_TARGET/device/custom/sepolicy
# git am --abort
git am $PATCH_LOC/device/custom/sepolicy/0001-Fix-up-kernel-failure.patch

cd $PATCH_TARGET/frameworks/base
# git am --abort
git am $PATCH_LOC/frameworks/base/0001-PE-Fingerprint-fix.patch
git am $PATCH_LOC/frameworks/base/0002-Mediatek-IMS-Fail.patch
git am $PATCH_LOC/frameworks/base/0003-UDFPS-better-user-experience-author-xjl12.patch
git am $PATCH_LOC/frameworks/base/0004-UdfpsView-patch-by-xjl12.patch

cd $PATCH_TARGET/frameworks/native
# git am --abort
git am $PATCH_LOC/frameworks/native/0001-Fix-vibration.patch

cd $PATCH_TARGET/frameworks/av
# git am --abort
git am $PATCH_LOC/frameworks/av/0004-APM-Optionally-force-load-audio-policy-for-system-si.patch
git am $PATCH_LOC/frameworks/av/0005-APM-Remove-A2DP-audio-ports-from-the-primary-HAL.patch

cd $PATCH_TARGET/hardware/interfaces
# git am --abort
git am $PATCH_LOC/hardware/interfaces/0001-Add-show-hide-udfps-view-callbacks-to-IBiometricsFin.patch

cd $PATCH_TARGET/packages/modules/Bluetooth
# git am --abort
git am $PATCH_LOC/packages/modules/Bluetooth/0003-audio_hal_interface-Optionally-use-sysbta-HAL.patch

# cd $PATCH_TARGET/system/sepolicy
# git am $PATCH_LOC/system/sepolicy/0001-Fix-sepolicy-conflict.patch

