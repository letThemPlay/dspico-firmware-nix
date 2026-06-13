{
  pkgs,
  fetchFromGitHub,
  makeWrapper,
  dspico-dldi,
  dsromencryptor,
  ...
}:

let
  pname = "dspico-bootloader";
  version = "1.0.0";

  inherit (pkgs.blocksdsNix) stdenvBlocksdsSlim;
  blocksds = pkgs.blocksdsNix.blocksdsSlim;
  blocksdsEnv = blocksds.passthru;
in
stdenvBlocksdsSlim.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "LNH-team";
    repo = "dspico-bootloader";
    rev = "v${version}";
    hash = "sha256-7ZDnOp3V4rUEDAWDxYX+GbxN1CsLbtHLjgK38TCuaA4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = builtins.attrValues {
    inherit (pkgs) dotnet-sdk9;
    inherit makeWrapper dspico-dldi dsromencryptor;
  };

  DLDITOOL = "${blocksdsEnv.WONDERFUL_TOOLCHAIN}/thirdparty/blocksds/core/tools/dlditool/dlditool";

  buildPhase = ''
    make
    $DLDITOOL ${dspico-dldi}/share/dldi/DSpico.dldi BOOTLOADER.nds
    ${dsromencryptor}/bin/DSRomEncryptor BOOTLOADER.nds default.nds
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    cp BOOTLOADER.nds $out/share/
    cp default.nds $out/share

    runHook postInstall
  '';
}
