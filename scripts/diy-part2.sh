#!/bin/bash
# diy-part2.sh

# 1. 修改默认 IP 为 192.168.2.1
CONFIG_FILE="package/base-files/files/bin/config_generate"
if [ -f "$CONFIG_FILE" ]; then
  sed -i 's/192\.168\.1\.1/192.168.2.1/g; s/192\.168\.6\.1/192.168.2.1/g' "$CONFIG_FILE"
  echo "✅ 默认 IP 已更新为 192.168.2.1"
fi

# 2. 修改默认主题为 luci-theme-aurora
if [ -f "feeds/luci/modules/luci-base/root/etc/config/luci" ]; then
  sed -i 's/luci-theme-bootstrap/luci-theme-aurora/g' feeds/luci/modules/luci-base/root/etc/config/luci 2>/dev/null || true
  sed -i 's/luci-theme-argon/luci-theme-aurora/g' feeds/luci/modules/luci-base/root/etc/config/luci 2>/dev/null || true
  echo "✅ 默认主题已配置为 luci-theme-aurora"
fi

# 2. 修改KSMBD的版本
if [ -f "feeds/packages/net/ksmbd-tools/Makefile" ]; then
  sed -i 's/PKG_VERSION:=3.5.6/PKG_VERSION:=3.5.7/g' feeds/packages/net/ksmbd-tools/Makefile 2>/dev/null || true
  sed -i 's/PKG_HASH:=8ce27cf947667b634478186aa7ef91fce68461c781d3880693a4639f8fecc397/PKG_HASH:=d8e532b2d032e3f447f3fd19e0f9ea0abeb355285f8d6871ce9036bc6393a5b2/g' feeds/packages/net/ksmbd-tools/Makefile 2>/dev/null || true
  echo "✅ 修改KSMBD的版本3.5.7 "
fi

mkdir -p files/etc/uci-defaults
cat << 'EOF' > files/etc/uci-defaults/99-default-theme
uci set luci.main.mediaurlbase='/luci-static/aurora'
uci commit luci
exit 0
EOF
chmod +x files/etc/uci-defaults/99-default-theme
