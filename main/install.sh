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

# Change to a temporary directory
cd /tmp || exit

echo "Installing Dracut Network Manager Initramfs Module..."

# Download the zip file
curl -LO https://github.com/bl4ckw1d0w/dracut-network-manager-wireless/releases/download/v1.0/dracut-network-manager-wireless-v1.0.zip

# Unzip the downloaded file
unzip dracut-network-manager-wireless-v1.0.zip

# Determine the extracted directory name (assumes the directory name is the same as the zip file prefix)
EXTRACTED_DIR="dracut-network-manager-wireless-v1.0"

# Use rsync to copy files to the root directory
sudo rsync -av --inplace \
    --exclude='LICENCE' \
    --exclude='README.md' \
    --exclude='install.sh' \
    --exclude='dracut-network-manager-wireless-v1.0.zip' \
    "$EXTRACTED_DIR/" /

# Remove the temporary files
rm -rf "$EXTRACTED_DIR" dracut-network-manager-wireless-v1.0.zip

# Regenerate the initramfs
sudo dracut --force

echo "Dracut Network Manager Initramfs Module installed successfully!"
