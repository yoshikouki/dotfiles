{ stdenvNoCC, fetchurl }:
let
  darwin = stdenvNoCC.hostPlatform.isDarwin;
  platform = if darwin then "macos-arm64" else "linux-arm64-musl";
in
stdenvNoCC.mkDerivation rec {
  pname = "mise";
  version = "2026.10.22";
  src = fetchurl {
    url = "https://github.com/jdx/mise/releases/download/v${version}/mise-v${version}-${platform}.tar.xz";
    sha256 = if darwin then "d274eea4e08892137fd8e14c25593461ca2c89d7036fcafa0b2536ffb9902e1a" else "6dc2bd8b0518905d4b993d8f04cf4835412aac076bb34089d42fc3d4bfe5a28c";
  };
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -Dm755 bin/mise "$out/bin/mise"
    runHook postInstall
  '';
  meta.platforms = [ "aarch64-linux" "aarch64-darwin" ];
}
