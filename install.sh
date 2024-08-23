#!/bin/bash
# #
# # Copyright (c) 2024 bl4ckw1d0w
# #
# # Licensed under the MIT License. You may not use this file except in
# # compliance with the License.
# # You may obtain a copy of the License at
# # https://opensource.org/licenses/MIT
# #
# # Attribution is required for any use, modification, or distribution of this
# # code. Please provide a link back to the original repository or author when
# # using this code.
# #
# # Description: This module embeds NetworkManager and wpa_supplicant into
# #              initramfs, enabling Wi-Fi connectivity during early boot. It
# #              configures essential services, drivers, and permissions for
# #              seamless network management before the main system loads.
# #      GitHub: www.github.com/bl4ckw1d0w/dracut-network-manager-wireless
# #      E-mail: bl4ckw1d0w.github@gmail.com

cd /tmp/dnmwinst

echo "Installing Dracut Network Manager Initramfs Module..."

curl -LO https://raw.githubusercontent.com/bl4ckw1d0w/dracut-network-manager\
          -wireless/main/dracut-network-manager-v1.0.zip

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
unzip "$SCRIPT_DIR"/dracut-network-manager-wireless-v1.0.zip

sudo rsync -av --inplace --exclude='LICENCE' --exclude='README.md'\
     --exclude='install.sh'--exclude='dracut-network-manager-wireless-v1.0.zip'\
     "$SCRIPT_DIR"/* /

rm -rf ./* ./

sudo dracut --force

echo "Dracut Network Manager Initramfs Module installed successfully!"
