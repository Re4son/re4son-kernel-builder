#!/usr/bin/env bash
################################################
##++++++++++++++++++++++++++++++++++++++++++++##
##++   RPi Kernel Compilation Script        ++##
##++                                        ++##


################################################
################################################
##                                            ##
##                VARIABLES                   ##

## SET THESE:                                 ##

## Debug - set to "1" to enable debugging
##         (mainly breakpoints)
DEBUG="0"

## Version strings:
VERSION="4.19.93"
BUILD="1"
V6_VERSION=$BUILD
V7_VERSION=$BUILD
V7L_VERSION=$BUILD
V8_VERSION=$BUILD
V8L_VERSION=$BUILD


## Repos
###################################################
##             4.19.93-Re4son                    ##
GIT_REPO="Re4son/re4son-raspberrypi-linux"
GIT_BRANCH="rpi-4.19.93-re4son"	 	 	                         ## 4.19.93 kernel commit: 3fdcc814c54faaf4715ad0d12371c1eec61bf1dc
FW_REPO="Re4son/RPi-Distro-firmware"
FW_BRANCH="4.19.93"
###################################################
##             4.19.88-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.88-re4son"	 	                         ## 4.19.88 kernel commit: 988cc7beacc150756c3fbe40646afcf8438b741b
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.88"
###################################################
##             4.19.81-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.81-re4son"	  	                         ## 4.19.81 kernel commit: bbdf44a11a065ebb2aa2ed5690b82287739b471d
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.81"
###################################################
##             4.19.79-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.79-re4son"	 	 	                 ## 4.19.79 kernel commit: 047589b6dcd5dfd9673a995c5d36ec4073e578b5
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.79"
###################################################
##             4.19.76-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.76-re4son" 	 	                         ## 4.19.76 kernel commit: 7a54e45c03bc95777687adaca091e083aa138718
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.76"
###################################################
##             4.19.73-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.73-re4son" 	 	                         ## 4.19.73 kernel commit: bd3452c84c206a171fa4cf5f6ddfab5687667228 
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.73"
###################################################
##             4.19.71-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.71-re4son"	 	 	                 ## 4.19.71 kernel commit: bd3452c84c206a171fa4cf5f6ddfab5687667228 
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.71"
###################################################
##             4.19.69-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.69-re4son"	 	 	                 ## 4.19.69 kernel commit: bd991fd87ccf2c0e1596cdd6713c1f46c6d79343 
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.69"
###################################################
##             4.19.66-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.66-re4son"	 	 	                 ## 4.19.66 kernel commit: bd991fd87ccf2c0e1596cdd6713c1f46c6d79343 
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.66"
###################################################
##             4.19.55-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.55-re4son"	 	 	                 ## 4.19.55 kernel commit: 9590e9aa6b1bc7a5946d6dae8c217bbde806133c 
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.55"
###################################################
##             4.19.29-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.29-re4son"	 	 	                 ## 4.19.29 kernel commit: 3667ae0605bfbed9e25bd48365457632cf660d78 
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.29"
###################################################
##             4.19.15-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.19.15-re4son"	 	 	         ## 4.19.15 kernel commit: b5a33968098aa5aab149e86215de48213aa8d572 
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.19.15"
###################################################
##             4.14.89-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.14.89-re4son"	 	 	         ## 4.14.89 kernel commit: af369f47021f11e78017c0a98e55cb934b501c36 
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="debian"
###################################################
##             4.14.80-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.14.80-re4son"	 	 	         ## 4.14.80 Commit used for firmware 1.20181112release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="debian"
###################################################
##             4.14.69-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.14.69-re4son"	 	 	         ## 4.14.62 Commit used for firmware 1.20180912 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.14.69"
###################################################
##             4.14.62-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.14.62-re4son"	 	 	         ## 4.14.62 Commit used for firmware 1.20180817 release
###GIT_BRANCH="rpi-4.14.62-p4wnp1"	 	 	                 ## 4.14.62 Commit used for firmware 1.20180817 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.14.62"
###################################################
##             4.14.50-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.14.50-re4son"	 	 	         ## 4.14.50 Commit used for firmware 1.20180619 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.14.50"
###################################################
##             4.14.30-Re4son                    ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.14.30-re4son"	 	 	         ## 4.14.30 Commit used for firmware 1.20180328 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.14.30"
###################################################
##             4.9.80-Re4son                     ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.9.80-re4son"	 	 	         ## 4.9.80 Commit used for firmware Re4son-4.80 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.14.26"
###################################################
##             4.4.28                            ##
##GIT_BRANCH="1423ac8bfbfb2a9d092b604c676e7a58a5fa3367"          ## 4.9.28 Commit used for firmware 1.20170515 release
###################################################
##             4.4.24                            ##
##GIT_BRANCH="ef3b440e0e4d9ca70060483aa33d5b1201ceceb8"          ## 4.9.24 Commit used for firmware 1.20170427 release
###################################################
##             4.9.59-Re4son                     ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.9.59-re4son"	 	 	         ## 4.9.59 Commit used for firmware 1.20171029 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.9.59"
###################################################
##             4.9.41-Re4son                     ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.9.41-re4son"	 	 	         ## 4.9.41 Commit used for firmware 1.20170811 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.9.41"
###################################################
##             4.9.24-Re4son                     ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.9.24-re4son"  		 	         ## 4.9.24 Commit used for firmware 1.20170427 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.9.41"
###################################################
##             4.4.50-Re4son                     ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.4.50-re4son"
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.4.50"
###################################################
##      4.4.50-Re4son-Master                     ##
##GIT_BRANCH="rpi-4.4.50-re4son-master"
###################################################
##             4.4.50                            ##
##GIT_BRANCH="e223d71ef728c559aa865d0c5a4cedbdf8789cfd"          ## 4.4.50 Commit used for firmware 1.20170405 release


##GIT_BRANCH="rpi-4.4.y-re4son"

## defconfigs:
V6_DEFAULT_CONFIG="arch/arm/configs/re4son_pi1_defconfig"
V7_DEFAULT_CONFIG="arch/arm/configs/re4son_pi2_defconfig"
V7L_DEFAULT_CONFIG="arch/arm/configs/re4son_pi7l_defconfig"
V8_DEFAULT_CONFIG="arch/arm64/configs/re4son_pi8_defconfig"
V8L_DEFAULT_CONFIG="arch/arm64/configs/re4son_pi8l_defconfig"
##V6_DEFAULT_CONFIG="arch/arm/configs/bcmrpi_defconfig"
##V7_DEFAULT_CONFIG="arch/arm/configs/bcm2709_defconfig"

V6_CONFIG=""
V7_CONFIG=""
V7L_CONFIG=""
V8_CONFIG=""

export DEBFULLNAME=Re4son
export DEBEMAIL=re4son@kali.org

UNAME_STRING="${VERSION}-Re4son+"
UNAME_STRING7="${VERSION}-Re4son-v7+"
UNAME_STRING7L="${VERSION}-Re4son-v7l+"
UNAME_STRING8="${VERSION}-Re4son-v8+"
UNAME_STRING8L="${VERSION}-Re4son-v8l+"
CURRENT_DATE=`date +%Y%m%d`
NEW_VERSION="${VERSION}-${CURRENT_DATE}"

