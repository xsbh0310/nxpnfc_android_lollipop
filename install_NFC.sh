#!/bin/bash
echo
echo "+++ Installing NXP-NCI NFC support +++"

if [ "$1" != "PN7120" ] && [ "$1" != "PN7150" ]; then 
  if [ "$1" = "" ]; then
    echo "ERROR: missing parameter (PN7120 or PN7150)"
  else
    echo "ERROR: $1 is not a valid parameter (only PN7120 and PN7150 are supported)"
  fi
  echo
  exit 1
fi

echo
echo "- removing existing implementation"
rm -rf $ANDROID_BUILD_TOP/frameworks/base/core/java/android/nfc
rm -rf $ANDROID_BUILD_TOP/frameworks/base/core/java/com/nxp
rm -rf $ANDROID_BUILD_TOP/frameworks/base/core/java/com/vzw
rm -rf $ANDROID_BUILD_TOP/frameworks/base/nxp-nfc-gsma

echo
echo "- copying required files"
mv $ANDROID_BUILD_TOP/NxpNfcAndroid/NFC_NCIHAL_base/core/java/android/nfc $ANDROID_BUILD_TOP/frameworks/base/core/java/android/
mv $ANDROID_BUILD_TOP/NxpNfcAndroid/NFC_NCIHAL_base/core/java/com/nxp $ANDROID_BUILD_TOP/frameworks/base/core/java/com/
mv $ANDROID_BUILD_TOP/NxpNfcAndroid/NFC_NCIHAL_base/core/java/com/vzw $ANDROID_BUILD_TOP/frameworks/base/core/java/com/
mv $ANDROID_BUILD_TOP/NxpNfcAndroid/NFC_NCIHAL_base/nxp-nfc-gsma $ANDROID_BUILD_TOP/frameworks/base/
rm -rf $ANDROID_BUILD_TOP/NxpNfcAndroid/NFC_NCIHAL_base
rm -rf $ANDROID_BUILD_TOP/NxpNfcAndroid/NXPNFC_Reference

echo
echo "- patching required makefile"
cd $ANDROID_BUILD_TOP/frameworks/base
patch -p1 <$ANDROID_BUILD_TOP/NxpNfcAndroid/patch-framework_base.txt
cd $ANDROID_BUILD_TOP

if [ "$1" = "PN7120" ]; then
  echo "- patching specific makefile for PN7120"
  cd $ANDROID_BUILD_TOP/external/libnfc-nci
  patch -p1 <$ANDROID_BUILD_TOP/NxpNfcAndroid/patch-external_libnfcnci.txt
  cd $ANDROID_BUILD_TOP/packages/apps/Nfc
  patch -p1 <$ANDROID_BUILD_TOP/NxpNfcAndroid/patch-packages_apps_Nfc.txt
  cd $ANDROID_BUILD_TOP
fi

echo
echo "+++ NXP-NCI NFC support installation completed +++"
exit 0

