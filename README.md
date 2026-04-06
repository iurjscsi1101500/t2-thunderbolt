# Apple T2 Resume Fixes

This repository contains the currently relevant Apple T2 Thunderbolt and
PCIe resume fixes as separate patches.

The original Thunderbolt patch is still useful, but it is not the fix
for the long secondary-CPU bringup times after S3 resume. The actual
resume-time fix is a `pcieport` change that forces the Apple T2
Thunderbolt root ports to use INTx instead of MSI/MSI-X for PCIe port
services.

## Patches

- `patches/0001-thunderbolt-add-device-links-for-integrated-Apple-T2-NHI.patch`
  Companion fix for integrated T2 Thunderbolt NHIs. It creates the
  missing device links for ACPI `TRP*` root ports so the warning
  `device links to tunneled native ports are missing!` goes away and
  Thunderbolt tunnel ordering is correct after sleep.
- `patches/0002-PCI-portdrv-use-INTx-for-Apple-T2-Thunderbolt-root-port-services.patch`
  Resume fix for Apple T2 Macs. It matches ACPI `TRP*` root ports and
  forces PCIe port services onto INTx instead of MSI/MSI-X. This is the
  change that eliminates the multi-second `smpboot` delays after S3
  resume.

## Status

- Tested on MacBookAir9,1.
- `0002` fixes the slow `smpboot` phase seen after resume.
- `0001` is a separate companion patch and should not be treated as the
  primary resume fix.
- The older PCI quirk that tried to keep the ports in D0 was dropped.

## Quick Test

If you only want to test the Thunderbolt companion patch as a module:

```sh
make
sudo make install
```

This builds and installs `thunderbolt.ko` from `drivers/thunderbolt/`
against the running kernel.

For the actual resume fix in `0002`, a kernel rebuild is required
because it changes `drivers/pci/pcie/portdrv.c`.

## Upstream

Both fixes are available as mail-ready patch files and can be used for
upstream submission independently.
