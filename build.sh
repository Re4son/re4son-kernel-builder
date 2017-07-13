#!/usr/bin/env bash

################################################
################################################
##                                            ##
##                VARIABLES                   ##

## SET THESE:                                 ##

## Debug - set to "1" to enable debugging
##         (mainly breakpoints)
DEBUG="0"

## Version strings:
VERSION="4.9.24"
V1_VERSION="20"
V2_VERSION="20"

## Repos
###################################################
##             4.4.28                            ##
##GIT_BRANCH="1423ac8bfbfb2a9d092b604c676e7a58a5fa3367"  ## 4.9.28 Commit used for firmware 1.20170515 release
###################################################
##             4.4.24                            ##
##GIT_BRANCH="ef3b440e0e4d9ca70060483aa33d5b1201ceceb8"  ## 4.9.24 Commit used for firmware 1.20170427 release
###################################################
##             4.4.24-Re4son                     ##
##GIT_REPO="Re4son/re4son-raspberrypi-linux"
##GIT_BRANCH="rpi-4.9.24-re4son"	 	 	 ## 4.9.24 Commit used for firmware 1.20170427 release
##FW_REPO="Re4son/RPi-Distro-firmware"
##FW_BRANCH="4.4.24"
###################################################
##             4.4.24-Re4son                     ##
GIT_REPO="Re4son/re4son-raspberrypi-linux"
GIT_BRANCH="rpi-4.9.24-re4son"  		 	 ## 4.9.24 Commit used for firmware 1.20170427 release
FW_REPO="Re4son/RPi-Distro-firmware"
FW_BRANCH="debian-re4son"
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
V1_DEFAULT_CONFIG="arch/arm/configs/re4son_pi1_defconfig"
V2_DEFAULT_CONFIG="arch/arm/configs/re4son_pi2_defconfig"
##V1_DEFAULT_CONFIG="arch/arm/configs/bcmrpi_defconfig"
##V2_DEFAULT_CONFIG="arch/arm/configs/bcm2709_defconfig"

V1_CONFIG=""
v2_CONFIG=""



# Directories
KERNEL_BUILDER_DIR="/opt/re4son-kernel-builder"
REPO_ROOT="/opt/kernel-builder_repos/"
MOD_DIR=`mktemp -d`
PKG_TMP=`mktemp -d`
TOOLS_DIR="/opt/kernel-builder_tools"
FIRMWARE_DIR="/opt/kernel-builder_RPi-Distro-firmware"
#FIRMWARE_DIR="/opt/kernel-builder_firmware"
V1_DIR="${REPO_ROOT}${GIT_REPO}/v1"
V2_DIR="${REPO_ROOT}${GIT_REPO}/v2"
KERN_MOD_DIR="/opt/kernel-builder_mod"  ## Target directory for pi2/3 modules that can be used for compiling drivers
NEXMON_DIR="/opt/re4son-nexmon"

NUM_CPUS=`nproc`
FW_UNAME=`cat ${FIRMWARE_DIR}/extra/uname_string | cut -f 3 -d ' ' | tr -d +`
FW_UNAME7=`cat ${FIRMWARE_DIR}/extra/uname_string7 | cut -f 3 -d ' ' | tr -d +`



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
    fi
}

function debug_info() {
    if [ $DEBUG == "1" ]; then
        printf "DEBUG INFO:\n\n"
        printf "REPO_ROOT:\t$REPO_ROOT\n"
        printf "V1_DIR:\t\t$V1_DIR\n"
        printf "V2_DIR:\t\t$V2_DIR\n"
        printf "GIT_BRANCH:\t$GIT_BRANCH\n"
        printf "PKG_TMP:\t$PKG_TMP\n"
        printf "PKG_DIR:\t$PKG_DIR\n"
        printf "MOD_DIR:\t$MOD_DIR\n"
        printf "FIRMWARE_DIR:\t$FIRMWARE_DIR\n"
        printf "KERN_MOD_DIR:\t$KERN_MOD_DIR\n"
        printf "NEXMON_DIR:\t$NEXMON_DIR\n"
        printf "NEW_VERSION:\t$NEW_VERSION\n"
        printf "\nFIRMWARE INFO:\n\n"
        FW_GIT_HASH=`cat ${FIRMWARE_DIR}/extra/git_hash`
        printf "FW_GIT_HASH:\t$FW_GIT_HASH\n"
        printf "FW_UNAME:\t${FW_UNAME}+\n"
        printf "FW_UNAME7:\t${FW_UNAME7}+\n"
    fi
}

function usage() {
  cat << EOF
usage: re4sonbuild [options]
 This will build the Raspberry Pi Kernel.
 OPTIONS:
    -h        Show this message
    -c        Clean source directories (i.e. make mrproper - run this before compiling new kernels)
    -r        The remote github repo to clone in user/repo format
              Default: $GIT_REPO
    -b        The git branch to use
              Default: Default git branch of repo
    -1        The config file to use when compiling for Raspi v1
              Default: $V1_DEFAULT_CONFIG
    -2        The config file to use when compiling for Raspi v2
              Default: $V2_DEFAULT_CONFIG

EOF
}

