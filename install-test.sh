#!/usr/bin/env bash

PROG_NAME="$(basename $0)"
ARGS="$@"
VERSION="4.4-1.1.0"

function print_version() {
    printf "\tRe4son-Kernel Installer: $PROG_NAME $VERSION\n\n"
    exit 0
}

function print_help() {
    printf "\n\tUsage: ${PROG_NAME} [option]\n"
    printf "\t\t\t   (No option)\tInstall Re4son-Kernel and ask to install Re4son Bluetooth support\n"
    printf "\t\t\t\t-h\tPrint this help\n"
    printf "\t\t\t\t-e\tOnly install Re4son-Kernel headers\n"
    printf "\t\t\t\t-b\tOnly install Re4son Bluetooth support for RPi3 & RPi Zero W\n"
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
    wget -O ${TEMP_FILE} https://github.com/Re4son/re4son-kernel-builder/raw/build-4.4.y/install-test.sh
    cp $TEMP_FILE $PROG_NAME
    chmod +x $PROG_NAME
    rm -f $TEMP_FILE
    printf "\tReplaced old version:"
    printf "\tRe4son-Kernel Installer: $PROG_NAME $VERSION\n"
    printf "\tWith new version:\t"
    source "$PROG_NAME" -v
    exit 0
}

function install_bluetooth {
    printf "\n\t**** Installing bluetooth packages for Raspberry Pi 3 & Zero W ****\n"
    ARCH=`dpkg --print-architecture`
    apt install bluez-firmware

    ## Install dependencies
    PKG_STATUS=$(dpkg-query -W --showformat='${Status}\n' libreadline6|grep "install ok installed")
    printf "Checking for libreadline6: ${PKG_STATUS}\n"
    if [ "" == "$PKG_STATUS" ]; then
        printf "Fixing unmet dependencies. Installing libreadline6.\n"
        if [ "armel" == "$ARCH" ]; then
            dpkg -i ./repo/libreadline6_6.3-8+b3_armel.deb
        else
            dpkg -i ./repo/libreadline6_6.3-8+b3_armhf.deb
        fi
    fi


    if [ "armel" == "$ARCH" ]; then
        dpkg --force-all -i ./repo/bluez_5.39-1+rpi1+re4son_armel.deb
    else
        dpkg --force-all -i ./repo/bluez_5.39-1+rpi3+re4son_armhf.deb
    fi
    dpkg --force-all -i ./repo/pi-bluetooth_0.1.4+re4son_all.deb
    apt-mark hold bluez-firmware bluez pi-bluetooth

    if [ ! -f  /lib/udev/rules.d/50-bluetooth-hci-auto-poweron.rules ]; then
      cp firmware/50-bluetooth-hci-auto-poweron.rules /lib/udev/rules.d/50-bluetooth-hci-auto-poweron.rules
    fi
    ## Above rule runs /bin/hciconfig but its found in /usr/bin under kali, lets create a link
    if [ ! -f  /bin/hciconfig ]; then
      ln -s /usr/bin/hciconfig /bin/hciconfig
    fi
    ## systemd version 232 breaks execution of above bluetooth rule, let's fix that
    SYSTEMD_VER=$(systemd --version|grep systemd|sed 's/systemd //')
    if (( $SYSTEMD_VER >= 232 )); then
        if [ -f /lib/systemd/system/systemd-udevd.service ]; then
            sed -i 's/^RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6.*/RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6 AF_BLUETOOTH/' /lib/systemd/system/systemd-udevd.service
        elif [ -f /etc/systemd/system/systemd-udevd.service ]; then
            sed -i 's/^RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6.*/RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6 AF_BLUETOOTH/' /etc/systemd/system/systemd-udevd.service
        fi
    fi
    if ask "    Enable bluetooth services?"; then
        systemctl unmask bluetooth.service
        systemctl enable bluetooth
        systemctl enable hciuart
    fi
    printf "\t**** Bluetooth packages for Raspberry Pi 3 & Zero W installed ****\n\n"
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
    printf "\n\n\t**** Firmware installed ****\n\n"
    return 0
}

