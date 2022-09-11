#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#============================================================

# 修改默认IP
sed -i 's/192.168.1.1/10.32.0.1/g' package/base-files/files/bin/config_generate
# 修改网关
sed -i 's/192.168.$((addr_offset++)).1/10.32.0.1/g' package/base-files/files/bin/config_generate
# 修改默认插件
sed -i 's/dnsmasq-full firewall iptables ppp ppp-mod-pppoe \
	block-mount coremark kmod-nf-nathelper kmod-nf-nathelper-extra kmod-ipt-raw kmod-tun \
	iptables-mod-tproxy iptables-mod-extra ipset ip-full default-settings luci luci-newapi \
	ddns-scripts_aliyun ddns-scripts_dnspod luci-app-ddns luci-app-upnp luci-app-autoreboot \
	luci-app-arpbind luci-app-filetransfer luci-app-vsftpd luci-app-ssr-plus luci-app-vlmcsd \
	luci-app-accesscontrol luci-app-nlbwmon luci-app-turboacc luci-app-wol curl ca-certificates/firewall iptables ppp ppp-mod-pppoe \
	block-mount coremark kmod-nf-nathelper kmod-nf-nathelper-extra kmod-ipt-raw kmod-tun \
	iptables-mod-tproxy iptables-mod-extra ipset ip-full default-settings \
	luci-app-ddns luci-app-nps luci-app-autoreboot luci-app-ssr-plus curl ca-certificates/g' include/target.mk
# 删除默认密码
#sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

# 修改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-edge/g' ./feeds/luci/collections/luci/Makefile

# 取消bootstrap为默认主题
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# 修改主机名称
sed -i 's/OpenWrt/Yuos-Wrt/g' package/base-files/files/bin/config_generate

# 修改版本号
sed -i "s/OpenWrt /yuos-bit build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings

# 修改默认wifi名称ssid为tymishop
sed -i 's/ssid=OpenWrt/ssid=Xiaomi_$(cat /sys/class/ieee80211/${dev}/macaddress|awk -F ":" '{print $5""$6 }'| tr a-z A-Z)/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#开启MU-MIMO
sed -i 's/mu_beamformer=0/mu_beamformer=1/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#wifi加密方式，没有是none
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

#wifi密码
sed -i 's/key=15581822425/key=1234567890/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 删除软件包
rm -rf package/lean/luci-theme-argon


# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="MOLUN"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"MOLUN"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config
