#!/usr/bin/env bash

PROG_NAME="$(basename $0)"
ARGS="$@"
VERSION="4.9-1.4.2"

function print_version() {
    printf "\tRe4son-Kernel Installer: $PROG_NAME $VERSION\n\n"
    exit 0
}

function print_help() {
    printf "\n\tUsage: ${PROG_NAME} [option]\n"
    printf "\t\t\t   (No option)\tInstall Re4son-Kernel and ask to install Re4son Bluetooth support\n"
    printf "\t\t\t\t-h\tPrint this help\n"
    printf "\t\t\t\t-v\tPrint version of this installer\n"
    printf "\t\t\t\t-e\tOnly install Re4son-Kernel headers\n"
    printf "\t\t\t\t-b\tOnly install Re4son Bluetooth support for RPi3 & RPi Zero W\n"
    printf "\t\t\t\t-r\tOnly remove Re4son Bluetooth support\n"
    printf "\t\t\t\t-x\tOnly install Nexmon drivers\n"
    printf "\t\t\t\t-o\tOnly remove Nexmon drivers\n"
    printf "\t\t\t\t-u\tUpdate Re4son-Kernel Installer\n\n"
    exit 1
}

function ask() {
    # http://djm.me/ask
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        printf "\t++++ "
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac
    done
}

function exitonerr {
    # via: http://stackoverflow.com/a/5196108
    "$@"
    local status=$?

    if [ $status -ne 0 ]; then
        echo "Error completing: $1" >&2
        exit 1
    fi

    return $status
}

function check_update() {
    TEMP_FILE="/tmp/install.sh"
    printf "\n\t*** Downloading update ***\n"
    wget -O ${TEMP_FILE} https://github.com/Re4son/re4son-kernel-builder/raw/build-4.9.n/install.sh
    cp $TEMP_FILE $PROG_NAME
    chmod +x $PROG_NAME
    rm -f $TEMP_FILE
    printf "\tReplaced old version:\tRe4son-Kernel Installer: ${PROG_NAME} ${VERSION}\n"
    printf "\tWith new version:"
    source "$PROG_NAME" -v
    exit 0
}

function install_bluetooth {
    printf "\n\t**** Installing bluetooth packages for Raspberry Pi 3 & Zero W ****\n"
    apt update
    apt install -y ./repo/pi-bluetooth+re4son*.deb
    systemctl enable hciuart && systemctl enable bluetooth
    printf "\t**** Bluetooth services installed\n\n"
    return 0
}

function install_firmware {
    printf "\n\t**** Installing firmware for RasPi bluetooth chip ****\n"
    #Raspberry Pi 3 & Zero W
    if [ ! -f /lib/firmware/brcm/BCM43430A1.hcd ]; then
        cp firmware/BCM43430A1.hcd /lib/firmware/brcm/BCM43430A1.hcd
    fi
    if [ ! -f  /etc/udev/rules.d/99-com.rules ]; then
      cp firmware/99-com.rules /etc/udev/rules.d/99-com.rules
    fi

    #Raspberry Pi Zero W
    if [ ! -f /lib/firmware/brcm/brcmfmac43430-sdio.bin ]; then
        cp firmware/brcmfmac43430-sdio.bin /lib/firmware/brcm/brcmfmac43430-sdio.bin
    fi
    if [ ! -f /lib/firmware/brcm/brcmfmac43430-sdio.txt ]; then
        cp firmware/brcmfmac43430-sdio.txt /lib/firmware/brcm/brcmfmac43430-sdio.txt
    fi
    printf "\t**** Firmware installed                           ****\n"
    return 0
}

