##
#  Copyright (c) 2011 - 2022, ARM Limited. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#  Copyright (c) 2015 - 2020, Intel Corporation. All rights reserved.
#  Copyright (c) 2018, Bingxing Wang. All rights reserved.
#  Copyright (c) Microsoft Corporation.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
##

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = unicorn
  PLATFORM_GUID                  = B1604F78-DF37-4803-8BC0-BEF397B882B9
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/unicornPkg
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = RELEASE|DEBUG
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = unicornPkg/unicorn.fdf
  USE_CUSTOM_DISPLAY_DRIVER      = 1

  #
  # 0 = SM8475
  # 1 = SM8475    (Overclocked)
  # 2 = SM7475-AB
  #
  SOC_TYPE                       = 0

!include PalimaPkg/PalimaPkg.dsc.inc

[PcdsFixedAtBuild]
  #
  # DDR Memory
  #
  gArmTokenSpaceGuid.PcdSystemMemoryBase|0x80000000

  #
  # UEFI Stack
  #
  gArmPlatformTokenSpaceGuid.PcdCPUCoresStackBase|0xA760D000
  gArmPlatformTokenSpaceGuid.PcdCPUCorePrimaryStackSize|0x40000

  #
  # SMBIOS
  #
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemManufacturer|"Xiaomi"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemModel|"Xiaomi 12S Pro"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemRetailModel|"unicorn"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemRetailSku|"Xiaomi_12S_Pro_unicorn"
  gSiliciumPkgTokenSpaceGuid.PcdSmbiosSystemBoardModel|"Xiaomi 12S Pro"

  #
  # Simple Frame Buffer
  #
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferWidth|1440
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferHeight|3200
  gSiliciumPkgTokenSpaceGuid.PcdFrameBufferColorDepth|32

  #
  # Platform PEI
  #
  gQcomPkgTokenSpaceGuid.PcdPlatformType|"LA"

[LibraryClasses]
  # UniXNU boot manager core; DarwinBoot provides the XNU loader protocol.
  UniXNULib|UniXNUPkg/Library/UniXNULib/UniXNULib.inf

  # Advanced Logger chain (official log-capture integration)
  AdvancedLoggerLib|AdvLoggerPkg/Library/AdvancedLoggerLib/DxeCore/AdvancedLoggerLib.inf
  AdvancedLoggerAccessLib|AdvLoggerPkg/Library/AdvancedLoggerAccessLib/AdvancedLoggerAccessLib.inf
  QrEncoderLib|MsGraphicsPkg/Library/QrEncoderLib/QrEncoderLib.inf
  AdvancedLoggerHdwPortLib|AdvLoggerPkg/Library/AdvancedLoggerHdwPortLib/AdvancedLoggerHdwPortLib.inf

  #
  # Memory Libraries
  #
  MemoryMapLib|unicornPkg/Library/MemoryMapLib/MemoryMapLib.inf

  #
  # QCOM Libraries
  #
  ConfigurationMapLib|unicornPkg/Library/ConfigurationMapLib/ConfigurationMapLib.inf

  #
  # K60 keypad sampling (official KeypadDevice protocol producer)
  #
  KeypadDeviceLib|QcomPkg/Library/K60KeypadDeviceLib/K60KeypadDeviceLib.inf

  #
  # Route DXE-phase debug output into the Advanced Logger buffer (official
  # log-capture.md step 2). PEI/SEC/DxeCore keep the serial (framebuffer)
  # DebugLib, so early debug output stays visible on screen unchanged.
  # Entries are echoed back to the framebuffer by the real HdwPort lib.
  #
[LibraryClasses.common.DXE_DRIVER]
  DebugLib|AdvLoggerPkg/Library/BaseDebugLibAdvancedLogger/BaseDebugLibAdvancedLogger.inf
  AssertLib|AdvLoggerPkg/Library/AssertLib/AssertLib.inf
  AdvancedLoggerLib|AdvLoggerPkg/Library/AdvancedLoggerLib/Dxe/AdvancedLoggerLib.inf


[LibraryClasses.common.UEFI_DRIVER]
  DebugLib|AdvLoggerPkg/Library/BaseDebugLibAdvancedLogger/BaseDebugLibAdvancedLogger.inf
  AssertLib|AdvLoggerPkg/Library/AssertLib/AssertLib.inf
  AdvancedLoggerLib|AdvLoggerPkg/Library/AdvancedLoggerLib/Dxe/AdvancedLoggerLib.inf

[LibraryClasses.common.UEFI_APPLICATION]
  DebugLib|AdvLoggerPkg/Library/BaseDebugLibAdvancedLogger/BaseDebugLibAdvancedLogger.inf
  AssertLib|AdvLoggerPkg/Library/AssertLib/AssertLib.inf
  AdvancedLoggerLib|AdvLoggerPkg/Library/AdvancedLoggerLib/Dxe/AdvancedLoggerLib.inf

[Components]
  UniXNUPkg/Application/UniXNU/UniXNU.inf
  UniXNUPkg/Driver/UniXNUDxe/UniXNUDxe.inf
  DarwinBootPkg/Driver/DarwinBoot.inf
  UniXNUPkg/Driver/UniXNURamDiskDxe/UniXNURamDiskDxe.inf
  UniXNUPkg/Driver/AdvancedLogDxe/AdvancedLogDxe.inf
  unicornPkg/Drivers/AdvLogDxe/AdvLogDxe.inf
  unicornPkg/Drivers/UnicornBootMemoryDxe/UnicornBootMemoryDxe.inf
  unicornPkg/Test/UnicornPayloadProbe/UnicornPayloadProbe.inf
  unicornPkg/Test/UnicornInitrdTest/UnicornInitrdTest.inf

  #
  # ACPI Tables
  #
  # Platforms/Xiaomi/unicorn is vendored in this repo: the Silicium-ACPI
  # submodule pin does not carry that platform, so a clean clone could not
  # resolve this module otherwise.
  # M2/M1 禁用：unicorn/AcpiTables.inf 引用的 AML 在 uefi-mondrian / Silicium-ACPI 里都不完整；
  # UniXNU 不依赖 EFI_ACPI_TABLE_PROTOCOL，等补齐 aml 再打开。
  # unicorn/AcpiTables.inf

# K60 debug: ASSERT prints and continues (vendor EnvDxe ctor ASSERT, no RamPartitionDxe)
[PcdsFixedAtBuild]
  gEfiMdePkgTokenSpaceGuid.PcdDebugPropertyMask|0x02  # 打印开、断言关（DEBUG 固件也能稳定跑）
  # K60 bring-up: ERROR only. DEBUG_LOAD (0x4) makes DxeCore print one
  # "Loading driver at 0x... EntryPoint=0x..." line per image, which scrolls
  # the UniXNU ERROR lines off the screen. Turn 0x4 back on only while
  # locating a load-time fault.
  gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel|0x80000002  # 只打印 ERROR|WARN：
  # UniXNULog 与 DarwinBoot 的 Print 都用 ERROR 级，所以关键信息都在；
  # 同时把 DXE core 的 POOL/PAGE/DISPATCH/INFO 刷屏挡掉。
  # K60 debug: UniXNU app logs (menu/payload) become ERROR so they
  # pass the global level and reach the Advanced Logger buffer.
  gUniXNUPkgTokenSpaceGuid.PcdUniXNUDebugLevel|0x80000000
  gUniXNUPkgTokenSpaceGuid.PcdUniXNUDeviceModel|"Xiaomi 12S Pro"
