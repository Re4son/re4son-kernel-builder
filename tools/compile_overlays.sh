#!/usr/bin/env bash
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Adafruit
# Copyright (c) 2016 Re4son, added support for dtbo required after linux
# kernel version 4.4
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


for f in ../dts/*.dts; do
  dtb=${f#../dts/}
  dtb=${dtb%.*}
  dtbo=${dtb%-overlay}
  echo "compiling ${dtb}.dtb"
  dtc -@ -I dts -O dtb -o ../boot/overlays/${dtb}.dtb $f
  echo "compiling ${dtbo}.dtbo"
  dtc -@ -O dtb -o ../boot/overlays/${dtbo}.dtbo -b 0 $f
  chmod +x ../boot/overlays/${dtb}.dtb
  chmod +x ../boot/overlays/${dtbo}.dtbo
done

