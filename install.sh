#!/usr/bin/env bash

PROG_NAME="$(basename $0)"
ARGS="$@"
VERSION="4.14-1.6.0"

function print_version() {
    printf "\tRe4son-Kernel Installer: $PROG_NAME $VERSION\n\n"
    exit 0
}

function print_help() {
    printf "\n\tUsage: ${PROG_NAME} [option]\n"
    printf "\t\t\t   (No option)\tInstall Re4son-Kernel and ask to install tools & Re4son Bluetooth support\n"
    printf "\t\t\t\t-h\tPrint this help\n"
    printf "\t\t\t\t-a\tInstall everything without asking\n"
    printf "\t\t\t\t-v\tPrint version of this installer\n"
    printf "\t\t\t\t-e\tOnly install Re4son-Kernel headers\n"
    printf "\t\t\t\t-b\tOnly install Re4son Bluetooth support for RPi 3 B(+) & RPi Zero W\n"
    printf "\t\t\t\t-t\tOnly install Kali-Pi tools\n"
    printf "\t\t\t\t-r\tOnly remove Re4son Bluetooth support\n"
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
    wget -O ${TEMP_FILE} https://github.com/Re4son/re4son-kernel-builder/raw/build-4.14.n/install.sh
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
    apt install -y ./repo/pi-bluetooth*.deb
    systemctl enable hciuart && systemctl enable bluetooth
    printf "\t**** Bluetooth services installed\n\n"
    return 0
}

function install_firmware {
	printf "\n\t**** Installing firmware for Raspberry Pi 3 B(+) & Zero W wifi & bluetooth chips ****\n"
    #Raspberry Pi 3 & Zero W
    if [ ! -f /lib/firmware/brcm/BCM43430A1.hcd ]; then
        cp firmware/BCM43430A1.hcd /lib/firmware/brcm/BCM43430A1.hcd
    fi
    if [ ! -f  /etc/udev/rules.d/99-com.rules ]; then
      cp firmware/99-com.rules /etc/udev/rules.d/99-com.rules
    fi

    return 0
}

function install_kernel(){
    printf "\n\t**** Installing custom Re4son kernel with kali wifi injection patch and TFT support ****\n"
    if grep -q boot /proc/mounts; then
        printf "\n\t**** /boot is mounted ****\n"
    else
        if ask "Cannot find /boot. Maybe it is not mounted. Shall I try mounting it?" "Y"; then
            printf "\n\t**** Mounting /boot ****\n"
	    mount /dev/mmcblk0p1 /boot
        fi
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
    printf "\n\t**** Device tree overlays installed                      ****\n"
    exitonerr dpkg --force-architecture -i --ignore-depends=raspberrypi-kernel raspberrypi-bootloader_*
    exitonerr dpkg --force-architecture -i raspberrypi-kernel_*
    exitonerr dpkg --force-architecture -i libraspberrypi0_*
    exitonerr dpkg --force-architecture -i libraspberrypi-dev_*
    exitonerr dpkg --force-architecture -i libraspberrypi-doc_*
    exitonerr dpkg --force-architecture -i libraspberrypi-bin_*
    exitonerr dpkg --force-architecture -i raspberrypi-re4son-firmware_*

    ## Install nexmon firmware
    ARCH=`dpkg --print-architecture`
    printf "\n\t**** Installing nexutil ****\n"
    # Install nexutil
    exitonerr cp -f ./nexmon/${ARCH}/nexutil /usr/bin/
    printf "\n\t**** Nexutil installed ****\n"
    
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
        apt purge -y pi-bluetooth bluez bluez-firmware
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

function install_tools() {
    printf "\n\t**** Installing Kali-Pi tools ****\n"
    if [ ! -f /usr/bin/kalipi-config ]; then
        cp -f tools/kalipi-config /usr/bin 
        chmod 755 /usr/bin/kalipi-config
    fi
    if [ ! -f /usr/bin/kalipi-tft-config ]; then
        cp -f tools/kalipi-tft-config /usr/bin 
        chmod 755 /usr/bin/kalipi-tft-config
    fi
    printf "\t**** Installation completed ****\n\n"
    return 0
}


############
##        ##
##  MAIN  ##

if [[ $EUID -ne 0 ]]; then
   printf "\n\t${PROG_NAME} must be run as root. try: sudo install.sh\n\n"
   exit 1
fi

args=$(getopt -uo 'ahevbrtpu' -- $*)

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
	-a)
	    install_kernel
	    install_firmware
            install_headers
	    install_tools
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
        -t)
            install_tools
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
    install_firmware
fi
##if ask "Install support for RasPi 3 & Zero W built-in wifi & bluetooth adapters?" "Y"; then
##    install_bluetooth
##fi
if ask "Install kernel headers?" "Y"; then
    install_headers
fi
if ask "Install kali-pi tools (kalipi-config, kalipi-tft-config)?" "Y"; then
    install_tools
fi 
if ask "Reboot to apply changes?" "Y"; then
    reboot
fi
printf "\n"