# Directories
KERNEL_BUILDER_DIR="/opt/re4son-kernel-builder"
REPO_ROOT="/opt/kernel-builder_repos/"
MOD_DIR=`mktemp -d`
PKG_TMP=`mktemp -d`
PKG_DIR="${PKG_TMP}/kalipi-firmware_${NEW_VERSION}"
TOOLS_DIR="/opt/kernel-builder_tools"
FIRMWARE_DIR="/opt/kernel-builder_RPi-Distro-firmware"
KERNEL_SRC_DIR="${REPO_ROOT}${GIT_REPO}/all"
KERNEL_OUT_DIR_V6=/opt/kernel-builder_kernel_out/v6
KERNEL_OUT_DIR_V7=/opt/kernel-builder_kernel_out/v7
KERNEL_OUT_DIR_V7L=/opt/kernel-builder_kernel_out/v7l
KERNEL_OUT_DIR_V8=/opt/kernel-builder_kernel_out/v8
KERNEL_OUT_DIR_V8L=/opt/kernel-builder_kernel_out/v8l
KERNEL_MOD_DIR=/opt/kernel-builder_mod
KERNEL_HEADERS_OUT_DIR=/opt/kernel-builder_headers_out
PKG_IN="/opt/kernel-builder_pkg_in/"
NEXMON_DIR="/opt/re4son-nexmon"


NUM_CPUS=`nproc`



##                                            ##
################################################
################################################

################################################
################################################
##                                            ##
##                FUNCTIONS                   ##

function check_root(){
    if [[ $EUID -ne 0 ]]; then
        printf "\n\t\t$(basename $0) must be run as root.\n\t\ttry: sudo $(basename $0)\n\n"
        exit 1
    fi
}

function breakpoint() {
    # Set a breakpoint
    if [ $DEBUG == "1" ]; then
        read -n1 -r -p "========> Breakpoint #$1: Press any key to continue..."
        printf "\n"
    fi
}

function debug_info() {
    if [ $DEBUG == "1" ]; then
        printf "\nDEBUG INFO:\n\n"
        printf "NAT_ARCH:\t$NAT_ARCH\n"
        printf "MAKE_HEADERS:\t$MAKE_HEADERS\n"
        printf "MAKE_PKG:\t$MAKE_PKG\n"
        printf "MAKE_NEXMON:\t$MAKE_NEXMON\n"
        printf "UNAME_STRING:\t$UNAME_STRING\n"
        printf "UNAME_STRING7:\t$UNAME_STRING7\n"
        printf "UNAME_STRING7L:\t$UNAME_STRING7L\n"
        printf "UNAME_STRING8:\t$UNAME_STRING8\n"
        printf "UNAME_STRING8L:\t$UNAME_STRING8\n"
        printf "REPO_ROOT:\t$REPO_ROOT\n"
	printf "KERNEL_SRC_DIR:\t&KERNEL_SRC_DIR\n"
        printf "KERNEL_OUT_DIR_V6:\t\t$KERNEL_OUT_DIR_V6\n"
        printf "KERNEL_OUT_DIR_V7:\t\t$KERNEL_OUT_DIR_V7\n"
        printf "KERNEL_OUT_DIR_V7L:\t\t$KERNEL_OUT_DIR_V7L\n"
        printf "KERNEL_OUT_DIR_V8:\t\t$KERNEL_OUT_DIR_V8\n"
        printf "KERNEL_OUT_DIR_V8L:\t\t$KERNEL_OUT_DIR_V8L\n"
        printf "HEAD_SRC_DIR:\t$HEAD_SRC_DIR\n"
        printf "GIT_BRANCH:\t$GIT_BRANCH\n"
        printf "PKG_TMP:\t$PKG_TMP\n"
        printf "PKG_DIR:\t$PKG_DIR\n"
        printf "MOD_DIR:\t$MOD_DIR\n"
        printf "FIRMWARE_DIR:\t$FIRMWARE_DIR\n"
        printf "NEXMON_DIR:\t$NEXMON_DIR\n"
        printf "NEW_VERSION:\t$NEW_VERSION\n"
        printf "\nFIRMWARE INFO:\n\n"
        if [ -f ${FIRMWARE_DIR}/extra/git_hash ]; then
            FW_GIT_HASH=`cat ${FIRMWARE_DIR}/extra/git_hash`
        fi
        printf "FW_GIT_HASH:\t$FW_GIT_HASH\n"
    fi
}

function usage() {
  cat << EOF
usage: re4sonbuild [options]
 This will build the Kali-Pi Kernel.
 OPTIONS:
    -h        Show this message
    -c        Clean source directories (i.e. make mrproper - run this before compiling new kernels)
    -e        Build headers for architecture reasonbuild is currently running on(only for native compilation)
    -n        Build kernel natively for architecture reasonbuild is currently running on
    -r        The remote github repo to clone in user/repo format
              Default: $GIT_REPO
    -p        Create packages only (no compilation - expects tar.xz input files in package directory)
    -b        The git branch to use
              Default: Default git branch of repo
    -6        The config file to use when compiling for Raspi v6
              Default: $V6_DEFAULT_CONFIG
    -7        The config file to use when compiling for Raspi v7
              Default: $V7_DEFAULT_CONFIG
    -8        The config file to use when compiling for Raspi v8
              Default: $V8_DEFAULT_CONFIG

EOF
}

