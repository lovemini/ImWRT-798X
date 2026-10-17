# ImmortalWrt-Builder (MT7981 / RAX3000M) 🚀

![License](https://img.shields.io/github/license/hhCodingCat/ImWRT-798X?color=blue)
![Target](https://img.shields.io/badge/Target-CMCC_RAX3000M_NAND-orange)

基于 GitHub Actions 自动化构建 **ImmortalWrt 24.10 / 25.12** 固件，专为 **中国移动 RAX3000M (NAND)** 等 MediaTek MT7981 设备量身定制。纯净精悍、剔除冗余、开箱即用。

---

## ✨ 特性亮点

- **专注主力机型**：默认适配 **中国移动 RAX3000M (NAND)**，开箱即用。
- **双分支版本支持**：
  - **24.10 (Linux 6.6 内核)**：成熟稳定，源自 `padavanonly/immortalwrt-mt798x-24.10`。
  - **25.12**：前沿版本，源自 `chasey-dev/immortalwrt-mt798x-rebase`。
- **独立解耦 Feeds**：`feeds-24.10.conf.default` 与 `feeds-25.12.conf.default` 分离，杜绝源污染。
- **5G 25dB 射频增强**：支持启用高功率模式释放 Wi-Fi 潜能。
- **MTK 原厂驱动 & 硬件加速**：包含 `kmod-mt_wifi` 与 `kmod-mediatek_hnat` 硬件 NAT 加速。
- **自动化发布**：构建产物（`sysupgrade.bin`、`factory.bin` 与 `sha256sums`）自动发布至 **GitHub Releases**。
- **默认网络参数**：
  - 管理后台：`192.168.2.1`
  - 登录密码：`无（空密码）`

---

## 🛠️ 目录架构

```text
├── .github/workflows/
│   ├── IMwrt-24.10-6.6.yml         # 24.10-6.6 固件构建工作流
│   ├── ImmortalWrt-25.10.yml       # 25.12 固件构建工作流
│   └── clean-releases-tags.yml     # 旧 Release / Tag 定期清理
├── feeds-24.10.conf.default        # 24.10 专用软件源配置
├── feeds-25.12.conf.default        # 25.12 专用软件源配置 (含 Aurora 主题)
├── 24.10-6.6.config                # 24.10 精简内核与插件配置
├── mt7981-ax3000.config            # 25.12 精简内核与插件配置
├── files/
│   └── MT7981_iPAiLNA_EEPROM.bin   # MT7981 EEPROM 射频校准文件
└── scripts/
    ├── diy-part1.sh                # 更新 Feeds 前自定义脚本
    └── diy-part2.sh                # 更新 Feeds 后自定义脚本 (IP、EEPROM链接等)
```

---

## 🚀 使用指南

### 1. 手动触发编译
1. 打开仓库的 **Actions** 标签页。
2. 选择工作流：
   - `ImmortalWrt-24.10-6.6固件构建`
   - `ImmortalWrt-25.12固件构建`
3. 点击 **Run workflow**：
   - 目标机型默认已预选 `cmcc_rax3000m`。
   - 点击确认即可开始自动编译。

### 2. 下载固件
编译成功后，固件文件会自动推送到 [Releases](https://github.com/hhCodingCat/ImWRT-798X/releases)：
- `*sysupgrade.bin`：在原有系统后台直接选择“升级固件”（保留配置或不保留配置刷入）。
- `*factory.bin`：U-Boot 或原厂恢复后台首次刷入。
- `sha256sums`：刷机前校验镜像文件完整性。

---

## ⚠️ 注意事项

1. **刷机风险**：刷写固件前务必确认设备为 **RAX3000M NAND 闪存版**。
2. **备份数据**：首次刷入建议在 U-Boot 或系统后台备份 `Factory` 分区与原有配置。
3. **编译时长**：GitHub Actions 首次完整编译耗时约 40-70 分钟，后续有 ccache 缓存加速会大幅缩短。

---

## 📄 许可证
本项目遵循 [MIT 许可证](LICENSE)。
