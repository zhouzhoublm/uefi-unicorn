# uefi-unicorn 未完成项（M1 前必须逐条关闭）

由 uefi-mondrian（Redmi K60）复制改名而来。以下全部需要 unicorn 本机实测值：

- [ ] `Platforms/Xiaomi/unicornPkg/FdtBlob/sm8475-xiaomi-unicorn.dtb`：本机 DTB（面板序列的来源）
- [ ] `Library/MemoryMapLib/MemoryMapLib.c`：按 `/proc/iomem` 重写内存映射与保留区
- [ ] `Library/ConfigurationMapLib/ConfigurationMapLib.c`：UFS/ICB/时钟配置按 unicorn 核对
- [ ] `unicorn.dsc` 的 `PcdCPUCoresStackBase`（继承值 0xA760D000 是 K60 的空洞）+ `PcdSystemMemoryBase`
- [ ] `unicorn.dsc` 的 `SOC_TYPE`（0=SM8475 / 1=SM8475 OC / 2=SM7475-AB）
- [ ] `Drivers/UnicornBootMemoryDxe`：initrd 上限与 payload 装载窗口按 unicorn 内存布局核对
- [ ] `Resources/Configs/unicorn.toml`：`[uefi_fd] base/size` 选在 unicorn 的可用空洞里（避开 hyp/ramoops/XBL 保留区）
- [ ] `Resources/Configs/unicorn.toml`：`[boot_image] header_version` 按 `fastboot getvar` 实测（K60 是 v4）
- [ ] `KeypadDeviceLib`：unicorn 的 PON PPID / GPIO 键（现继承 K60KeypadDeviceLib）
- [ ] SMBIOS 串已改为 Xiaomi 12S Pro，核对一次
- [ ] `DeviceBuild.py` 里的设备列表/输出名
