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
VERSION="4.14.69"
V6_VERSION="1"
V7_VERSION="1"


## Repos
###################################################
##             4.14.69-Re4son                    ##
GIT_REPO="Re4son/re4son-raspberrypi-linux"
GIT_BRANCH="rpi-4.14.69-re4son"	 	 	                 ## 4.14.62 Commit used for firmware 1.20180912 release
FW_REPO="Re4son/RPi-Distro-firmware"
FW_BRANCH="4.14.69"
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
##GIT_BRANCH="rpi-4.9.80-re4son"	 	 	 ## 4.9.80 Commit used for firmware Re4son-4.80 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.14.26"
###################################################
##             4.4.28                            ##
##GIT_BRANCH="1423ac8bfbfb2a9d092b604c676e7a58a5fa3367"  ## 4.9.28 Commit used for firmware 1.20170515 release
###################################################
##             4.4.24                            ##
##GIT_BRANCH="ef3b440e0e4d9ca70060483aa33d5b1201ceceb8"  ## 4.9.24 Commit used for firmware 1.20170427 release
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
##GIT_BRANCH="rpi-4.9.24-re4son"  		 	 ## 4.9.24 Commit used for firmware 1.20170427 release
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
##GIT_BRANCH="e223d71ef728c559aa865d0c5a4cedbdf8789cfd"  ## 4.4.50 Commit used for firmware 1.20170405 release


##GIT_BRANCH="rpi-4.4.y-re4son"

## defconfigs:
V6_DEFAULT_CONFIG="arch/arm/configs/re4son_pi1_defconfig"
V7_DEFAULT_CONFIG="arch/arm/configs/re4son_pi2_defconfig"
##V6_DEFAULT_CONFIG="arch/arm/configs/bcmrpi_defconfig"
##V7_DEFAULT_CONFIG="arch/arm/configs/bcm2709_defconfig"

V6_CONFIG=""
v7_CONFIG=""

export DEBFULLNAME=Re4son
export DEBEMAIL=re4son@whitedome.com.au

UNAME_STRING="${VERSION}-Re4son+"
UNAME_STRING7="${VERSION}-Re4son-v7+"
CURRENT_DATE=`date +%Y%m%d`
NEW_VERSION="${VERSION}-${CURRENT_DATE}"

# Directories
KERNEL_BUILDER_DIR="/opt/re4son-kernel-builder"
REPO_ROOT="/opt/kernel-builder_repos/"
MOD_DIR=`mktemp -d`
PKG_TMP=`mktemp -d`
PKG_DIR="${PKG_TMP}/raspberrypi-firmware_${NEW_VERSION}"
TOOLS_DIR="/opt/kernel-builder_tools"
FIRMWARE_DIR="/opt/kernel-builder_RPi-Distro-firmware"
#FIRMWARE_DIR="/opt/kernel-builder_firmware"
V6_DIR="${REPO_ROOT}${GIT_REPO}/v6"
V7_DIR="${REPO_ROOT}${GIT_REPO}/v7"
HEAD_SRC_DIR="${REPO_ROOT}${GIT_REPO}/head_src_dir"
PKG_IN="/opt/kernel-builder_pkg_in/"
KERN_MOD_DIR_V6="/opt/kernel-builder_mod_v6"  ## Target directory for pi/pi0 modules that can be used for compiling drivers
KERN_MOD_DIR_V7="/opt/kernel-builder_mod_v7"  ## Target directory for pi2/pi3 modules that can be used for compiling drivers
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
        printf "REPO_ROOT:\t$REPO_ROOT\n"
        printf "V6_DIR:\t\t$V6_DIR\n"
        printf "V7_DIR:\t\t$V7_DIR\n"
        printf "HEAD_SRC_DIR:\t$HEAD_SRC_DIR\n"
        printf "GIT_BRANCH:\t$GIT_BRANCH\n"
        printf "PKG_TMP:\t$PKG_TMP\n"
        printf "PKG_DIR:\t$PKG_DIR\n"
        printf "MOD_DIR:\t$MOD_DIR\n"
        printf "FIRMWARE_DIR:\t$FIRMWARE_DIR\n"
        printf "KERN_MOD_DIR:\t$KERN_MOD_DIR\n"
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
 This will build the Raspberry Pi Kernel.
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

EOF
}

