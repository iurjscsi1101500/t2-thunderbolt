# Thunderbolt T2 Resume Fix Module

This fixes a Thunderbolt resume ordering problem seen on Apple T2 Macs.
Without the patch, the Thunderbolt driver can miss the native PCIe ports
that need device links back to the NHI, leading to the warning
`device links to tunneled native ports are missing!` and contributing to
slow or fragile resume behavior.

The fix extends `tb_apple_add_links()` so integrated T2 Thunderbolt
controllers are handled explicitly: when there is no upstream PCIe port,
the driver scans root ports on the same bus as the NHI, matches Apple
ACPI `TRP*` ports, and creates the missing device links so Thunderbolt
tunnels can be re-established in the right order after sleep.

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

## Install

```sh
sudo make install
```

This installs `thunderbolt.ko` to
`/lib/modules/$(uname -r)/updates/thunderbolt.ko` and runs `depmod -a`.

To load the updated module, unload and reload `thunderbolt` when the
device is idle, or reboot into the same kernel version.

## Notes

- If module signature enforcement or Secure Boot is active, the installed
  module may still be rejected unless it is signed with a trusted key.
