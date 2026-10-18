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

mkdir -p files/etc/uci-defaults
cat << 'EOF' > files/etc/uci-defaults/99-default-theme
uci set luci.main.mediaurlbase='/luci-static/aurora'
uci commit luci
exit 0
EOF
chmod +x files/etc/uci-defaults/99-default-theme

# 3. 注入 MT7981 5G 25dB 高功率 EEPROM 射频校准表
mkdir -p files/lib/firmware
mkdir -p package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom 2>/dev/null || true

EEPROM_SRC=""
for cand in "files/lib/firmware/e2p" "files/MT7981_iPAiLNA_EEPROM.bin" "../files/lib/firmware/e2p" "../files/MT7981_iPAiLNA_EEPROM.bin"; do
  if [ -f "$cand" ]; then
    EEPROM_SRC="$cand"
    break
  fi
done

if [ -n "$EEPROM_SRC" ]; then
  cp -f "$EEPROM_SRC" files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin
  # 确保 0x445 偏移量写入 20 个 0x2B (25dB 高功率校准)
  printf '\x2B%.0s' {1..20} | dd of="files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin" bs=1 seek=$((0x445)) conv=notrunc 2>/dev/null || true
  cp -f files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin files/lib/firmware/e2p
  # 同步到驱动内置目录（兼容 24.10 / 25.12）
  if [ -d "package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom" ]; then
    cp -f files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/MT7981_iPAiLNA_EEPROM.bin
    cp -f files/lib/firmware/MT7981_iPAiLNA_EEPROM.bin package/mtk/drivers/mt_wifi/files/mt7981-default-eeprom/e2p
  fi
  echo "✅ 成功注入 5G 25dB 高功率 EEPROM 至 files/lib/firmware/e2p"
fi

# 4. 解锁 MTK 无线 Profile 最大发射功率 TxPower=100
for f in package/mtk/drivers/wifi-profile/files/mt7981/*.dat; do
  if [ -f "$f" ]; then
    sed -i 's/TxPower=[0-9]*/TxPower=100/g' "$f" 2>/dev/null || true
  fi
done
echo "✅ 无线配置文件已设定最大功率 TxPower=100"
