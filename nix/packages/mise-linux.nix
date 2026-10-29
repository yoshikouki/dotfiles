{ stdenvNoCC, fetchurl }:
stdenvNoCC.mkDerivation rec {
  pname = "mise";
  version = "2026.10.22";
  src = fetchurl {
    url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-linux-arm64-musl.tar.xz";
    sha256 = "6dc2bd8b0518905d4b993d8f04cf4835412aac076bb34089d42fc3d4bfe5a28c";
  };
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 bin/mise "$out/bin/mise"
    runHook postInstall
  '';
  meta.platforms = [ "aarch64-linux" ];
}
