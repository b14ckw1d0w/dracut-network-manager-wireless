# Dracut Network Manager Wireless Module

## Overview

This project provides a custom dracut module for initializing Wi-Fi connections with wpa_supplicant and NetworkManager during the early boot process, particularly within an initramfs environment.

**IMPORTANT:** Before using this module, ensure that Clevis, LUKS, and dracut are properly set up and functioning on your system.

## Requirements

- Clevis
- LUKS
- Dracut
- NetworkManager
- wpa_supplicant
- Intel iwlwifi driver or Atheros ath9k WiFi Card, or add your own drivers to the initram.

## Installation

1. Run the following command to install:
    ```bash
    cd ~/ && curl -fsSL https://raw.githubusercontent.com/b14ckw1d0w/dracut-network-manager-wireless/main/main/install.sh -o install.sh && sudo bash install.sh
    ```

2. Reboot your system to apply the changes.

3. Or install from the AUR on Arch. [Coming soon...]

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details. Contributions to the project must adhere to this license.

## Contributing

Please feel free to fork this repository and contribute back via pull requests. All contributions are welcome and should be made under the terms of the Apache License 2.0.

## Acknowledgments

Special thanks to all contributors and the open-source community for their continued support and contributions.


