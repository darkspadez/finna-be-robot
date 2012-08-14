#!/bin/bash
# Finna Be Robot
# Version 0.2.2
# Written by Jonathan "darkspadez" Kagan - http://darkspadez.com

# First let's find out what they wanna do
echo For the following either enter \"y\", for yes, or \"n\", for no.

# Repo Sync
echo " "
echo " "
echo " "
echo Do you wanna run a repo sync first?
read runSync

# -j#
echo " "
echo " "
echo " "
echo Set -j\#
echo Number only. Will be used if you sync and/or build.
read runJ

# Build
echo " "
echo " "
echo " "
echo Do you wish to build?
read runBuild

if [ $runBuild = "y" ]; then

    # Clobber
    echo " "
    echo " "
    echo " "
    echo Do you wanna clobber first?
    read runClobber

    # Out
    echo " "
    echo " "
    echo " "
    echo Is your build directory \"out\"?
    echo If it is type \"y\" if not type the directory out like \"out\".
    read setClobber

    # Time
    echo " "
    echo " "
    echo " "
    echo Do you wanna time the build\?
    read runTime

    # Device
    echo " "
    echo " "
    echo " "
    echo Which device would you like to build?
    echo Please use full string like \"cm_vision\".
    echo Do not enter -eng, -user, or -userdebug.
    echo it will come in next question
    read runDevice

    # BuildType
    echo " "
    echo " "
    echo " "
    echo What buildtype would you like to use?
    echo Options: eng, user, userdebug
    echo Do not enter the dash
    read runBuildType
    
    # Rename
    echo " "
    echo " "
    echo " "
    echo Do you want to rename the finished product?
    echo If you wish to rename it input what you wish to rename it too
    echo Example: andromadus-jellybell-alpha-1
    echo NOTICE: Do not put the .zip
    echo NOTICE: Current only works if you base off cm
    read runRename
    
    # Rsync
    echo " "
    echo " "
    echo " "
    echo Would you like to rsync finished product to a server?
    echo If you wish to use rsync input your info
    echo Example: username@url.com:/public_html/downloads
    echo NOTICE: You will need to enter your password when it is time to sync
    read runRsync
    
fi

# Check answer for sync
if [ $runSync = "y" ]; then
    echo " "
    echo " "
    echo " "
    echo Running repo sync
    repo sync -j$runJ
fi

# Check answer for clobber
if [ $runClobber = "y" ]; then
    if [ $setClobber = "y" ]; then
        echo " "
        echo " "
        echo " "
        echo Deleteing /out/
        rm -rf out
    else
        echo " "
        echo " "
        echo " "
        echo Deleting $setClobber
        rm -rf $setClobber
    fi
fi

# Build
if [ $runBuild = "y" ]; then

    # Run envsetup.sh
    echo " "
    echo " "
    echo " "
    echo Setup build enviorment
    . build/envsetup.sh
	
    # Pick Device
    echo " "
    echo " "
    echo " "
    echo Picking device via lunch
    lunch $runDevice-$runBuildType

    # Run the build
    if [ $runTime = "y" ]; then
        echo " "
        echo " "
        echo " "
        echo Start the build
        time make -j$runJ bacon
    else
        echo " "
        echo " "
        echo " "
        echo Start the build
        make -j$runJ bacon
    fi
    
    # Figure out device name
    DEVICE='echo $runDevice | tr "_" "\n" | tail -n 1'
    
    # Hack to make sure build works
    # will revise at a latter time
    if [ -f out/target/$DEVICE/cm-*.zip ]; then
    
        if [ $runRename != "n" ]; then
            echo " "
            echo " "
            echo " "
            echo Renaming finished product to $runRename
            cp out/target/product/$DEVICE/cm-*.zip out/target/product/$DEVICE/$runRename.zip
        fi
        
        if [ $runRsync != "n" ]; then
            if [ $runRename != "n" ]; then
                echo " "
                echo " "
                echo " "
                echo Syncing $runRename to $runSync
                rsync -v -e ssh out/target/product/$runRename*.zip $runResync
            else
                echo " "
                echo " "
                echo " "
                echo Syncing finished product to $runSync
                rsync -v -e ssh out/target/product/cm-*.zip $runResync
            fi
        fi
    fi
fi
