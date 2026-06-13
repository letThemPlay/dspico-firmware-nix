{
  stdenv,
  pkgs,
  fetchFromGitHub,
  ...
}:

{
  pname,
  postUnpack ? "",
  postPatch ? "",
}:

let
  version = "1.0.0";
in
stdenv.mkDerivation {
  inherit
    pname
    version
    postUnpack
    postPatch
    ;

  src = fetchFromGitHub {
    owner = "LNH-team";
    repo = "dspico-firmware";
    rev = "v${version}";
    hash = "sha256-RQz1ISua5J7SlWCBqcSrJvpkvS1sjlmr3sLVHJB6kqg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = builtins.attrValues {
    inherit (pkgs) cmake gcc-arm-embedded python3;
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_C_COMPILER=${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-gcc"
    "-DCMAKE_CXX_COMPILER=${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-g++"
    "-DCMAKE_ASM_COMPILER=${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-gcc"
  ];

  PICO_SDK_PATH = "../pico-sdk";
  CC = "arm-none-eabi-gcc";
  CXX = "arm-none-eabi-g++";
  ASM = "arm-none-eabi-gcc";
  CMAKE_POLICY_VERSION_MINIMUM = "3.5";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/
    cp DSpico.uf2 $out/share/

    runHook postInstall
  '';
}
