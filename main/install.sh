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

cd ~/ && mkdir dracut-network-manager-wireless-v1.0                                            ─╯
curl -fsSl "https://raw.githubusercontent.com/b14ckw1d0w/dracut-network-manager-wireless/main/main/dracut-network-manager-wireless-v1.0.zip" -o ~/dracut-network-manager-wireless-v1.0.zip
unzip dracut-network-manager-wireless-v1.0.zip -d ~/dracut-network-manager-wireless-v1.0
cd dracut-network-manager-wireless-v1.0
rm -rf /etc/dracut.conf.d/dracut-network-manager-wireless /usr/lib/dracut/modules.d/30network-manager-wireless/
rsync -av --inplace "./" /
cd ..
rm -rf ~/dracut-network-manager-wireless-v1.0.zip ~/dracut-network-manager-wireless-v1.0/
dracut --force --no-hostonly --no-hostonly-cmdline
dracut --force --uefi --no-hostonly --hostonly-cmdline
