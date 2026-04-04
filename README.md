# Thunderbolt T2 Resume Fix Module

This repository packages the patched Linux Thunderbolt driver as an
out-of-tree kernel module so it can be built and installed without
rebuilding the whole kernel.

The current patch changes `tb_apple_add_links()` in
`drivers/thunderbolt/tb.c` to handle integrated Thunderbolt on Apple T2
systems by creating device links for `TRP*` ACPI-named root ports on the
same PCI bus as the NHI.

## Build

```sh
make
```

By default this builds against the running kernel via
`/lib/modules/$(uname -r)/build`.

To build against a different kernel tree:

```sh
make KDIR=/path/to/kernel/build
```

## Install

```sh
sudo make install
```

This installs `thunderbolt.ko` to
`/lib/modules/$(uname -r)/updates/thunderbolt.ko` and runs `depmod -a`.

To load the updated module, unload and reload `thunderbolt` when the
device is idle, or reboot into the same kernel version.

## Notes

- This repository contains a copy of `drivers/thunderbolt` from the
  matching kernel tree plus the local T2 fix.
- For the running `6.19.9` kernel, build and install should work as long
  as the target kernel headers/build tree are present.
- If module signature enforcement or Secure Boot is active, the installed
  module may still be rejected unless it is signed with a trusted key.
