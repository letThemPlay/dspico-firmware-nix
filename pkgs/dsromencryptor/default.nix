{
  pkgs,
  fetchFromGitHub,
  srcDir,
}:
let
  pname = "DSRomEncryptor";
  version = "1.0.1";
in
pkgs.buildDotnetModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Gericom";
    repo = "DSRomEncryptor";
    rev = "f44682e79a5657dec62682ef80649506f561f00e";
    hash = "sha256-14rNTck3oeEjMzLEkTFf/zV/nUVrU+Eu4ZZ7Ak9pokA=";
  };

  projectFile = "DSRomEncryptor/DSRomEncryptor.csproj";

  dotnetFlags = [ "-p:RuntimeIdentifier=linux-x64" ];

  selfContainedBuild = true;
  nugetDeps = ./deps.json;

  dotnet-sdk = pkgs.dotnet-sdk_9;

  postInstall = ''
    cp "${srcDir}/files/biosdsi7.rom" $out/lib/DSRomEncryptor/biosdsi7.rom
    cp "${srcDir}/files/biosnds7.rom" $out/lib/DSRomEncryptor/biosnds7.rom
  '';
}
