#!/bin/sh

# Apply these patches before compilation:

ROM_TREE=$PWD
BRANCH=$ROM_TREE/patcher/ZNH2K
CUSTOM=$ROM_TREE/patcher/sultan

APN_LIST_URL=https://raw.githubusercontent.com/CyanogenMod/android_vendor_cm/cm-13.0/prebuilt/common/etc/apns-conf.xml

# Clean up first
cd $ROM_TREE/build
git clean -f -d && git reset --hard
cd $ROM_TREE/frameworks/av
git clean -f -d && git reset --hard
cd $ROM_TREE/frameworks/base
git clean -f -d && git reset --hard
cd $ROM_TREE/packages/apps/Messaging
git clean -f -d && git reset --hard
cd $ROM_TREE/packages/apps/Nfc
git clean -f -d && git reset --hard
cd $ROM_TREE/packages/apps/Settings
git clean -f -d && git reset --hard
cd $ROM_TREE/system/core
git clean -f -d && git reset --hard
cd $ROM_TREE/vendor/cm
git clean -f -d && git reset --hard

cd $ROM_TREE

### Useful upstream patches not present on the branch in use
patch -d frameworks/base			-p1 -s -N --no-backup-if-mismatch < $BRANCH/frameworks-base0.patch
patch -d packages/apps/Nfc			-p1 -s -N --no-backup-if-mismatch < $BRANCH/packages-apps-Nfc0.patch

# Special git binary diff patch
cd packages/apps/Messaging
git apply $BRANCH/packages-apps-Messaging0.patch
cd $ROM_TREE

### Custom patches
patch -d build					-p1 -s -N --no-backup-if-mismatch < $CUSTOM/build0.patch
patch -d build					-p1 -s -N --no-backup-if-mismatch < $CUSTOM/build1.patch
patch -d frameworks/av				-p1 -s -N --no-backup-if-mismatch < $CUSTOM/frameworks-av0.patch
patch -d frameworks/base			-p1 -s -N --no-backup-if-mismatch < $CUSTOM/frameworks-base0.patch
patch -d frameworks/base			-p1 -s -N --no-backup-if-mismatch < $CUSTOM/frameworks-base1.patch
patch -d frameworks/base			-p1 -s -N --no-backup-if-mismatch < $CUSTOM/frameworks-base2.patch
patch -d frameworks/base			-p1 -s -N --no-backup-if-mismatch < $CUSTOM/frameworks-base3.patch
patch -d frameworks/base			-p1 -s -N --no-backup-if-mismatch < $CUSTOM/frameworks-base4.patch
patch -d packages/apps/Settings			-p1 -s -N --no-backup-if-mismatch < $CUSTOM/packages-apps-Settings0.patch
patch -d system/core				-p1 -s -N --no-backup-if-mismatch < $CUSTOM/system-core0.patch
patch -d system/core				-p1 -s -N --no-backup-if-mismatch < $CUSTOM/system-core1.patch

# Get APN list from nightly branch and apply patch on top
curl -s $APN_LIST_URL > vendor/cm/prebuilt/common/etc/apns-conf.xml
patch -d vendor/cm				-p1 -s -N --no-backup-if-mismatch < $CUSTOM/vendor-cm0.patch
