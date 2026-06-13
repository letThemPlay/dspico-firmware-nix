{
  callPackage,
  dspico-bootloader,
  dspico-wrfuxxed,
  srcDir,
  ...
}:

let
  base = callPackage ./base.nix { };

  # Hybrid firmware variant
  hybrid-firmware = base {
    pname = "hybrid-firmware";

    postUnpack = ''
      cp "${dspico-bootloader}/share/default.nds" $sourceRoot/roms/default.nds
    '';
  };

  # Wrfuxxed firmware variant
  wrfuxxed-firmware = base {
    pname = "wrfuxxed-firmware";

    postUnpack = ''
      cp "${dspico-bootloader}/share/default.nds" $sourceRoot/roms/default.nds
      cp "${srcDir}/files/dsimode.nds" $sourceRoot/roms/dsimode.nds
      cp "${dspico-wrfuxxed}/share/uartBufv060.bin" $sourceRoot/data/uartBufv060.bin
    '';

    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "#DSPICO_ENABLE_WRFUXXED" "DSPICO_ENABLE_WRFUXXED"
    '';
  };
in
{
  inherit hybrid-firmware wrfuxxed-firmware;
  default = hybrid-firmware;
}
