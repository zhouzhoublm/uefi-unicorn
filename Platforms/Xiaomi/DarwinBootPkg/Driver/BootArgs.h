// SPDX-License-Identifier: BSD-2-Clause-Patent
#ifndef DARWIN_BOOT_ARGS_H_
#define DARWIN_BOOT_ARGS_H_

#include <Base.h>

//
// K60 port delta: pong's vendored copy of this package carries the Darwin 24
// ABI (XNU 11417.140.69, 0x480-byte boot_args).  The K60 payload is
// ipados-16.6.1-20G81, i.e. XNU 8796.141.3 / Darwin 22, whose boot_args is
// 0x2e0 bytes with a 608-byte command line.  Handing a Darwin 22 kernel a
// Darwin 24 layout puts BootFlags and MemorySizeActual 0x1a0 bytes past where
// the kernel reads them, which is an immediate fault on handoff.
//
// Everything else in this package is pong's copy unchanged.  To build for a
// Darwin 24 payload, restore the four values this block replaces:
//   DARWIN_BOOT_LINE_LENGTH 1024
//   BootFlags        0x470
//   MemorySizeActual 0x478
//   sizeof           0x480
//
// DARWIN 24 / XNU 11417.140.69 pexpert/pexpert/arm64/boot.h ABI:
//   CommandLine 0x6c (1024 B), BootFlags 0x470, MemorySizeActual 0x478, sizeof 0x480.
// 本移植（unicorn / ipados-18.7.10-22H374）用的就是 Darwin 24，所以这里取 1024 这组值；
// 608/0x2e0 那组是 K60 跑 16.6.1(Darwin 22) 时的，留着会 EFI_BAD_BUFFER_SIZE 且 ABI 错位。
//
#define DARWIN_BOOT_LINE_LENGTH 1024
typedef struct {
  UINT16  Revision;
  UINT16  Version;
  UINT32  Padding;
  UINT64  VirtualBase;
  UINT64  PhysicalBase;
  UINT64  MemorySize;
  UINT64  TopOfKernelData;
  UINT64  Video[6];
  UINT32  MachineType;
  UINT32  TreePadding;
  UINT64  DeviceTree;
  UINT32  DeviceTreeLength;
  CHAR8   CommandLine[DARWIN_BOOT_LINE_LENGTH];
  UINT32  FlagsPadding;
  UINT64  BootFlags;
  UINT64  MemorySizeActual;
} DARWIN_BOOT_ARGS;

STATIC_ASSERT (OFFSET_OF (DARWIN_BOOT_ARGS, DeviceTree) == 0x60, "DT ABI");
STATIC_ASSERT (OFFSET_OF (DARWIN_BOOT_ARGS, Video) == 0x28, "video ABI");
STATIC_ASSERT (OFFSET_OF (DARWIN_BOOT_ARGS, CommandLine) == 0x6c, "command line ABI");
STATIC_ASSERT (OFFSET_OF (DARWIN_BOOT_ARGS, BootFlags) == 0x470, "flags ABI");
STATIC_ASSERT (OFFSET_OF (DARWIN_BOOT_ARGS, MemorySizeActual) == 0x478, "memory ABI");
STATIC_ASSERT (sizeof (DARWIN_BOOT_ARGS) == 0x480, "Darwin 24 boot_args ABI");

#endif