function install_kernel(){
    printf "\n\t**** Installing custom Re4son kernel with kali wifi injection patch and TFT support ****\n"
    if grep -q boot /proc/mounts; then
        printf "\n\t**** /boot is mounted ****\n"
    else
        printf "\n\t#### /boot must be mounted. If you think it's not, quit here and try: ####\n"
        printf "\t#### sudo mount /dev/mmcblk0p1 /boot                                  ####\n\n"
        if ask "Continue?" "N"; then
            printf "\n\t*** Proceeding... ****\n\n"
        else
            printf "\n\t#### Aborting... ####\n\n"
            exit 1
        fi
    fi

    ## Install device-tree-compiler
    printf "\n\t**** Installing device tree overlays for various screens ****\n"
    PKG_STATUS=$(dpkg-query -W --showformat='${Status}\n' device-tree-compiler|grep "ok installed")
    printf "\t**** Checking for device-tree-compiler: ${PKG_STATUS} ****\n"
    if [ "" == "$PKG_STATUS" ]; then
        printf "\tNo device-tree-compiler. Installing it now.\n"
        apt update
        apt install device-tree-compiler
    fi
    ## Reserved
    ## cp src dest
    printf "\n\t**** Device tree overlays installed ****\n"
    exitonerr dpkg --force-architecture -i --ignore-depends=raspberrypi-kernel raspberrypi-bootloader_*
    exitonerr dpkg --force-architecture -i raspberrypi-kernel_*
    exitonerr dpkg --force-architecture -i libraspberrypi0_*
    exitonerr dpkg --force-architecture -i libraspberrypi-dev_*
    exitonerr dpkg --force-architecture -i libraspberrypi-doc_*
    exitonerr dpkg --force-architecture -i libraspberrypi-bin_*

    printf "\n\t**** Fixing unmet dependencies in Kali Linux ****\n"
    mkdir -p /etc/kbd
    touch /etc/kbd/config
    printf "\t**** Unmet dependencies in Kali Linux fixed ****\n\n"
    printf "\t**** Installation completed ****\n"
    printf "\t**** Documentation and help can be found in Sticky Finger's Kali-Pi forums at ****\n"
    printf "\t**** https://whitedome.com.au/forums ****\n\n"

    return 0
}

function remove_bluetooth {
    printf "\n"
    if ask "Remove Re4son-Kernel Bluetooth support?"; then
        printf "\n\t**** Stopping bluetooth Services ****\n"

        systemctl stop bluetooth
        systemctl stop hciuart

        printf "\t**** Removing bluetooth packages for Raspberry Pi 3 & Zero W ****\n"
        apt purge -y pi-bluetooth+re4son bluez bluez-firmware
        printf "\t**** Bluetooth packages for Raspberry Pi 3 & Zero W removed ****\n\n"

        if ask "Reboot to apply changes?"; then
            reboot
        fi
    fi
    printf "\n"
    return 0
}

function install_headers() {

    printf "\n\t**** Installing Re4son-Kernel headers ****\n"
    exitonerr dpkg --force-architecture -i raspberrypi-kernel-headers_*
    printf "\t**** Installation completed ****\n\n"
    return 0
}

function install_nexmon() {

    printf "\n\t**** Installing Nexmon drivers ****\n"
    ARCH=`dpkg --print-architecture`
    # Backup original brcmfmac.ko
    if [ ! -f ./nexmon/${ARCH}/org/brcmfmac.ko ]; then
        if [ ! -d ./nexmon/${ARCH}/org ]; then
            exitonerr mkdir -p ./nexmon/${ARCH}/org
        fi
        exitonerr cp /lib/modules/$(uname -r)/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko ./nexmon/${ARCH}/org/
    fi
    # Backup original brcmfmac43430-sdio.bin
    if [ ! -f ./nexmon/${ARCH}/org/brcmfmac43430-sdio.bin ]; then
        if [ ! -d ./nexmon/${ARCH}/org ]; then
            exitonerr mkdir -p ./nexmon/${ARCH}/org
        fi
        exitonerr cp /lib/firmware/brcm/brcmfmac43430-sdio.bin ./nexmon/${ARCH}/org/
    fi
    # Install drivers
        exitonerr cp -f ./nexmon/${ARCH}/brcmfmac.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/
        exitonerr cp -f ./nexmon/${ARCH}/brcmfmac43430-sdio.bin /lib/firmware/brcm/
    # Load drivers
        exitonerr rmmod brcmfmac
        exitonerr modprobe brcmfmac
    # Install nexutil
        exitonerr cp -f ./nexmon/${ARCH}/nexutil /usr/bin/
    printf "\t**** Installation completed ****\n\n"
    return 0
}