function clean() {
    echo "**** Cleaning up kernel source ****"
    if [ -d $V6_DIR ]; then
        cd $V6_DIR
        git checkout ${GIT_BRANCH}
        echo "**** Cleaning ${V6_DIR} ****"
        make mrproper
        ## Overwrite with remote repo - use if mrproper goes too far
        git reset --hard HEAD
        git pull
        if [ "$V6_VERSION" != "" ]; then
            echo "**** Setting version to ${V6_VERSION} ****"
            ((version = $V6_VERSION -1))
            echo $version > .version
        fi
    fi
    if [ -d $V7_DIR ]; then
        cd $V7_DIR
        git checkout ${GIT_BRANCH}
        echo "**** Cleaning ${V7_DIR} ****"
        make mrproper
        ## Overwrite with remote repo - use if mrproper goes too far
        git reset --hard HEAD
        git pull
        if [ "$V7_VERSION" != "" ]; then
            echo "**** Setting version to ${V7_VERSION} ****"
            ((version = $V7_VERSION -1))
            echo $version > .version
        fi
    fi
   echo "**** Kernel source directories cleaned up ****"
   exit 0
}

function clone_source() {
    echo "**** CLONING to ${REPO_ROOT}${GIT_REPO} ****"
    echo "REPO: ${GIT_REPO}"
    echo "BRANCH: ${GIT_BRANCH}"
    git clone --recursive https://github.com/${GIT_REPO} $V6_DIR
    cp -r $V6_DIR $V7_DIR
    echo "**** COPYING HEADER SOURCE DIRECTORY ****"
    cp -r $V6_DIR $HEAD_SRC__DIR
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

    if [ ! -d $V6_DIR ]; then
        mkdir -p $V6_DIR
        clone_source
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
    rm -r $PKG_DIR/modules/*
}

function setup_native_v6_pkg_dir() {
    # Set up the debian package folder
    printf "\n**** SETTING UP DEBIAN PACKAGE DIRECTORY ****\n"
    mkdir -p $PKG_DIR/boot/overlays/
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING/
}

function setup_native_v7_pkg_dir() {
    # Set up the debian package folder
    printf "\n**** SETTING UP DEBIAN PACKAGE DIRECTORY ****\n"
    mkdir -p $PKG_DIR/boot/overlays/
    mkdir -p $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7/
}

function get_4d_obj() {
    ## Get the object files back for the 4D-Hat drivers after a clean
    printf "\n****  RESTORING 4D-HAT OBJECT FILES    ****\n"
    if [ ! -f compress-v6.o ]; then
        git checkout drivers/video/4d-hats/compress-v6.o
    fi
    if [ ! -f compress-v7.o ]; then
        git checkout drivers/video/4d-hats/compress-v7.o
    fi

}

function make_v6() {
    # RasPi v6 build
    printf "\n**** COMPILING V6 KERNEL (ARMEL) ****\n"
    cd $V6_DIR

    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    get_4d_obj


    CCPREFIX=${TOOLS_DIR}/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
    if [ ! -f .config ]; then
        if [ "$V6_CONFIG" == "" ]; then
            cp ${V6_DEFAULT_CONFIG} .config
        else
            cp ${V6_CONFIG} .config
        fi
    fi
    ARCH=arm CROSS_COMPILE=${CCPREFIX} make menuconfig
    echo "**** SAVING A COPY OF YOUR v6 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig ****"
    cp -f .config $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig
    echo "**** COMPILING v6 KERNEL ****"
    ARCH=arm CROSS_COMPILE=${CCPREFIX} make -j${NUM_CPUS} -k zImage modules dtbs
    ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MOD_DIR} make -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ${V6_DIR}/scripts/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*/build
    rm -f ${MOD_DIR}/lib/modules/*/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    cp ${V6_DIR}/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING/
}

function make_v7() {
    # RasPi v7 build
    printf "\n**** COMPILING V7 KERNEL (ARMHF) ****\n"
    cd $V7_DIR
    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    get_4d_obj

    CCPREFIX=${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
    if [ ! -f .config ]; then
        if [ "$V7_CONFIG" == "" ]; then
          cp ${V7_DEFAULT_CONFIG} .config
        else
          cp ${V7_CONFIG} .config
        fi
    fi
    ARCH=arm CROSS_COMPILE=${CCPREFIX} make menuconfig
    echo "**** SAVING A COPY OF YOUR v7 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig ****"
    cp -f .config $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig
    echo "**** COMPILING v7 KERNEL ****"
    ARCH=arm CROSS_COMPILE=${CCPREFIX} make -j${NUM_CPUS} -k zImage modules dtbs
    ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MOD_DIR} make -j${NUM_CPUS} modules_install
    cp arch/arm/boot/dts/*.dtb $PKG_DIR/boot/
    cp arch/arm/boot/dts/overlays/*.dtb* $PKG_DIR/boot/overlays/
    cp arch/arm/boot/dts/overlays/README $PKG_DIR/boot/overlays/
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ${V7_DIR}/scripts/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v7+/build
    rm -f ${MOD_DIR}/lib/modules/*-v7+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    cp -f ${V7_DIR}/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7/
}

function make_native_v6() {
    # RasPi v6 build
    printf "\n**** COMPILING V6 KERNEL (ARMEL) NATIVELY****\n"
    cd $V6_DIR

    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    get_4d_obj


    if [ ! -f .config ]; then
        if [ "$V6_CONFIG" == "" ]; then
            cp ${V6_DEFAULT_CONFIG} .config
        else
            cp ${V6_CONFIG} .config
        fi
    fi
    make menuconfig
    echo "**** SAVING A COPY OF YOUR v6 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig ****"
    cp -f .config $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig
    echo "**** COMPILING v6 KERNEL ****"
    make -j${NUM_CPUS} -k zImage modules dtbs
    INSTALL_MOD_PATH=${MOD_DIR} make -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in tsetup_native_v6_pkg_dir()he scripts directory of the Linux tree, where they are covered by the kernel licence
    ${V6_DIR}/scripts/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*/build
    rm -f ${MOD_DIR}/lib/modules/*/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy away the module dir so we cak use it for compiling drivers if we want
    cp -r ${MOD_DIR}/lib/modules/*/* ${KERN_MOD_DIR}/
    ## Copy our Module.symvers across
    cp -f ${V6_DIR}/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING/
    cp -f ${V6_DIR}/Module.symvers $KERNEL_BUILDER_DIR/extra/
    cp -f ${V6_DIR}/System.map $KERNEL_BUILDER_DIR/extra/
}

