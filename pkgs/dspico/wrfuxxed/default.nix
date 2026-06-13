{
  pkgs,
  fetchFromGitHub,
  makeWrapper,
  dspico-dldi,
  ...
}:

let
  pname = "dspico-wrfuxxed";
  version = "1.0.0";

  inherit (pkgs.blocksdsNix) stdenvBlocksdsSlim;
  blocksds = pkgs.blocksdsNix.blocksdsSlim;
  blocksdsEnv = blocksds.passthru;
in
stdenvBlocksdsSlim.mkDerivation {
  inherit pname version;
  src = fetchFromGitHub {
    owner = "LNH-team";
    repo = "dspico-wrfuxxed";
    rev = "v${version}";
    hash = "sha256-+3aGnw9T7ZL/UfFSV1LTkO7RUw+Uw6NOKoetOm3/KCw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
    dspico-dldi
  ];
  DLDITOOL = "${blocksdsEnv.WONDERFUL_TOOLCHAIN}/thirdparty/blocksds/core/tools/dlditool/dlditool";

  buildPhase = ''
    make
    $DLDITOOL ${dspico-dldi}/share/dldi/DSpico.dldi uartBufv060.bin
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    cp uartBufv060.bin $out/share/

    runHook postInstall
  '';
}