function clean() {
    if [ ! -d $KERNEL_SRC_DIR ]; then
        setup_repos
    fi	
    clean_kernel_src_dir
    echo "**** Cleaning up kernel working dirs ****"
    if [ -d $KERNEL_OUT_DIR_V6 ]; then
	rm -rf $KERNEL_OUT_DIR_V6
	mkdir $KERNEL_OUT_DIR_V6
	chown $SUDO_USER:$SUDO_USER $KERNEL_OUT_DIR_V6
        echo "**** Cleaning ${KERNEL_OUT_DIR_V6} ****"
        if [ "$V6_VERSION" != "" ]; then
            echo "**** Setting version to ${V6_VERSION} ****"
            ((version = $V6_VERSION -1))
            echo $version > $KERNEL_OUT_DIR_V6\/\.version
        fi
    fi
    if [ -d $KERNEL_OUT_DIR_V7 ]; then
	rm -rf $KERNEL_OUT_DIR_V7
	mkdir $KERNEL_OUT_DIR_V7
	chown $SUDO_USER:$SUDO_USER $KERNEL_OUT_DIR_V7
        echo "**** Cleaning ${KERNEL_OUT_DIR_V7} ****"
        if [ "$V7_VERSION" != "" ]; then
            echo "**** Setting version to ${V7_VERSION} ****"
            ((version = $V7_VERSION -1))
            echo $version > $KERNEL_OUT_DIR_V7\/\.version
        fi
    fi
    if [ -d $KERNEL_OUT_DIR_V7L ]; then
	rm -rf $KERNEL_OUT_DIR_V7L
	mkdir $KERNEL_OUT_DIR_V7L
	chown $SUDO_USER:$SUDO_USER $KERNEL_OUT_DIR_V7L
        echo "**** Cleaning ${KERNEL_OUT_DIR_V7L} ****"
        if [ "$V7L_VERSION" != "" ]; then
            echo "**** Setting version to ${V7L_VERSION} ****"
            ((version = $V7L_VERSION -1))
            echo $version > $KERNEL_OUT_DIR_V7L\/\.version
        fi
    fi
    if [ -d $KERNEL_OUT_DIR_V8 ]; then
	rm -rf $KERNEL_OUT_DIR_V8
	mkdir $KERNEL_OUT_DIR_V8
	chown $SUDO_USER:$SUDO_USER $KERNEL_OUT_DIR_V8
        echo "**** Cleaning ${KERNEL_OUT_DIR_V8} ****"
        if [ "$V8_VERSION" != "" ]; then
            echo "**** Setting version to ${V8_VERSION} ****"
            ((version = $V8_VERSION -1))
            echo $version > $KERNEL_OUT_DIR_V8\/\.version
        fi
    fi
    if [ -d $KERNEL_OUT_DIR_V8L ]; then
	rm -rf $KERNEL_OUT_DIR_V8L
	mkdir $KERNEL_OUT_DIR_V8L
	chown $SUDO_USER:$SUDO_USER $KERNEL_OUT_DIR_V8L
        echo "**** Cleaning ${KERNEL_OUT_DIR_V8L} ****"
        if [ "$V8L_VERSION" != "" ]; then
            echo "**** Setting version to ${V8L_VERSION} ****"
            ((version = $V8L_VERSION -1))
            echo $version > $KERNEL_OUT_DIR_V8L\/\.version
        fi
    fi
    echo "**** Kernel source directories cleaned up ****"
    if [ -d $KERNEL_HEADERS_OUT_DIR ]; then
        rm -rf $KERNEL_HEADERS_OUT_DIR
        mkdir -p $KERNEL_HEADERS_OUT_DIR
        chown $SUDO_USER:$SUDO_USER $KERNEL_HEADERS_OUT_DIR
    fi
    cd -
}

function clean_kernel_src_dir (){
    echo "**** Cleaning up kernel source ****"
    cd $KERNEL_SRC_DIR
    make mrproper
    git checkout ${GIT_BRANCH}
    ##get_4d_obj
    cd -
}

function clone_source() {
    echo "**** CLONING to ${REPO_ROOT}${GIT_REPO} ****"
    echo "REPO: ${GIT_REPO}"
    echo "BRANCH: ${GIT_BRANCH}"
    git clone --recursive https://github.com/${GIT_REPO} $KERNEL_SRC_DIR 
}

function setup_repos(){
    printf "\n**** SETTING UP REPOSITORIES ****\n"

    if [ ! -d $REPO_ROOT ]; then
        mkdir $REPO_ROOT
    fi

    if [ "$GIT_REPO" != "raspberrypi/linux" ]; then

        if [[ "$GIT_REPO" =~ "http" ]]; then
            echo "please provide a valid githubuser/repo path"
            usage
            exit 1
        fi
    fi

    if [ ! -d $KERNEL_SRC_DIR ]; then
        mkdir -p $KERNEL_SRC_DIR
        clone_source
    fi
    if [ ! -d ${MOD_DIR} ]; then
	mkdir -p ${MOD_DIR}
    fi
    if [ ! -d $HEAD_SRC_DIR ]; then
	mkdir -p $HEAD_SRC_DIR
    fi	

#    if [ ! -d $TOOLS_DIR ]; then
#        echo "**** CLONING TOOL REPO ****"
#        git clone --depth 1 https://github.com/raspberrypi/tools $TOOLS_DIR
#    fi

    if [ ! -d $FIRMWARE_DIR ]; then
        echo "**** CLONING RPI-DISTRO-FIRMWARE REPO ****"
        git clone --depth 1 https://github.com/${FW_REPO} $FIRMWARE_DIR
    fi
}


function pull_tools() {
    # make sure tools dir is up to date
    printf "\n**** UPDATING TOOLS REPOSITORY ****\n"
    cd $TOOLS_DIR
    git pull
    cd -
}

function pull_firmware() {
    # make sure firmware dir is up to date
    printf "\n**** UPDATING FIRMWARE REPOSITORY ****\n"
    cd $FIRMWARE_DIR
    git checkout $FW_BRANCH
    git pull
    cd -
}