function clean() {
   echo "**** Cleaning up kernel source ****"
   cd $V1_DIR
   git checkout ${GIT_BRANCH}
   echo "**** Cleaning ${V1_DIR} ****"
   make mrproper
   ## Overwrite with remote repo - use if mrproper goes too far
   git reset --hard HEAD
   git pull
   if [ "$V1_VERSION" != "" ]; then
       echo "**** Setting version to ${V1_VERSION} ****"
       ((version = $V1_VERSION -1))
       echo $version > .version
   fi

   cd $V2_DIR
   git checkout ${GIT_BRANCH}
   echo "**** Cleaning ${V2_DIR} ****"
   make mrproper
   ## Overwrite with remote repo - use if mrproper goes too far
   git reset --hard HEAD
   git pull
   if [ "$V2_VERSION" != "" ]; then
       echo "**** Setting version to ${V2_VERSION} ****"
       ((version = $V2_VERSION -1))
       echo $version > .version
   fi
   echo "**** Kernel source directories cleaned up ****"
   exit 0
}

function clone_source() {
  echo "**** CLONING to ${REPO_ROOT}${GIT_REPO} ****"
  echo "REPO: ${GIT_REPO}"
  echo "BRANCH: ${GIT_BRANCH}"
  git clone --recursive https://github.com/${GIT_REPO} $V1_DIR
  cp -r $V1_DIR $V2_DIR
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

    if [ ! -d $V1_DIR ]; then
        mkdir -p $V1_DIR
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
    CURRENT_DATE=`date +%Y%m%d`
    NEW_VERSION="${VERSION}-${CURRENT_DATE}"
    PKG_DIR="${PKG_TMP}/raspberrypi-firmware_${NEW_VERSION}"
    mkdir $PKG_DIR
    cp -r $FIRMWARE_DIR/* $PKG_DIR

    # Remove the pre-compiled modules - we'll compile them ourselves
##    rm -r $PKG_DIR/modules/*
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

function make_v1() {
    # RasPi v1 build
    printf "\n**** COMPILING V1 KERNEL (ARMEL) ****\n"
    cd $V1_DIR

    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    ## get_4d_obj


    CCPREFIX=${TOOLS_DIR}/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
    if [ ! -f .config ]; then
        if [ "$V1_CONFIG" == "" ]; then
            cp ${V1_DEFAULT_CONFIG} .config
        else
            cp ${V1_CONFIG} .config
        fi
    fi
    ARCH=arm CROSS_COMPILE=${CCPREFIX} make menuconfig
    echo "**** SAVING A COPY OF YOUR v1 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig ****"
    cp -f .config $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig
    echo "**** COMPILING v1 KERNEL ****"
    ARCH=arm CROSS_COMPILE=${CCPREFIX} make -j${NUM_CPUS} -k zImage modules dtbs
    ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MOD_DIR} make -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ${V1_DIR}/scripts/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*/build
    rm -f ${MOD_DIR}/lib/modules/*/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    cp ${V1_DIR}/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$FW_UNAME+/
}

function make_v2() {
    # RasPi v2 build
    printf "\n**** COMPILING V2 KERNEL (ARMHF) ****\n"
    cd $V2_DIR
    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    ##get_4d_obj

    CCPREFIX=${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-
    if [ ! -f .config ]; then
        if [ "$V2_CONFIG" == "" ]; then
          cp ${V2_DEFAULT_CONFIG} .config
        else
          cp ${V2_CONFIG} .config
        fi
    fi
    ARCH=arm CROSS_COMPILE=${CCPREFIX} make menuconfig
    echo "**** SAVING A COPY OF YOUR v2 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig ****"
    cp -f .config $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig
    echo "**** COMPILING v2 KERNEL ****"
    ARCH=arm CROSS_COMPILE=${CCPREFIX} make -j${NUM_CPUS} -k zImage modules dtbs
    ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MOD_DIR} make -j${NUM_CPUS} modules_install
    cp arch/arm/boot/dts/*.dtb $PKG_DIR/boot/
    cp arch/arm/boot/dts/overlays/*.dtb* $PKG_DIR/boot/overlays/
    cp arch/arm/boot/dts/overlays/README $PKG_DIR/boot/overlays/
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ${V2_DIR}/scripts/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v7+/build
    rm -f ${MOD_DIR}/lib/modules/*-v7+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    cp -f ${V2_DIR}/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$FW_UNAME7+/
}

function make_native_v1() {
    # RasPi v1 build
    printf "\n**** COMPILING V1 KERNEL (ARMEL) NATIVELY****\n"
    cd $V1_DIR

    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    ## get_4d_obj


    if [ ! -f .config ]; then
        if [ "$V1_CONFIG" == "" ]; then
            cp ${V1_DEFAULT_CONFIG} .config
        else
            cp ${V1_CONFIG} .config
        fi
    fi
    make menuconfig
    echo "**** SAVING A COPY OF YOUR v1 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig ****"
    cp -f .config $KERNEL_BUILDER_DIR/configs/re4son_pi1_defconfig
    echo "**** COMPILING v1 KERNEL ****"
    make -j${NUM_CPUS} -k zImage modules dtbs
    INSTALL_MOD_PATH=${MOD_DIR} make -j${NUM_CPUS} modules_install
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ${V1_DIR}/scripts/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*/build
    rm -f ${MOD_DIR}/lib/modules/*/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    cp ${V1_DIR}/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$FW_UNAME+/
}

function make_native_v2() {
    # RasPi v2 build
    printf "\n**** COMPILING V2 KERNEL (ARMHF) NATIVELY ****\n"
    cd $V2_DIR
    git fetch
    git checkout ${GIT_BRANCH}
    git pull
    git submodule update --init

    ##get_4d_obj

    if [ ! -f .config ]; then
        if [ "$V2_CONFIG" == "" ]; then
          cp ${V2_DEFAULT_CONFIG} .config
        else
          cp ${V2_CONFIG} .config
        fi
    fi
    make menuconfig
    echo "**** SAVING A COPY OF YOUR v2 CONFIG TO $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig ****"
    cp -f .config $KERNEL_BUILDER_DIR/configs/re4son_pi2_defconfig
    echo "**** COMPILING v2 KERNEL ****"
    make -j${NUM_CPUS} -k zImage modules dtbs
    INSTALL_MOD_PATH=${MOD_DIR} make -j${NUM_CPUS} modules_install
    cp arch/arm/boot/dts/*.dtb $PKG_DIR/boot/
    cp arch/arm/boot/dts/overlays/*.dtb* $PKG_DIR/boot/overlays/
    cp arch/arm/boot/dts/overlays/README $PKG_DIR/boot/overlays/
    ## mkknlimg is no longer in tools
    ## ${TOOLS_DIR}/mkimage/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## It is now found in the scripts directory of the Linux tree, where they are covered by the kernel licence
    ${V2_DIR}/scripts/mkknlimg arch/arm/boot/zImage $PKG_DIR/boot/kernel7.img
    ## Remove symbolic links to non-existent headers and sources
    rm -f ${MOD_DIR}/lib/modules/*-v7+/build
    rm -f ${MOD_DIR}/lib/modules/*-v7+/source
    ## Copy our modules across
    cp -r ${MOD_DIR}/lib/* ${PKG_DIR}
    ## Copy our Module.symvers across
    cp -f ${V2_DIR}/Module.symvers $PKG_DIR/headers/usr/src/linux-headers-$FW_UNAME7+/
}


function make_nexmon() {
    ## Compiling nexmon firmware patches for Raspberry Pi 3
    cp -r ${MOD_DIR}/lib/modules/*-v7*/* ${KERN_MOD_DIR}/
    cd ${NEXMON_DIR}
    source setup_env.sh
    cd patches/bcm43438/7_45_41_26/nexmon
    make
    cd $KERNEL_BUILDER_DIR
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
    dch -v ${NEW_VERSION} --package raspberrypi-firmware 'Adds Re4son-Kernel'
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
    ## rm -f re4son-kernel_${NEW_VERSION}/raspberrypi-kernel-headers*
    cp ${NEXMON_DIR}/patches/bcm43438/7_45_41_26/nexmon/brcmfmac43430-sdio.bin re4son-kernel_${NEW_VERSION}/nexmon
    cp ${NEXMON_DIR}/patches/bcm43438/7_45_41_26/nexmon/brcmfmac/brcmfmac.ko re4son-kernel_${NEW_VERSION}/nexmon
    cp $KERNEL_BUILDER_DIR/nexmon/* re4son-kernel_${NEW_VERSION}/nexmon
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
    echo -e "THE re4son-kernel_${NEW_VERSION}.tar.xz ARCHIVE SHOULD NOW BE\nAVAILABLE IN THE KERNEL-BUILDER FOLDER\n\n"
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

while getopts "hb:cr:1:2:" opt; do
  case "$opt" in
  h)  usage
      exit 0
      ;;
  b)  GIT_BRANCH="$OPTARG"
      ;;
  c)  clean
      exit 0
      ;;
  r)  GIT_REPO="$OPTARG"
      ;;
  1)  V1_CONFIG="$OPTARG"
      ;;
  2)  V2_CONFIG="$OPTARG"
      ;;
  \?) usage
      exit 1
      ;;
  esac
done

printf "\n**** USING ${NUM_CPUS} AVAILABLE CORES ****\n"

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

##make_v1
make_native_v1
breakpoint "060-Kernel v1 compiled"

##make_v2
make_native_v2
debug_info
breakpoint "070-Kernel v2 compiled"

create_debs
debug_info
breakpoint "080-Debian packages created"

##make_nexmon
breakpoint "090-Nexmon drivers compiled"

create_tar
debug_info

##                                            ##
################################################
################################################
