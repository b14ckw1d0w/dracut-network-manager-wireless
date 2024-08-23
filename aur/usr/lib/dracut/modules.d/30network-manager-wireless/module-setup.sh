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

check() {
    require_binaries wpa_supplicant rfkill || return 1
    return 255
}

depends() {
    echo dbus systemd systemd-initrd udev-rules dracut-systemd shutdown
    return 0
}

installkernel() {
    # Add specific drivers
    add_drivers+=" ath9k_htc iwlmvm iwlwifi mac80211 cfg80211 rfkill "
    instmods iwlmvm mac80211 ath9k_htc ath9k_common ath iwlwifi cfg80211 rfkill
    inst_multiple -o /lib/firmware/{iwlwifi*,iwlmvm,ath9k_htc*}
}

install() {
    _nm_version=${NM_VERSION:-$(NetworkManager --version)}
    inst_multiple -o /etc/wpa_supplicant/wpa_supplicant.conf wpa_supplicant\
                     wpa_passphrase rfkill ping ncat sleep chvt grep awk head
    # shellcheck disable=SC2154
    inst_multiple -o "$dbussystemconfdir"/wpa_supplicant.conf\
                     "$dbussystemservices"/fi.w1.wpa_supplicant1.service\
                     "${systemdsystemunitdir}/wpa_supplicant.service"
    inst "$systemdsystemunitdir"/wpa_supplicant.service
    inst_libdir_file "NetworkManager/$_nm_version/libnm-device-plugin-wifi.so"
    inst_simple /etc/ssl/certs/ca-certificates.crt
    inst_simple /etc/ca-certificates/extracted/tls-ca-bundle.pem
    inst_simple /etc/dbus-1/system.d/wpa_supplicant.conf
    if [ -d /etc/NetworkManager/system-connections ]; then
        # shellcheck disable=SC2154
        mkdir -p "$initdir/etc/NetworkManager/system-connections"
        cp -r /etc/NetworkManager/system-connections/*\
              "$initdir/etc/NetworkManager/system-connections/"
    fi
    instmods iwlwifi iwlmvm ath9k_htc rfkill
    # shellcheck disable=SC1004
    sed -i -e \
        '/^\[Unit\]/aDefaultDependencies=no\
        Conflicts=shutdown.target\
        Before=shutdown.target\
        After=dbus.service' \
        "${initdir}/${systemdsystemunitdir}/wpa_supplicant.service"
        mkdir -p "${initdir}/etc/dbus-1/system.d/"
        cat <<EOT > "${initdir}/etc/dbus-1/system.d/wpa_supplicant.conf"
<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
   "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
    <policy user="root">
        <allow own="fi.w1.wpa_supplicant1"/>
        <allow send_destination="fi.w1.wpa_supplicant1"/>
        <allow send_interface="fi.w1.wpa_supplicant1"/>
        <allow send_type="method_call"/>
        <allow send_type="signal"/>
        <allow send_type="error"/>
    </policy>
</busconfig>
EOT
    $SYSTEMCTL -q --root "$initdir" enable wpa_supplicant.service
}