function setup_pkg_dir() {
    # Set up the debian package folder
    printf "\n**** SETTING UP DEBIAN PACKAGE DIRECTORY ****\n"
    mkdir $PKG_DIR
    cp -r $FIRMWARE_DIR/* $PKG_DIR
    # Remove the pre-compiled modules - we'll compile them ourselves
    if [ -d  $PKG_DIR/modules ]; then
        rm -r $PKG_DIR/modules/*
    fi
    mkdir -p $PKG_DIR/headers/usr/src/
}

function setup_native_v6_pkg_dir() {
    # Set up the debian package folder
    printf "\n**** SETTING UP DEBIAN PACKAGE DIRECTORY v6 ****\n"
    mkdir -p $PKG_DIR/boot/overlays/
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING/
}

function setup_native_v7_pkg_dir() {
    # Set up the debian package folder
    printf "\n**** SETTING UP DEBIAN PACKAGE DIRECTORY v7 ****\n"
    mkdir -p $PKG_DIR/boot/overlays/
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7/
}

function setup_native_v7l_pkg_dir() {
    # Set up the debian package folder
    printf "\n**** SETTING UP DEBIAN PACKAGE DIRECTORY v7l ****\n"
    mkdir -p $PKG_DIR/boot/overlays/
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7L/
}

function setup_native_v8_pkg_dir() {
    # Set up the debian package folder
    printf "\n**** SETTING UP DEBIAN PACKAGE DIRECTORY v8 ****\n"
    mkdir -p $PKG_DIR/boot/overlays/
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8/
}

function setup_native_v8l_pkg_dir() {
    # Set up the debian package folder
    printf "\n**** SETTING UP DEBIAN PACKAGE DIRECTORY v8l ****\n"
    mkdir -p $PKG_DIR/boot/overlays/
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8L/
}

function get_4d_obj() {
    ## Get the object files back for the 4D-Hat drivers after a clean
    printf "\n****  RESTORING 4D-HAT OBJECT FILES    ****\n"
    cd $KERNEL_SRC_DIR
    if [ ! -f compress-v6.o ]; then
        git checkout drivers/video/4d-hats/compress-v6.o
    fi
    if [ ! -f compress-v7.o ]; then
        git checkout drivers/video/4d-hats/compress-v7.o
    fi
    cd -
}

function update_kernel_source(){
    cd $KERNEL_SRC_DIR
    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    ##get_4d_obj 
    cd -
}

function prep_kernel_out_dir() {
    kernel_out_dir=$1
    printf "\n**** PREPARING WORKING DIRECTORY $kernel_out_dir ****\n"
    if [ ! -d $kernel_out_dir ]; then
        mkdir -p $kernel_out_dir 
    fi
    ## The following workarounds are required for a successful compilation
    ## Copy 4D pre-compiled object files
    ##get_4d_obj
    if [ ! -d $kernel_out_dir/drivers/video/4d-hats ]; then
        mkdir -p $kernel_out_dir/drivers/video/4d-hats 
    fi
    ##cp $KERNEL_SRC_DIR/drivers/video/4d-hats/compress-*.o $kernel_out_dir/drivers/video/4d-hats/
    ## Copy rtl8812au files required for the compilation
    ## The path in the driver source has to be fixed before we can renove this workaround
    if [ ! -d $kernel_out_dir/drivers/net/wireless/realtek/rtl8812au/hal/phydm ]; then
        mkdir -p $kernel_out_dir/drivers/net/wireless/realtek/rtl8812au/hal/phydm
    fi
    cp -rf $KERNEL_SRC_DIR/drivers/net/wireless/realtek/rtl8812au/hal/phydm/phydm.mk $kernel_out_dir/drivers/net/wireless/realtek/rtl8812au/hal/phydm/
    ## Copy rtl8192eu files required for the compilation
    ## The path in the driver source has to be fixed before we can renove this workaround
    if [ ! -d $kernel_out_dir/drivers/net/wireless/realtek/rtl8192eu/hal/phydm ]; then
        mkdir -p $kernel_out_dir/drivers/net/wireless/realtek/rtl8192eu/hal/phydm
    fi
    cp -rf $KERNEL_SRC_DIR/drivers/net/wireless/realtek/rtl8192eu/hal/phydm/phydm.mk $kernel_out_dir/drivers/net/wireless/realtek/rtl8192eu/hal/phydm/
}

function make_v6() {
    # RasPi v6 build
    printf "\n**** COMPILING V6 KERNEL (ARMEL) ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V6
    CCPREFIX=${TOOLS_DIR}/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
    if [ ! -f .config ]; then
        if [ "$V6_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V6_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V6/.config
        else
            cp ${V6_CONFIG} $KERNEL_OUT_DIR_V6/.config
        fi
    fi
    ##make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V6 -C $KERNEL_SRC_DIR menuconfig
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V6 -C $KERNEL_SRC_DIR olddefconfig
    echo "**** SAVING A COPY OF YOUR v6 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V6/.config $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig
    echo "**** COMPILING v6 KERNEL ****"
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V6 -C $KERNEL_SRC_DIR -j${NUM_CPUS} -k zImage modules dtbs
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V6 -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    $KERNEL_SRC_DIR/scripts/mkknlimg $KERNEL_OUT_DIR_V6/arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*/build
    rm -f ${MOD_DIR}/lib/modules/*/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING/
    cp $KERNEL_OUT_DIR_V6/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING/
}

function make_v7() {
    # RasPi v7 build
    printf "\n**** COMPILING V7 KERNEL (ARMHF) ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V7
    CCPREFIX=${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
    if [ ! -f .config ]; then
        if [ "$V7_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V7_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V7/.config
        else
            cp ${V7_CONFIG} $KERNEL_OUT_DIR_V7/.config
        fi
    fi
    ##make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V7 -C $KERNEL_SRC_DIR menuconfig
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V7 -C $KERNEL_SRC_DIR olddefconfig
    echo "**** SAVING A COPY OF YOUR v7 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V7/.config $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig
    echo "**** COMPILING v7 KERNEL ****"
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V7 -C $KERNEL_SRC_DIR -j${NUM_CPUS} -k zImage modules dtbs
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V7 -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    $KERNEL_SRC_DIR/scripts/mkknlimg $KERNEL_OUT_DIR_V7/arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v7+/build
    rm -f ${MOD_DIR}/lib/modules/*-v7+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7/
    cp $KERNEL_OUT_DIR_V7/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7/
}

function make_v7l() {
    # RasPi vl7 build
    printf "\n**** COMPILING V7L KERNEL (ARMHF) ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V7L
    CCPREFIX=${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
    if [ ! -f .config ]; then
        if [ "$V7L_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V7L_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V7L/.config
        else
            cp ${V7L_CONFIG} $KERNEL_OUT_DIR_V7L/.config
        fi
    fi
    ##make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V7L -C $KERNEL_SRC_DIR menuconfig
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V7L -C $KERNEL_SRC_DIR olddefconfig
    echo "**** SAVING A COPY OF YOUR v7l CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi7l_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V7L/.config $KERNEL_BUILDER_DIR/configs/re4son_pi7l_defconfig
    echo "**** COMPILING v7l KERNEL ****"
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V7L -C $KERNEL_SRC_DIR -j${NUM_CPUS} -k zImage modules dtbs
    make ARCH=arm CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V7L -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    $KERNEL_SRC_DIR/scripts/mkknlimg $KERNEL_OUT_DIR_V7L/arch/arm/boot/zImage $PKG_DIR/boot/kernel7l.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v7l+/build
    rm -f ${MOD_DIR}/lib/modules/*-v7l+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7L/
    cp $KERNEL_OUT_DIR_V7L/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7L/
}

function make_v8() {
    # RasPi v8 build
    printf "\n**** COMPILING V8 KERNEL (ARM64) ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V8
    CCPREFIX=aarch64-linux-gnu-
    if [ ! -f .config ]; then
        if [ "$V8_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V8_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V8/.config
        else
            cp ${V8_CONFIG} $KERNEL_OUT_DIR_V8/.config
        fi
    fi
    ##make ARCH=arm64 CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V8 -C $KERNEL_SRC_DIR menuconfig
    make ARCH=arm64 CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V8 -C $KERNEL_SRC_DIR olddefconfig
    echo "**** SAVING A COPY OF YOUR v8 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi8_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V8/.config $KERNEL_BUILDER_DIR/configs/re4son_pi8_defconfig
    echo "**** COMPILING v8 KERNEL ****"
    make ARCH=arm64 CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V8 -C $KERNEL_SRC_DIR -j${NUM_CPUS} 
    make ARCH=arm64 CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V8 -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ##
    ## Name the kernel "kernel8-alt.img" for now to prevent it from automatically being loaded
    ## To use it, just rename it to kernel8.img on the device
    $KERNEL_SRC_DIR/scripts/mkknlimg --dtok $KERNEL_OUT_DIR_V8/arch/arm64/boot/Image $PKG_DIR/boot/kernel8-alt.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v8+/build
    rm -f ${MOD_DIR}/lib/modules/*-v8+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8/
    cp $KERNEL_OUT_DIR_V8/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8/
}

function make_v8l() {
    # RasPi v8l build
    printf "\n**** COMPILING V8L KERNEL (ARM64) ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V8L
    CCPREFIX=aarch64-linux-gnu-
    if [ ! -f .config ]; then
        if [ "$V8L_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V8L_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V8L/.config
        else
            cp ${V8L_CONFIG} $KERNEL_OUT_DIR_V8L/.config
        fi
    fi
    ##make ARCH=arm64 CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V8L -C $KERNEL_SRC_DIR menuconfig
    make ARCH=arm64 CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V8L -C $KERNEL_SRC_DIR olddefconfig
    echo "**** SAVING A COPY OF YOUR v8l CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi8l_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V8L/.config $KERNEL_BUILDER_DIR/configs/re4son_pi8l_defconfig
    echo "**** COMPILING v8l KERNEL ****"
    make ARCH=arm64 CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V8L -C $KERNEL_SRC_DIR -j${NUM_CPUS} 
    make ARCH=arm64 CROSS_COMPILE=${CCPREFIX} O=$KERNEL_OUT_DIR_V8L -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ##
    ## Name the kernel "kernel8-alt.img" for now to prevent it from automatically being loaded
    ## To use it, just rename it to kernel8.img on the device
    $KERNEL_SRC_DIR/scripts/mkknlimg --dtok $KERNEL_OUT_DIR_V8L/arch/arm64/boot/Image $PKG_DIR/boot/kernel8l-alt.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v8l+/build
    rm -f ${MOD_DIR}/lib/modules/*-v8l+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8L/
    cp $KERNEL_OUT_DIR_V8L/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8L/
}

function make_native_v6() {
    # RasPi v6 build
    printf "\n**** COMPILING V6 KERNEL (ARMEL) NATIVELY****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V6
    if [ ! -f .config ]; then
        if [ "$V6_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V6_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V6/.config
        else
            cp ${V6_CONFIG} $KERNEL_OUT_DIR_V6/.config
        fi
    fi
    make O=$KERNEL_OUT_DIR_V6 -C $KERNEL_SRC_DIR menuconfig
    echo "**** SAVING A COPY OF YOUR v6 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V6/.config $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig
    echo "**** COMPILING v6 KERNEL ****"
    make O=$KERNEL_OUT_DIR_V6 -C $KERNEL_SRC_DIR -j${NUM_CPUS} -k zImage modules dtbs
    make O=$KERNEL_OUT_DIR_V6 -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    $KERNEL_SRC_DIR/scripts/mkknlimg $KERNEL_OUT_DIR_V6/arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*/build
    rm -f ${MOD_DIR}/lib/modules/*/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy away the module dir so we cak use it for compiling drivers if we want
    cp -r ${MOD_DIR}/lib/modules/*/* ${KERNEL_MOD_DIR}/
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING/
    cp $KERNEL_OUT_DIR_V6/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING/
    cp -f $KERNEL_OUT_DIR_V6/Module.symvers $KERNEL_BUILDER_DIR/extra/
    cp -f $KERNEL_OUT_DIR_V6/System.map $KERNEL_BUILDER_DIR/extra/
}

