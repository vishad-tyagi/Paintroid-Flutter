#!/bin/bash

# This script expects the PR number as an argument
PR_NUMBER=$1

# Define paths to the AndroidManifest.xml files for main, debug, and profile
MAIN_MANIFEST="android/app/src/main/AndroidManifest.xml"
DEBUG_MANIFEST="android/app/src/debug/AndroidManifest.xml"
PROFILE_MANIFEST="android/app/src/profile/AndroidManifest.xml"
# Define the path to the build.gradle file
BUILD_GRADLE="android/app/build.gradle"

# Update package and label in the main manifest
if [ -f "$MAIN_MANIFEST" ]; then
  echo "Updating $MAIN_MANIFEST with PR number $PR_NUMBER"
  # Update package
  sed -i "s/package=\"org.catrobat.paintroid\"/package=\"org.catrobat.paintroid.pr$PR_NUMBER\"/" $MAIN_MANIFEST
  # Update label
  sed -i "s/android:label=\"Pocket Paint\"/android:label=\"Pocket Paint PR$PR_NUMBER\"/" $MAIN_MANIFEST
else
  echo "$MAIN_MANIFEST does not exist."
fi

# Update package in the debug manifest
if [ -f "$DEBUG_MANIFEST" ]; then
  echo "Updating $DEBUG_MANIFEST with PR number $PR_NUMBER"
  sed -i "s/package=\"org.catrobat.paintroid\"/package=\"org.catrobat.paintroid.pr$PR_NUMBER\"/" $DEBUG_MANIFEST
else
  echo "$DEBUG_MANIFEST does not exist."
fi

# Update package in the profile manifest
if [ -f "$PROFILE_MANIFEST" ]; then
  echo "Updating $PROFILE_MANIFEST with PR number $PR_NUMBER"
  sed -i "s/package=\"org.catrobat.paintroid\"/package=\"org.catrobat.paintroid.pr$PR_NUMBER\"/" $PROFILE_MANIFEST
else
  echo "$PROFILE_MANIFEST does not exist."
fi

# Update the applicationId in the build.gradle file
if [ -f "$BUILD_GRADLE" ]; then
  echo "Updating applicationId in $BUILD_GRADLE with PR number $PR_NUMBER"
  sed -i "s/applicationId \"org.catrobat.paintroidflutter\"/applicationId \"org.catrobat.paintroidflutter.pr$PR_NUMBER\"/" $BUILD_GRADLE
else
  echo "$BUILD_GRADLE does not exist."
fi

# Path for the MainActivity file in the Kotlin directory
KOTLIN_MAIN_ACTIVITY="android/app/src/main/kotlin/org/catrobat/paintroid/MainActivity.kt"

# Update the package name in the Kotlin MainActivity file
if [ -f "$KOTLIN_MAIN_ACTIVITY" ]; then
  echo "Updating MainActivity package in Kotlin with PR number $PR_NUMBER"
  sed -i "s/package org.catrobat.paintroid/package org.catrobat.paintroid.pr$PR_NUMBER/" $KOTLIN_MAIN_ACTIVITY
else
  echo "MainActivity Kotlin file does not exist."
fi

INFO_PLIST="ios/Runner/Info.plist"
if [ -f "$INFO_PLIST" ]; then
  echo "Updating $INFO_PLIST with PR number $PR_NUMBER"
  xmlstarlet ed -L -u "/plist/dict/key[text()='CFBundleName']/following-sibling::string[1]" -v "paintroid PR$PR_NUMBER" $INFO_PLIST
  xmlstarlet ed -L -u "/plist/dict/key[text()='CFBundleDisplayName']/following-sibling::string[1]" -v "Pocket Paint PR$PR_NUMBER" $INFO_PLIST
  if ! xmlstarlet sel -t -c "/plist/dict/key[text()='CFBundleDisplayName']" $INFO_PLIST | grep -q 'CFBundleDisplayName'; then
    xmlstarlet ed -L -s "/plist/dict" -t elem -n "key" -v "CFBundleDisplayName" \
      -s "/plist/dict/key[last()]" -t elem -n "string" -v "Pocket Paint PR$PR_NUMBER" $INFO_PLIST
  fi
  xmlstarlet ed -L -u "/plist/dict/key[text()='CFBundleIdentifier']/following-sibling::string[1]" -v "org.catrobat.paintroidflutter.pr$PR_NUMBER" $INFO_PLIST
else
  echo "$INFO_PLIST does not exist."
fi