function install_kernel(){
    return 0
    printf "\n\t**** Installing custom Re4son kernel with kali wifi injection patch and TFT support ****\n"

    ## Install device-tree-compiler
    PKG_STATUS=$(dpkg-query -W --showformat='${Status}\n' device-tree-compiler|grep "install ok installed")
    printf "\n\t**** Installing device tree overlays for various screens ****\n"
    printf "\tChecking for device-tree-compiler: ${PKG_STATUS}\n"
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
    printf "\t**** Unmet dependencies in Kali Linux fixed ****\n"
    printf "\t**** Installation completed ****\n"
    printf "\t**** Documentation and help can be found in Sticky Finger's Kali-Pi forums at ****\n"
    printf "\t**** https://whitedome.com.au/forums ****\n"
    printf "\t**** next you can run the universal setup tool to activate your TFT screen via ****\n"
    printf "\t**** ./re4son-pi-tft-setup -t [pitfttype] -d [home directory]****\n\n"
    return 0
}

function remove_bluetooth {


    if [ ! ask "Remove Re4son-Kernel Bluetooth support?" ]; then
        exit 1
    fi

    echo "**** Stopping bluetooth Services ****"
    exit 0


    systemctl stop bluetooth
    systemctl stop hciuart

    echo "**** Removing bluetooth packages for Raspberry Pi 3 & Zero W ****"

    ARCH=`dpkg --print-architecture`


    PKG_STATUS=$(dpkg-query -W bluez|grep "re4son")
    echo "Checking for libreadline6:" $PKG_STATUS
    if [ "" == "$PKG_STATUS" ]; then
        echo "Fixing unmet dependencies. Installing libreadline6."
        if [ "armel" == "$ARCH" ]; then
            dpkg -i ./repo/libreadline6_6.3-8+b3_armel.deb
        else
            dpkg -i ./repo/libreadline6_6.3-8+b3_armhf.deb
        fi
    fi



    if [ "armel" == "$ARCH" ]; then
        dpkg --force-all -i ./repo/bluez_5.39-1+rpi1+re4son_armel.deb
    else
        dpkg --force-all -i ./repo/bluez_5.39-1+rpi3+re4son_armhf.deb
    fi
    dpkg --force-all -i ./repo/pi-bluetooth_0.1.4+re4son_all.deb
    apt-mark hold bluez-firmware bluez pi-bluetooth

    if [ ! -f  /lib/udev/rules.d/50-bluetooth-hci-auto-poweron.rules ]; then
      cp firmware/50-bluetooth-hci-auto-poweron.rules /lib/udev/rules.d/50-bluetooth-hci-auto-poweron.rules
    fi
    ## Above rule runs /bin/hciconfig but its found in /usr/bin under kali, lets create a link
    if [ ! -f  /bin/hciconfig ]; then
      ln -s /usr/bin/hciconfig /bin/hciconfig
    fi
    ## systemd version 232 breaks execution of above bluetooth rule, let's fix that
    SYSTEMD_VER=$(systemd --version|grep systemd|sed 's/systemd //')
    if (( $SYSTEMD_VER >= 232 )); then
        if [ -f /lib/systemd/system/systemd-udevd.service ]; then
            sed -i 's/^RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6.*/RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6 AF_BLUETOOTH/' /lib/systemd/system/systemd-udevd.service
        elif [ -f /etc/systemd/system/systemd-udevd.service ]; then
            sed -i 's/^RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6.*/RestrictAddressFamilies=AF_UNIX AF_NETLINK AF_INET AF_INET6 AF_BLUETOOTH/' /etc/systemd/system/systemd-udevd.service
        fi
    fi
    echo "**** Bluetooth packages for Raspberry Pi 3 & Zero W removed ****"
}


############
##        ##
##  MAIN  ##

if [[ $EUID -ne 0 ]]; then
   echo "install.sh must be run as root. try: sudo install.sh"
   exit 1
fi

args=$(getopt -uo 'hevbru' -- $*)

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
            install_bluetooth
            exit 0
            ;;
        -r)
            remove_bluetooth
            exit 0
            ;;
        -u)
            check_update
            exit 0
            ;;
    esac
done


install_kernel
if ask "Install support for RasPi 3 & Zero W built-in wifi & bluetooth adapters?" "N"; then
        install_firmware
        install_bluetooth
fi
read -p "Reboot to apply changes? (y/n): " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  reboot
fi
printf "\n"
