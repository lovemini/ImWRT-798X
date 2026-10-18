#!/bin/bash
# diy-part1.sh

# 补充拉取 luci-theme-aurora（双重保障）
if [ ! -d "package/luci-theme-aurora" ]; then
  git clone --depth 1 https://github.com/eamonxg/luci-theme-aurora.git package/luci-theme-aurora 2>/dev/null || true
fi
