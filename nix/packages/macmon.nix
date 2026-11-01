{ stdenvNoCC, fetchurl }:
stdenvNoCC.mkDerivation rec {
  pname = "macmon";
  version = "0.10.0";
  src = fetchurl {
    url = "https://github.com/vladkens/macmon/releases/download/v${version}/macmon-v${version}.tar.gz";
    sha256 = "0ccff60b7bf67bcb9e09cc8f804656a1cafa7eeae7297ee83d10e460ead7d43d";
  };
  sourceRoot = ".";
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 macmon "$out/bin/macmon"
    runHook postInstall
  '';
  meta.platforms = [ "aarch64-darwin" ];
}
