#!/bin/bash
# Finna Be Robot
# Version 0.1.1
# Written by Jonathan "darkspadez" Kagan - http://darkspadez.com
# Last modified on 12 August, 2012

# First let's find out what they wanna do
echo For the following either enter \"y\", for yes, or \"n\", for no.

# Repo Sync
echo Do you wanna run a repo sync first\?
read runSync

# -j#
echo Set -j\#
echo Number only. Will be used \if you sync and/or build.
read runJ

# Build
echo Do you wish to build?
read runBuild

if [ $runBuild = "y" ]; then

    # Clobber
    echo Do you wanna clobber first\?
    read runClobber

    # Out
    echo Is your build directory \"out\"\?
    echo If it is type \"yes\", \if not type the directory out like \"out\".
    read setClobber

    # Time
    echo Do you wanna time the build\?
    read runTime

    # Device
    echo Which device would you like to build\?
    echo Please use full string like \"cm_vision-eng\".
    read runDevice

fi

# Check answer for sync
if [ $runSync = "y" ]; then
    repo sync -j$runJ
fi

# Check answer for clobber
if [ $runClobber = "y" ]; then
    if [ $setClobber = "y" ]; then
        rm -rf out
    else
        rm -rf $setClobber
    fi
fi

# Build
if [ $runBuild = "y" ]; then

    # Run envsetup.sh
    . build/envsetup.sh
	
    # Pick Device
    lunch $runDevice

    # Run the build
    if [ $runTime = "y" ]; then
        time make -j$runJ bacon
    else
        make -j$runJ bacon
    fi
fi
