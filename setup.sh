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

apt-get update
apt-get install -y git rsync bc unzip build-essential libncurses5-dev debhelper quilt devscripts emacs vim

## Download calibration tool to be included in kernel packages
wget -P ./tools/ http://whitedome.com.au/download/xinput-calibrator_0.7.5-1_armhf.deb

if [ -L /usr/sbin/re4sonbuild ]; then
  rm /usr/sbin/re4sonbuild
fi

if [ ! -d Re4son-Pi-TFT-Setup/.git ]; then
  echo "**** CLONING Re4son-Pi-TFT-Setup REPO ****"
  git clone --depth 1 https://github.com/Re4son/Re4son-Pi-TFT-Setup
else
  cd Re4son-Pi-TFT-Setup
  git pull
  cd ..
fi

## Adjust this:
ln -s /opt/re4son-kernel-builder/build.sh /usr/sbin/re4sonbuild
chmod +x /opt/re4son-kernel-builder/build.sh

if ! grep -Fq "Re4son" ~/.bashrc; then
  echo 'export EMAIL="re4son@users.noreply.github.com"' >> ~/.bashrc
  echo 'export DEBFULLNAME="Re4son"' >> ~/.bashrc
fi
