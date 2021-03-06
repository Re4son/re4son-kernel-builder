#!/usr/bin/env bash
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Adafruit
# Copyright (c) 2016 Re4son, redesigned for standalone use, latest toolchain,
#                            firmware and kernel versions
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

function check_root(){
    if [[ $EUID -ne 0 ]]; then
        printf "\n\t\t$(basename $0) must be run as root.\n\t\ttry: sudo ${0}\n\n"
        exit 1
    fi
}

################################################
################################################
##                                            ##
##                    MAIN                    ##

check_root
apt-get update
apt-get install -y git rsync bc flex unzip build-essential libncurses5-dev debhelper quilt devscripts
ARCH=`dpkg --print-architecture`
if [ ${ARCH} == "amd64" ] || [ ${ARCH} == "arm64" ]; then
    apt-get install crossbuild-essential-arm64 crossbuild-essential-armel crossbuild-essential-armhf
fi

if [ -L /usr/sbin/re4sonbuild ]; then
  rm /usr/sbin/re4sonbuild
fi

## Adjust this:
ln -s /opt/re4son-kernel-builder/build.sh /usr/sbin/re4sonbuild
chmod +x /opt/re4son-kernel-builder/build.sh

if ! grep -Fq "Re4son" ~/.bashrc; then
  echo 'export EMAIL="re4son@users.noreply.github.com"' >> ~/.bashrc
  echo 'export DEBFULLNAME="Re4son"' >> ~/.bashrc
fi
if ! grep -Fq "Re4son" ~/.zshrc; then
  echo 'export EMAIL="re4son@users.noreply.github.com"' >> ~/.zshrc
  echo 'export DEBFULLNAME="Re4son"' >> ~/.zshrc
fi

exit 0

##                                            ##
################################################
################################################