function make_native_v7() {
    # RasPi v7 build
    printf "\n**** COMPILING V7 KERNEL (ARMHF) NATIVELY ****\n"
    cd $V7_DIR
    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    get_4d_obj

    if [ ! -f .config ]; then
        if [ "$V7_CONFIG" == "" ]; then
          cp ${V7_DEFAULT_CONFIG} .config
        else
          cp ${V7_CONFIG} .config
        fi
    fi
    make menuconfig
    echo "**** SAVING A COPY OF YOUR v7 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig ****"
    cp -f .config $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig
    echo "**** COMPILING v7 KERNEL ****"
    make -j${NUM_CPUS} -k zImage modules dtbs
    INSTALL_MOD_PATH=${MOD_DIR} make -j${NUM_CPUS} modules_install
    cp arch/arm/boot/dts/*.dtb $PKG_DIR/boot/
    cp arch/arm/boot/dts/overlays/*.dtb* $PKG_DIR/boot/overlays/
    cp arch/arm/boot/dts/overlays/README $PKG_DIR/boot/overlays/
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ${V7_DIR}/scripts/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v7+/build
    rm -f ${MOD_DIR}/lib/modules/*-v7+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy away the module dir so we cak use it for compiling drivers if we want
    cp -r ${MOD_DIR}/lib/modules/*/* ${KERN_MOD_DIR}/
    ## Copy our Module.symvers across
    cp -f ${V7_DIR}/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$UNAME_STRING7/
    cp -f ${V7_DIR}/Module.symvers $KERNEL_BUILDER_DIR/extra/Module7.symvers
    cp -f ${V7_DIR}/System.map $KERNEL_BUILDER_DIR/extra/System7.map
}

function make_headers (){
    config=$1
    cd $HEAD_SRC_DIR
    if [ -d headers ]; then
        rm -rf headers
    fi
    git pull
    printf "**** Updating files... ****\n"
    echo "+" > .scmversion
    make distclean $config modules_prepare
    cd -
}

function copy_files (){
    ver=$1
    destdir=headers/usr/src/linux-headers-$ver
    cd $HEAD_SRC_DIR
    mkdir -p "$destdir"
    mkdir -p headers/lib/modules/$ver
    rsync -aHAX \
	--files-from=<(cd $HEAD_SRC_DIR; find -name Makefile\* -o -name Kconfig\* -o -name \*.pl) $HEAD_SRC_DIR/ $destdir/
    rsync -aHAX \
	--files-from=<(cd $HEAD_SRC_DIR; find arch/arm/include include scripts -type f) $HEAD_SRC_DIR/ $destdir/
    rsync -aHAX \
	--files-from=<(cd $HEAD_SRC_DIR; find arch/arm -name module.lds -o -name Kbuild.platforms -o -name Platform) $HEAD_SRC_DIR/ $destdir/
    rsync -aHAX \
	--files-from=<(cd $HEAD_SRC_DIR; find `find arch/arm -name include -o -name scripts -type d` -type f) $HEAD_SRC_DIR/ $destdir/
    rsync -aHAX \
	--files-from=<(cd $HEAD_SRC_DIR; find arch/arm/include Module.symvers .config include scripts -type f) $HEAD_SRC_DIR/ $destdir/
    ln -sf "/usr/src/linux-headers-$ver" "headers/lib/modules/$ver/build"
    cd -
}

