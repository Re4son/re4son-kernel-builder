#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "install.sh must be run as root. try: sudo install.sh"
   exit 1
fi

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

# via: http://stackoverflow.com/a/5196108
function exitonerr {

  "$@"
  local status=$?

  if [ $status -ne 0 ]; then
    echo "Error completing: $1" >&2
    exit 1
  fi

  return $status

}

function install_bluetooth {
    echo "**** Installing bluetooth packages for Raspberry Pi 3 & Zero W ****"
    ARCH=`dpkg --print-architecture`
    apt install bluez-firmware

    ## Install dependencies
    PKG_STATUS=$(dpkg-query -W --showformat='${Status}\n' libreadline6|grep "install ok installed")
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
        dpkg -i ./repo/bluez_5.39-1+rpi1+re4son_armel.deb
    else
        dpkg -i ./repo/bluez_5.23-2+rpi2_armhf.deb
    fi
    dpkg -i ./repo/pi-bluetooth_0.1.4+re4son_all.deb
    apt-mark hold bluez-firmware bluez pi-bluetooth

    if [ ! -f  /lib/udev/rules.d/50-bluetooth-hci-auto-poweron.rules ]; then
      cp firmware/50-bluetooth-hci-auto-poweron.rules /lib/udev/rules.d/50-bluetooth-hci-auto-poweron.rules
    fi
    ## Above rule runs /bin/hciconfig but its found in /usr/bin under kali, lets create a link
    if [ ! -f  /bin/hciconfig ]; then
      ln -s /usr/bin/hciconfig /bin/hciconfig
    fi
    
    if ask "Enable bluetooth services?"; then
        systemctl unmask bluetooth.service
        systemctl enable bluetooth
        systemctl enable hciuart
    fi
    echo "**** Bluetooth packages for Raspberry Pi 3 & Zero W installed ****"
}
function install_firmware {
    echo "**** Installing firmware for RasPi bluetooth chip ****"
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
    echo
    echo "**** Firmware installed ****"
    return
}

echo "**** Installing custom Re4son kernel with kali wifi injection patch and TFT support ****"

## Install device-tree-compiler
PKG_STATUS=$(dpkg-query -W --showformat='${Status}\n' device-tree-compiler|grep "install ok installed")
echo "Checking for device-tree-compiler:" $PKG_STATUS
if [ "" == "$PKG_STATUS" ]; then
    echo "No device-tree-compiler. Installing it now."
    apt update
    apt install device-tree-compiler
fi

exitonerr dpkg --force-architecture -i --ignore-depends=raspberrypi-kernel raspberrypi-bootloader_*
exitonerr dpkg --force-architecture -i raspberrypi-kernel_*
exitonerr dpkg --force-architecture -i libraspberrypi0_*
exitonerr dpkg --force-architecture -i libraspberrypi-dev_*
exitonerr dpkg --force-architecture -i libraspberrypi-doc_*
exitonerr dpkg --force-architecture -i libraspberrypi-bin_*

echo "**** Installing device tree overlays for various screens ****"

echo "**** Fixing unmet dependencies in Kali Linux ****"
mkdir -p /etc/kbd
touch /etc/kbd/config
echo
echo "**** Unmet dependencies in Kali Linux fixed ****"
echo

if ask "Install support for RasPi 3 & Zero W built-in wifi & bluetooth adapters?" "N"; then
        install_firmware
        install_bluetooth
fi



echo "**** Documentation and help can be found in Sticky Finger's Kali-Pi forums at ****"
echo "**** https://whitedome.com.au/forums ****"
echo
echo "**** next you can run the universal setup tool to activate your TFT screen via ****"
echo "**** ./re4son-pi-tft-setup -t [pitfttype] -d [home directory]****"
echo
read -p "Reboot to apply changes? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  reboot
fi
