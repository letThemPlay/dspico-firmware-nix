{
  pkgs,
  fetchFromGitHub,
  makeWrapper,
  ...
}:

let
  pname = "dspico-dldi";
  version = "1.0.1";

  inherit (pkgs.blocksdsNix) stdenvBlocksdsSlim;
in
stdenvBlocksdsSlim.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "LNH-team";
    repo = "dspico-dldi";
    rev = "v${version}";
    hash = "sha256-UdHkl0ML2VWuAKbtA/cYNaYEkI+zC/xQ7jteyU9wPlg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/dldi
    cp DSpico.dldi $out/share/dldi/

    runHook postInstall
  '';
}