function make_native_v7() {
    # RasPi v7 build
    printf "\n**** COMPILING V7 KERNEL (ARMHF) NATIVELY ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V7
    if [ ! -f .config ]; then
        if [ "$V7_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V7_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V7/.config
        else
            cp ${V7_CONFIG} $KERNEL_OUT_DIR_V7/.config
        fi
    fi
    make O=$KERNEL_OUT_DIR_V7 -C $KERNEL_SRC_DIR menuconfig
    echo "**** SAVING A COPY OF YOUR v7 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V7/.config $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig
    echo "**** COMPILING v7 KERNEL ****"
    make O=$KERNEL_OUT_DIR_V7 -C $KERNEL_SRC_DIR -j${NUM_CPUS} -k zImage modules dtbs
    make O=$KERNEL_OUT_DIR_V7 -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    $KERNEL_SRC_DIR/scripts/mkknlimg $KERNEL_OUT_DIR_V7/arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v7+/build
    rm -f ${MOD_DIR}/lib/modules/*-v7+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy away the module dir so we cak use it for compiling drivers if we want
    cp -r ${MOD_DIR}/lib/modules/*/* ${KERNEL_MOD_DIR}/
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7/
    cp $KERNEL_OUT_DIR_V7/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7/
    cp -f $KERNEL_OUT_DIR_V7/Module.symvers $KERNEL_BUILDER_DIR/extra/Module7.symvers
    cp -f $KERNEL_OUT_DIR_V7/System.map $KERNEL_BUILDER_DIR/extra/System7.map
}

function make_native_v7l() {
    # RasPi v7l build
    printf "\n**** COMPILING V7L KERNEL (ARMHF) NATIVELY ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V7L
    if [ ! -f .config ]; then
        if [ "$V7L_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V7L_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V7L/.config
        else
            cp ${V7L_CONFIG} $KERNEL_OUT_DIR_V7L/.config
        fi
    fi
    make O=$KERNEL_OUT_DIR_V7L -C $KERNEL_SRC_DIR menuconfig
    echo "**** SAVING A COPY OF YOUR v7l CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi7l_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V7L/.config $KERNEL_BUILDER_DIR/configs/re4son_pi7l_defconfig
    echo "**** COMPILING v7l KERNEL ****"
    make O=$KERNEL_OUT_DIR_V7L -C $KERNEL_SRC_DIR -j${NUM_CPUS} -k zImage modules dtbs
    make O=$KERNEL_OUT_DIR_V7L -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    $KERNEL_SRC_DIR/scripts/mkknlimg $KERNEL_OUT_DIR_V7L/arch/arm/boot/zImage $PKG_DIR/boot/kernel7l.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v7l+/build
    rm -f ${MOD_DIR}/lib/modules/*-v7l+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy away the module dir so we cak use it for compiling drivers if we want
    cp -r ${MOD_DIR}/lib/modules/*/* ${KERNEL_MOD_DIR}/
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7L/
    cp $KERNEL_OUT_DIR_V7L/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7L/
    cp -f $KERNEL_OUT_DIR_V7L/Module.symvers $KERNEL_BUILDER_DIR/extra/Module7l.symvers
    cp -f $KERNEL_OUT_DIR_V7L/System.map $KERNEL_BUILDER_DIR/extra/System7l.map
}

function make_native_v8() {
    # RasPi v8 build
    printf "\n**** COMPILING V8 KERNEL (ARM64) NATIVELY ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V8
    if [ ! -f .config ]; then
        if [ "$V8_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V8_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V8/.config
        else
            cp ${V8_CONFIG} $KERNEL_OUT_DIR_V8/.config
        fi
    fi
    make O=$KERNEL_OUT_DIR_V8 -C $KERNEL_SRC_DIR menuconfig
    echo "**** SAVING A COPY OF YOUR v8 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi8_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V8/.config $KERNEL_BUILDER_DIR/configs/re4son_pi8_defconfig
    echo "**** COMPILING v8 KERNEL ****"
    make O=$KERNEL_OUT_DIR_V8 -C $KERNEL_SRC_DIR -j${NUM_CPUS}
    make O=$KERNEL_OUT_DIR_V8 -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ##
    ## Name the kernel "kernel8-alt.img" for now to prevent it from automatically being loaded
    ## To use it, just rename it to kernel8.img on the device
    $KERNEL_SRC_DIR/scripts/mkknlimg --dtok $KERNEL_OUT_DIR_V8/arch/arm64/boot/Image $PKG_DIR/boot/kernel8-alt.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v8+/build
    rm -f ${MOD_DIR}/lib/modules/*-v8+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy away the module dir so we cak use it for compiling drivers if we want
    cp -r ${MOD_DIR}/lib/modules/*/* ${KERNEL_MOD_DIR}/
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8/
    cp $KERNEL_OUT_DIR_V8/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8/
    cp -f $KERNEL_OUT_DIR_V8/Module.symvers $KERNEL_BUILDER_DIR/extra/Module8.symvers
    cp -f $KERNEL_OUT_DIR_V8/System.map $KERNEL_BUILDER_DIR/extra/System8.map
}

function make_native_v8l() {
    # RasPi v8l build
    printf "\n**** COMPILING V8L KERNEL (ARM64) NATIVELY ****\n"
    prep_kernel_out_dir $KERNEL_OUT_DIR_V8L
    if [ ! -f .config ]; then
        if [ "$V8L_CONFIG" == "" ]; then
            cp $KERNEL_SRC_DIR/${V8L_DEFAULT_CONFIG} $KERNEL_OUT_DIR_V8L/.config
        else
            cp ${V8L_CONFIG} $KERNEL_OUT_DIR_V8L/.config
        fi
    fi
    make O=$KERNEL_OUT_DIR_V8L -C $KERNEL_SRC_DIR menuconfig
    echo "**** SAVING A COPY OF YOUR v8l CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi8l_defconfig ****"
    cp -f $KERNEL_OUT_DIR_V8L/.config $KERNEL_BUILDER_DIR/configs/re4son_pi8l_defconfig
    echo "**** COMPILING v8l KERNEL ****"
    make O=$KERNEL_OUT_DIR_V8L -C $KERNEL_SRC_DIR -j${NUM_CPUS}
    make O=$KERNEL_OUT_DIR_V8L -C $KERNEL_SRC_DIR INSTALL_MOD_PATH=${MOD_DIR} -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ##
    ## Name the kernel "kernel8l-alt.img" for now to prevent it from automatically being loaded
    ## To use it, just rename it to kernel8l.img on the device
    $KERNEL_SRC_DIR/scripts/mkknlimg --dtok $KERNEL_OUT_DIR_V8L/arch/arm64/boot/Image $PKG_DIR/boot/kernel8l-alt.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v8l+/build
    rm -f ${MOD_DIR}/lib/modules/*-v8l+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy away the module dir so we cak use it for compiling drivers if we want
    cp -r ${MOD_DIR}/lib/modules/*/* ${KERNEL_MOD_DIR}/
    ## Copy our Module.symvers across
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8L/
    cp $KERNEL_OUT_DIR_V8L/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING8L/
    cp -f $KERNEL_OUT_DIR_V8L/Module.symvers $KERNEL_BUILDER_DIR/extra/Module8l.symvers
    cp -f $KERNEL_OUT_DIR_V8L/System.map $KERNEL_BUILDER_DIR/extra/System8l.map
}

function make_headers (){
    config=$1
    ccprefix=$2
    echo $config
    echo $ccprefix
    cd $KERNEL_SRC_DIR
    if [ ! $ccprefix ]; then
        make distclean $config modules_prepare
    elif [ $ccprefix == "aarch64-linux-gnu-" ]; then
	make ARCH=arm64 CROSS_COMPILE=${ccprefix} distclean $config modules_prepare
    else
	make ARCH=arm CROSS_COMPILE=${ccprefix} distclean $config modules_prepare
    fi
    cd -
}

function copy_files (){
    ver=$1
    destdir=$KERNEL_HEADERS_OUT_DIR/headers/usr/src/linux-headers-$ver
    if [ -d $destdir ]; then
        rm -rf $destdir
    fi
    mkdir -p "$destdir"/tools/include
    mkdir -p $KERNEL_HEADERS_OUT_DIR/headers/lib/modules/$ver
    rsync -aHAX \
	--files-from=<(cd $KERNEL_SRC_DIR; find -name Makefile\* -o -name Kconfig\* -o -name \*.pl) $KERNEL_SRC_DIR/ $destdir/
    rsync -aHAX \
	--files-from=<(cd $KERNEL_SRC_DIR; find arch/arm*/include tools/include include scripts -type f) $KERNEL_SRC_DIR/ $destdir/
    rsync -aHAX \
	--files-from=<(cd $KERNEL_SRC_DIR; find arch/arm* -name module.lds -o -name Kbuild.platforms -o -name Platform) $KERNEL_SRC_DIR/ $destdir/
    rsync -aHAX \
	--files-from=<(cd $KERNEL_SRC_DIR; find `find arch/arm* -name include -o -name scripts -type d` -type f) $KERNEL_SRC_DIR/ $destdir/
    rsync -aHAX \
	--files-from=<(cd $KERNEL_SRC_DIR; find arch/arm*/include .config tools/include include scripts -type f) $KERNEL_SRC_DIR/ $destdir/
    ln -sf "/usr/src/linux-headers-$ver" "$KERNEL_HEADERS_OUT_DIR/headers/lib/modules/$ver/build"
    ## Module.symvers are going to be provided by the kernel build
}


function pkg_headers () {
    printf "\n**** Creating $KERNEL_BUILDER_DIR/re4son_headers_${NAT_ARCH}_${NEW_VERSION}.tar.xz ****\n"
    cd $KERNEL_HEADERS_OUT_DIR
    XZ_OPT="--threads=0" tar -cJf $KERNEL_BUILDER_DIR/re4son_headers_${NAT_ARCH}_${NEW_VERSION}.tar.xz headers
    printf  "\n@@@@ The re4son-headers_${NAT_ARCH}_${NEW_VERSION}.tar.xz archive should now be available in ${KERNEL_BUILDER_DIR} @@@@\n\n"
    cd -
}

function pkg_kernel() {
    printf "\n**** Creating $KERNEL_BUILDER_DIR/re4son_kernel_${NAT_ARCH}_${NEW_VERSION}.tar.xz ****\n"
    cd $PKG_DIR
    XZ_OPT="--threads=0" tar -cJf $KERNEL_BUILDER_DIR/re4son_kernel_${NAT_ARCH}_${NEW_VERSION}.tar.xz *
    printf  "\n@@@@ The re4son-kernel_${NAT_ARCH}_${NEW_VERSION}.tar.xz archive should now be available in ${KERNEL_BUILDER_DIR} @@@@\n\n"
    cd -
}


function make_nexmon () {
    ## Compiling nexmon firmware patches for Raspberry Pi 3
    cp -r ${MOD_DIR}/lib/modules/*-v7+/* ${KERNEL_MOD_DIR}/
    cd ${NEXMON_DIR}
    source setup_env.sh
    cd patches/bcm43438/7_45_41_26/nexmon
    make
    cd $KERNEL_BUILDER_DIR
}

function make_native_nexmon () {
    ## Compiling nexmon firmware patches
    cd ${NEXMON_DIR}
    source setup_env.sh
    cd patches/bcm43438/7_45_41_26/nexmon
    make
    cd $KERNEL_BUILDER_DIR
}

function import_archives() {
    rm -rf $PKG_DIR/headers
    cd $PKG_IN
    for i in *.tar.xz; do printf "\n**** Extracting $i to ${PKG_DIR} ****\n"; tar -xJf $i -C ${PKG_DIR}/; done
    ########### Temporarily remove kernel8l until we manage the partition size properly
    ## No longer required, checking space during installation
    ##rm -f $PKG_DIR/boot/kernel8l-alt.img
    ##rm -rf $PKG_DIR/modules/4.19.55-Re4son-v8l+
    ##rm -rf $PKG_DIR/headers/lib/modules/4.19.55-Re4son-v8l+
    ##rm -rf $PKG_DIR/headers/usr/src/linux-headers-4.19.55-Re4son-v8l+
    cd -
}

function create_debs() {
    # copy overlays
    cp -r $KERNEL_BUILDER_DIR/boot/* $PKG_DIR/boot

    # tar up firmware
    cd $PKG_TMP
    tar czf kalipi-firmware_${NEW_VERSION}.orig.tar.gz kalipi-firmware_${NEW_VERSION}

    # copy debian files to package directory
    cp -r $FIRMWARE_DIR/debian $PKG_DIR
    touch $PKG_DIR/debian/files
    ##cd $PKG_DIR/debian
    ##sh ./gen_bootloader_postinst_preinst.sh

    cd $PKG_DIR
    dch -b -v ${NEW_VERSION} -D stable --force-distribution "Re4son Kernel source ${GIT_BRANCH}; firmware ${FW_BRANCH}"
    debuild --no-lintian -b -aarmel -us -uc
    debuild --no-lintian -ePATH=${PATH}:${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin -b -aarmhf -us -uc
    debuild --no-lintian -b -aarm64 -us -uc
}

function create_tar() {
    cd $PKG_TMP
    mkdir re4son-kernel_${NEW_VERSION}
    mkdir re4son-kernel_${NEW_VERSION}_armel
    mkdir re4son-kernel_${NEW_VERSION}_armhf
    mkdir re4son-kernel_${NEW_VERSION}_arm64
    mkdir re4son-kernel_${NEW_VERSION}/docs
    mkdir re4son-kernel_${NEW_VERSION}/dts
    mkdir re4son-kernel_${NEW_VERSION}/tools
    mkdir re4son-kernel_${NEW_VERSION}/firmware
    mkdir re4son-kernel_${NEW_VERSION}/repo
    mkdir re4son-kernel_${NEW_VERSION}/nexmon
    cp *armhf.deb re4son-kernel_${NEW_VERSION}
    cp *armel.deb re4son-kernel_${NEW_VERSION}_armel
    cp *armhf.deb re4son-kernel_${NEW_VERSION}_armhf
    cp *arm64.deb re4son-kernel_${NEW_VERSION}_arm64
    cp -r $KERNEL_BUILDER_DIR/nexmon/* re4son-kernel_${NEW_VERSION}/nexmon
    cp $KERNEL_BUILDER_DIR/install.sh re4son-kernel_${NEW_VERSION}
    cp $KERNEL_BUILDER_DIR/dts/*.dts re4son-kernel_${NEW_VERSION}/dts
    cp $KERNEL_BUILDER_DIR/docs/INSTALL re4son-kernel_${NEW_VERSION}
    cp $KERNEL_BUILDER_DIR/docs/* re4son-kernel_${NEW_VERSION}/docs
    cp $KERNEL_BUILDER_DIR/configs/* re4son-kernel_${NEW_VERSION}/docs
    cp $KERNEL_BUILDER_DIR/Re4son-Pi-TFT-Setup/re4son-pi-tft-setup re4son-kernel_${NEW_VERSION}
    cp $KERNEL_BUILDER_DIR/Re4son-Pi-TFT-Setup/adafruit-pitft-touch-cal re4son-kernel_${NEW_VERSION}/tools
    cp $KERNEL_BUILDER_DIR/tools/* re4son-kernel_${NEW_VERSION}/tools
    cp $KERNEL_BUILDER_DIR/firmware/* re4son-kernel_${NEW_VERSION}/firmware
    cp $KERNEL_BUILDER_DIR/repo/* re4son-kernel_${NEW_VERSION}/repo
    chmod +x re4son-kernel_${NEW_VERSION}/install.sh
    chmod +x re4son-kernel_${NEW_VERSION}/re4son-pi-tft-setup
    chmod +x re4son-kernel_${NEW_VERSION}/tools/adafruit-pitft-touch-cal
    tar cJf re4son-kernel_${NEW_VERSION}.tar.xz re4son-kernel_${NEW_VERSION}
    mv -f re4son-kernel_${NEW_VERSION}.tar.xz $KERNEL_BUILDER_DIR
    sha256sum $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}.tar.xz > $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}.tar.xz.sha256
    chown $SUDO_UID:$SUDO_GID $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}.tar.xz* $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}.tar.xz.sha256
    tar cJf re4son-kernel_${NEW_VERSION}_armel.tar.xz re4son-kernel_${NEW_VERSION}_armel
    mv -f re4son-kernel_${NEW_VERSION}_armel.tar.xz $KERNEL_BUILDER_DIR
    sha256sum $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_armel.tar.xz > $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_armel.tar.xz.sha256
    chown $SUDO_UID:$SUDO_GID $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_armel.tar.xz* $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_armel.tar.xz.sha256
    tar cJf re4son-kernel_${NEW_VERSION}_armhf.tar.xz re4son-kernel_${NEW_VERSION}_armhf
    mv -f re4son-kernel_${NEW_VERSION}_armhf.tar.xz $KERNEL_BUILDER_DIR
    sha256sum $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_armhf.tar.xz > $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_armhf.tar.xz.sha256
    chown $SUDO_UID:$SUDO_GID $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_armhf.tar.xz* $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_armhf.tar.xz.sha256
    tar cJf re4son-kernel_${NEW_VERSION}_arm64.tar.xz re4son-kernel_${NEW_VERSION}_arm64
    mv -f re4son-kernel_${NEW_VERSION}_arm64.tar.xz $KERNEL_BUILDER_DIR
    sha256sum $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_arm64.tar.xz > $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_arm64.tar.xz.sha256
    chown $SUDO_UID:$SUDO_GID $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_arm64.tar.xz* $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}_arm64.tar.xz.sha256
    printf  "\n@@@@ The re4son-kernel_${NEW_VERSION}.tar.xz archive should now be available in ${KERNEL_BUILDER_DIR} @@@@\n\n"
}



##                                            ##
################################################
################################################

################################################
################################################
##                                            ##
##                    MAIN                    ##

check_root
debug_info
breakpoint "010-Root privileges checked"

while getopts "hb:cnpexr:6:7:8:" opt; do
  case "$opt" in
  h)  usage
      exit 0
      ;;
  b)  GIT_BRANCH="$OPTARG"
      ;;
  c)  clean
      exit 0
      ;;
  n)  NATIVE=true
      NAT_ARCH=`dpkg --print-architecture`
      ;;
  p)  MAKE_PKG=true
      ;;
  e)  MAKE_HEADERS=true
      if [ ! $NAT_ARCH ]; then
          NAT_ARCH=`dpkg --print-architecture`
      fi
      ;;
  x)  MAKE_NEXMON=true
      if [ ! $NAT_ARCH ]; then
          NAT_ARCH=`dpkg --print-architecture`
      fi
      ;;
  r)  GIT_REPO="$OPTARG"
      ;;
  6)  V6_CONFIG="$OPTARG"
      ;;
  7)  V7_CONFIG="$OPTARG"
      ;;
  8)  V8_CONFIG="$OPTARG"
      ;;
  \?) usage
      exit 1
      ;;
  esac
done

printf "\n\t**** USING ${NUM_CPUS} AVAILABLE CORES ****\n"


if [ ! $NATIVE ] && [ ! $MAKE_HEADERS ] && [ ! $MAKE_PKG ] && [ ! $MAKE_NEXMON ]; then

    setup_repos
    update_kernel_source
    breakpoint "020-Repos set up"

    ## Lets only update the repos when I'm sure they don't break anything.
    ##pull_tools
    ##breakpoint "030-Tools repo updated"

    pull_firmware
    breakpoint "040-Firmware repo updated"

    setup_pkg_dir
    debug_info
    breakpoint "050-Pkg dir set up"

    clean_kernel_src_dir

    make_v6
    make_headers $(basename $V6_DEFAULT_CONFIG) ${TOOLS_DIR}/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
    copy_files $UNAME_STRING
    clean_kernel_src_dir
    breakpoint "060-Kernel v6 compiled"

    make_v7
    debug_info
    make_headers $(basename $V7_DEFAULT_CONFIG) ${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
    copy_files $UNAME_STRING7
    clean_kernel_src_dir
    breakpoint "070-Kernel v7 compiled"

    make_v7l
    debug_info
    make_headers $(basename $V7L_DEFAULT_CONFIG) ${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
    copy_files $UNAME_STRING7L
    clean_kernel_src_dir
    breakpoint "070-Kernel v7l compiled"

    make_v8
    debug_info
    make_headers $(basename $V8_DEFAULT_CONFIG) aarch64-linux-gnu-
    copy_files $UNAME_STRING8
    clean_kernel_src_dir
    breakpoint "080-Kernel v8 compiled"

    make_v8l
    debug_info
    make_headers $(basename $V8L_DEFAULT_CONFIG) aarch64-linux-gnu-
    copy_files $UNAME_STRING8L
    clean_kernel_src_dir
    breakpoint "080-Kernel v8l compiled"

    cp -rf $KERNEL_HEADERS_OUT_DIR/headers $PKG_DIR/
    create_debs
    debug_info
    breakpoint "090-Debian packages created"

#    make_nexmon
#    breakpoint "090-Nexmon drivers compiled"

    create_tar
    debug_info

    exit 0

elif [ $NATIVE ]; then
    setup_repos
    if [ $NAT_ARCH == "armel" ]; then
        printf "\n\t**** Compiling natively on: $NAT_ARCH ****\n"
        setup_native_v6_pkg_dir
        debug_info
        breakpoint "150-Pkg dir set up"
        make_native_v6
        breakpoint "160-Kernel v6 compiled"
        pkg_kernel
    elif [ $NAT_ARCH == "armhf" ]; then
        printf "\n\t**** Compiling natively on: $NAT_ARCH ****\n"
        setup_native_v7_pkg_dir
        debug_info
        breakpoint "150-Pkg dir set up"
        make_native_v7
        breakpoint "160-Kernel v7 compiled"
        make_native_v7l
        breakpoint "160-Kernel v7l compiled"
        pkg_kernel
    elif [ $NAT_ARCH == "arm64" ]; then
        printf "\n\t**** Compiling natively on: $NAT_ARCH ****\n"
        setup_native_v8_pkg_dir
        debug_info
        breakpoint "150-Pkg dir set up"
        make_native_v8
        breakpoint "160-Kernel v8 compiled"
        make_native_v8l
        breakpoint "160-Kernel v8l compiled"
        pkg_kernel
    else
        printf"\n\t#### ERROR: Architecture $ARCH not supported. ####\n"
    fi
    exit 0
fi

if [ $MAKE_HEADERS ]; then
    printf "\n\t**** Building headers for: $NAT_ARCH ****\n"
    if [ $NAT_ARCH == "armel" ]; then
        debug_info
        breakpoint "200-Ready to build headers"
        make_headers $(basename $V6_DEFAULT_CONFIG)
        if [ -f ${KERNEL_OUT_DIR_V6}/extra/Module.symvers ]; then
            cp ${KERNEL_OUT_DIR_V6}/extra/Module.symvers ${KERNEL_HEADERS_OUT_DIR}/headers/usr/src/linux-headers-$ver/Module.symvers
        fi
        debug_info
        breakpoint "210-headers built"
        copy_files $UNAME_STRING
        debug_info
        breakpoint "220-headers copied"
        pkg_headers
    elif [ $NAT_ARCH == "armhf" ]; then
        debug_info
        breakpoint "200-Ready to build headers"
        make_headers $(basename $V7_DEFAULT_CONFIG)
        if [ -f ${KERNEL_OUT_DIR_V7}/extra/Module7.symvers ]; then
            cp ${KERNEL_OUT_DIR_V7}/extra/Module7.symvers ${KERNEL_HEADERS_OUT_DIR}/headers/usr/src/linux-headers-$ver/Module.symvers
        fi
        debug_info
        breakpoint "210-headers built"
        copy_files $UNAME_STRING7
        debug_info
        breakpoint "220-headers copied"
	clean_kernel_src_dir
        breakpoint "200-Ready to build headers 2"
        make_headers $(basename $V7L_DEFAULT_CONFIG)
        if [ -f ${KERNEL_OUT_DIR_V7L}/extra/Module7l.symvers ]; then
            cp ${KERNEL_OUT_DIR_V7L}/extra/Module7l.symvers ${KERNEL_HEADERS_OUT_DIR}/headers/usr/src/linux-headers-$ver/Module.symvers
        fi
        debug_info
        breakpoint "210-headers 2 built"
        copy_files $UNAME_STRING7L
        debug_info
        breakpoint "220-headers 2 copied"
        pkg_headers
    elif [ $NAT_ARCH == "arm64" ]; then
        debug_info
        breakpoint "200-Ready to build headers"
        make_headers $(basename $V8_DEFAULT_CONFIG)
        if [ -f ${KERNEL_OUT_DIR_V8}/extra/Module8.symvers ]; then
            cp ${KERNEL_OUT_DIR_V8}/extra/Module8.symvers ${KERNEL_HEADERS_OUT_DIR}/headers/usr/src/linux-headers-$ver/Module.symvers
        fi
        debug_info
        breakpoint "210-headers built"
        copy_files $UNAME_STRING8
        debug_info
        breakpoint "220-headers copied"
	clean_kernel_src_dir
        breakpoint "200-Ready to build headers 2"
        make_headers $(basename $V8L_DEFAULT_CONFIG)
        if [ -f ${KERNEL_OUT_DIR_V8L}/extra/Module8l.symvers ]; then
            cp ${KERNEL_OUT_DIR_V8L}/extra/Module8l.symvers ${KERNEL_HEADERS_OUT_DIR}/headers/usr/src/linux-headers-$ver/Module.symvers
        fi
        debug_info
        breakpoint "210-headers 2 built"
        copy_files $UNAME_STRING8L
        debug_info
        breakpoint "220-headers 2 copied"
        pkg_headers
    fi
    exit 0
fi

if [ $MAKE_PKG ]; then
    debug_info
    breakpoint "300-Ready to package"

    pull_firmware

    setup_pkg_dir
    debug_info
    breakpoint "310-Pkg dir set up"

    ls -l ${PKG_IN}
    breakpoint "320-Ready to import archives"

    import_archives
    breakpoint "330-Archives imported"

    create_debs
    debug_info
    breakpoint "340-Debian packages created"

    create_tar
    debug_info
fi

exit 0
##                                            ##
################################################
################################################
