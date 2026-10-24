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

# 3. 集成 dae-box 软件包
if [ ! -d "package/dae-box" ]; then
  git clone --depth=1 https://github.com/hhCodingCat/dae-box.git /tmp/dae-box-src 2>/dev/null || true
  if [ -d "/tmp/dae-box-src/openwrt/dae-box" ]; then
    cp -r /tmp/dae-box-src/openwrt/dae-box package/dae-box
    rm -rf /tmp/dae-box-src
    echo "✅ 成功集成 package/dae-box"
  fi
fi

mkdir -p files/etc/uci-defaults
cat << 'EOF' > files/etc/uci-defaults/99-default-theme
uci set luci.main.mediaurlbase='/luci-static/aurora'
uci commit luci
exit 0
EOF
chmod +x files/etc/uci-defaults/99-default-theme
