{ stdenvNoCC, fetchurl }:
stdenvNoCC.mkDerivation rec {
  pname = "telegraf";
  version = "1.40.2";
  src = fetchurl {
    url = "https://dl.influxdata.com/telegraf/releases/telegraf-${version}_darwin_arm64.tar.gz";
    sha256 = "04e559186b50c0844cfb6afc18176e0d5d698525dff16e9a527c466bea7b208e";
  };
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 usr/bin/telegraf "$out/bin/telegraf"
    runHook postInstall
  '';
  meta.platforms = [ "aarch64-darwin" ];
}