function pkg_headers () {
    printf "\n**** Creating $KERNEL_BUILDER_DIR/re4son_headers_${NAT_ARCH}_${NEW_VERSION}.tar.xz ****\n"
    cd $HEAD_SRC_DIR
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
    cp -r ${MOD_DIR}/lib/modules/*-v7*/* ${KERN_MOD_DIR}/
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
    cd -
}

function create_debs() {
    # copy overlays
    cp -r $KERNEL_BUILDER_DIR/boot/* $PKG_DIR/boot

    # tar up firmware
    cd $PKG_TMP
    tar czf raspberrypi-firmware_${NEW_VERSION}.orig.tar.gz raspberrypi-firmware_${NEW_VERSION}

    # copy debian files to package directory
    cp -r $FIRMWARE_DIR/debian $PKG_DIR
    touch $PKG_DIR/debian/files
    cd $PKG_DIR/debian
    sh ./gen_bootloader_postinst_preinst.sh

    cd $PKG_DIR
    dch -v ${NEW_VERSION} -D stable --force-distribution "Re4son Kernel source ${GIT_BRANCH}; firmware ${FW_BRANCH}"
    debuild --no-lintian -ePATH=${PATH}:${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin -b -aarmhf -us -uc
}

function create_tar() {
    cd $PKG_TMP
    mkdir re4son-kernel_${NEW_VERSION}
    mkdir re4son-kernel_${NEW_VERSION}/docs
    mkdir re4son-kernel_${NEW_VERSION}/dts
    mkdir re4son-kernel_${NEW_VERSION}/tools
    mkdir re4son-kernel_${NEW_VERSION}/firmware
    mkdir re4son-kernel_${NEW_VERSION}/repo
    mkdir re4son-kernel_${NEW_VERSION}/nexmon
    cp *.deb re4son-kernel_${NEW_VERSION}
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
    sha256sum $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}.tar.xz >> $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}.tar.xz.sha256
    chown re4son:re4son $KERNEL_BUILDER_DIR/re4son-kernel_${NEW_VERSION}.tar.xz*
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

while getopts "hb:cnpexr:6:7:" opt; do
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
      if [ ! NAT_ARCH ]; then
          NAT_ARCH=`dpkg --print-architecture`
      fi
      ;;
  r)  GIT_REPO="$OPTARG"
      ;;
  6)  V6_CONFIG="$OPTARG"
      ;;
  7)  V7_CONFIG="$OPTARG"
      ;;
  \?) usage
      exit 1
      ;;
  esac
done

printf "\n\t**** USING ${NUM_CPUS} AVAILABLE CORES ****\n"


if [ ! $NATIVE ] && [ ! $MAKE_HEADERS ] && [ ! $MAKE_PKG ] && [ ! $MAKE_NEXMON ]; then

    setup_repos
    breakpoint "020-Repos set up"

    ## Lets only update the repos when I'm sure they don't break anything.
    ##pull_tools
    ##breakpoint "030-Tools repo updated"

    pull_firmware
    breakpoint "040-Firmware repo updated"

    setup_pkg_dir
    debug_info
    breakpoint "050-Pkg dir set up"

    make_v6
    breakpoint "060-Kernel v6 compiled"

    make_v7
    debug_info
    breakpoint "070-Kernel v7 compiled"

    create_debs
    debug_info
    breakpoint "080-Debian packages created"

#    make_nexmon
#    breakpoint "090-Nexmon drivers compiled"

    create_tar
    debug_info

    exit 0

elif [ $NATIVE ]; then
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
        pkg_kernel
    else
        printf"\n\t#### ERROR: Architecture $ARCH not supported. ####\n"
    fi
fi

if [ $MAKE_HEADERS ]; then
    printf "\n\t**** Building headers for: $NAT_ARCH ****\n"
    if [ $NAT_ARCH == "armel" ]; then
        debug_info
        breakpoint "200-Ready to build headers"
        make_headers $(basename $V6_DEFAULT_CONFIG)
        if [ -f ${KERNEL_BUILDER_DIR}/extra/Module.symvers ]; then
            cp ${KERNEL_BUILDER_DIR}/extra/Module.symvers ${HEAD_SRC_DIR}/Module.symvers
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
        if [ -f ${KERNEL_BUILDER_DIR}/extra/Module7.symvers ]; then
            cp ${KERNEL_BUILDER_DIR}/extra/Module7.symvers ${HEAD_SRC_DIR}/Module.symvers
        fi
        debug_info
        breakpoint "210-headers built"
        copy_files $UNAME_STRING7
        debug_info
        breakpoint "220-headers copied"
        pkg_headers
    fi
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
