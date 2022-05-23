#!/bin/bash

# Copyright 2022 Paolo Smiraglia <paolo.smiraglia@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -ue

function _do_notify {
    msg=${1}
    who | while read -r line; do
        user=$(echo ${line} | sed -e "s/  */#/g" | cut -d'#' -f1)
        display=$(echo ${line} | sed -e "s/  */#/g" | cut -d'#' -f2)
        dbus_address="unix:path=/run/user/$(id -u ${user})/bus"
        sudo -u ${user} \
            DISPLAY=${display} \
            DBUS_SESSION_BUS_ADDRESS=${dbus_address} \
            /usr/bin/notify-send -u critical "$msg"
    done
}

capacity=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [ ${capacity} -le 40 ] && [ "${status}" != "Charging" ]; then
    _do_notify \
        "Battery capacity is ${capacity}% (${status}). Please START charging."
fi

if [ ${capacity} -ge 80 ] && [ "${status}" == "Charging" ]; then
    _do_notify \
        "Battery capacity is ${capacity}% (${status}). Please STOP charging."
fi
