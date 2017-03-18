#!/usr/bin/env bash
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Adafruit
# Adjusted for Sticky Finger's Kali-Pi by re4son [at] whitedome.com.au
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

if [[ $EUID -ne 0 ]]; then
   echo "install.sh must be run as root. try: sudo install.sh"
   exit 1
fi

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


echo "**** Installing custom Re4son kernel with kali wifi injection patch and TFT support ****"
## Old structure ##
##exitonerr dpkg -i raspberrypi-bootloader*
##exitonerr dpkg -i libraspberrypi0*
##exitonerr dpkg -i libraspberrypi-*
## New structure ##
apt-get update
exitonerr apt-get install device-tree-compiler
exitonerr dpkg --force-architecture -i --ignore-depends=raspberrypi-kernel raspberrypi-bootloader_*
exitonerr dpkg --force-architecture -i raspberrypi-kernel_*
exitonerr dpkg --force-architecture -i libraspberrypi0_*
exitonerr dpkg --force-architecture -i libraspberrypi-dev_*
exitonerr dpkg --force-architecture -i libraspberrypi-doc_*
exitonerr dpkg --force-architecture -i libraspberrypi-bin_*

echo "**** Installing device tree overlays for various screens ****"
echo "++++ Adafruit"
echo "++++ Elecfreak"
echo "++++ JBTek"
echo "++++ Sainsmart"
echo "++++ Waveshare"
echo "**** Device tree overlays installed ****"
echo "**** Kernel install complete! ****"
echo

echo "**** Fixing unmet dependencies in Kali Linux ****"
mkdir -p /etc/kbd
touch /etc/kbd/config
echo
echo "**** Unmet dependencies in Kali Linux fixed ****"
echo
echo "**** Setup onboard wifi and bluetooth ****"
#Raspberry Pi 3 & Zero W
if [ ! -f /lib/firmware/brcm/BCM43430A1.hcd ]; then
  cp firmware/BCM43430A1.hcd /lib/firmware/brcm/BCM43430A1.hcd
if [ ! -f  /etc/udev/rules.d/99-com.rules]; then
  cp firmware/99-com.rules /etc/udev/rules.d/99-com.rules


#Raspberry Pi Zero W
if [ ! -f /lib/firmware/brcm/brcmfmac43430-sdio.bin ]; then
  cp firmware/brcmfmac43430-sdio.bin /lib/firmware/brcm/brcmfmac43430-sdio.bin
if [ ! -f /lib/firmware/brcm/brcmfmac43430-sdio.txt ]; then
  cp firmware/brcmfmac43430-sdio.bin /lib/firmware/brcm/brcmfmac43430-sdio.txt

echo
echo "**** Onboard wifi and bluetooth setup ****"





echo "**** Documentation and help can be found in Sticky Finger's Kali-Pi forums at ****"
echo "**** https://whitedome.com.au/forums ****"
echo
echo "**** next you can run the universal setup tool to activate your TFT screen via ****"
echo "**** ./re4son-pi-tft-setup -t [pitfttype] ****"
echo
read -p "Reboot to apply changes? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  reboot
fi