function remove_nexmon() {

    ARCH=`dpkg --print-architecture`
    printf "\n\t**** Removing Nexmon drivers ****\n"
    if [ ! -f ./nexmon/${ARCH}/org/brcmfmac.ko ]; then
        printf "\n\t!!!! No driver backup found !!!!\n"
        if ask "Install the original Broadcom drivers?" "Y"; then
            exitonerr cp -f ./nexmon/${ARCH}/oem/brcmfmac.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/
        else
            printf "\n\t!!!! Installation aborted !!!!\n"
        fi
    else
        exitonerr cp -f ./nexmon/${ARCH}/org/brcmfmac.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/
    fi
    if [ ! -f ./nexmon/${ARCH}/org/brcmfmac43430-sdio.bin ]; then
        printf "\n\t!!!! No firmware backup found !!!!\n"
        if ask "Install the original Broadcom firmware?" "Y"; then
            exitonerr cp -f ./nexmon/${ARCH}/oem/brcmfmac43430-sdio.bin /lib/firmware/brcm/
        else
            printf "\n\t!!!! Installation aborted !!!!\n"
        fi
    else
        exitonerr cp -f ./nexmon/${ARCH}/org/brcmfmac43430-sdio.bin /lib/firmware/brcm/
    fi
    # Load drivers
    exitonerr rmmod brcmfmac
    exitonerr modprobe brcmfmac
    # remove nexutil
    if [ ! -f ./usr/bin/nexutil ]; then
        exitonerr rm -f /usr/bin/nexutil
    fi
    printf "\t**** Nexmon drivers removed ****\n\n"
    return 0
}

function remove_nexmon_silent() {

    ARCH=`dpkg --print-architecture`
    printf "\n\t**** Removing Nexmon drivers ****\n"
    if [ ! -f ./nexmon/${ARCH}/org/brcmfmac.ko ]; then
        printf "\n\t!!!! No driver backup found !!!!\n"
        exitonerr cp -f ./nexmon/${ARCH}/oem/brcmfmac.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/
    else
        exitonerr cp -f ./nexmon/${ARCH}/org/brcmfmac.ko /lib/modules/$(uname -r)/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac/
    fi
    if [ ! -f ./nexmon/${ARCH}/org/brcmfmac43430-sdio.bin ]; then
        printf "\n\t!!!! No firmware backup found !!!!\n"
        exitonerr cp -f ./nexmon/${ARCH}/oem/brcmfmac43430-sdio.bin /lib/firmware/brcm/
    else
        exitonerr cp -f ./nexmon/${ARCH}/org/brcmfmac43430-sdio.bin /lib/firmware/brcm/
    fi
    # Load drivers
    exitonerr rmmod brcmfmac
    exitonerr modprobe brcmfmac
    # remove nexutil
    if [ ! -f ./usr/bin/nexutil ]; then
        exitonerr rm -f /usr/bin/nexutil
    fi
    printf "\t**** Nexmon drivers removed ****\n\n"
    return 0
}

############
##        ##
##  MAIN  ##

if [[ $EUID -ne 0 ]]; then
   printf "\n\t${PROG_NAME} must be run as root. try: sudo install.sh\n\n"
   exit 1
fi

args=$(getopt -uo 'hevbrxopu' -- $*)

set -- $args

for i
do
    case "$i"
    in
        -h)
            print_help
            exit 0
            ;;
        -v)
            print_version
            exit 0
            ;;
        -e)
            install_headers
            exit 0
            ;;
        -b)
            install_firmware
            install_bluetooth
            if ask "Reboot to apply changes?" "Y"; then
                reboot
            fi
            exit 0
            ;;
        -r)
            remove_bluetooth
            exit 0
            ;;
        -x)
            install_nexmon
            exit 0
            ;;
        -o)
            remove_nexmon
            exit 0
            ;;
        -p)
            remove_nexmon_silent
            exit 0
            ;;
        -u)
            check_update
            exit 0
            ;;
    esac
done

printf "\n"
if ask "Install Re4son-Kernel?" "Y"; then
    install_kernel
fi
if ask "Install support for RasPi 3 & Zero W built-in wifi & bluetooth adapters?" "Y"; then
    install_firmware
    install_bluetooth
fi
if ask "Install kernel headers?" "Y"; then
    install_headers
fi
if ask "Reboot to apply changes?" "Y"; then
    reboot
fi
printf "\n"
