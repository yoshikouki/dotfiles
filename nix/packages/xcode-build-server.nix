{ lib, stdenvNoCC, fetchFromGitHub, python3, makeWrapper }:
stdenvNoCC.mkDerivation {
  pname = "xcode-build-server";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "SolaWing";
    repo = "xcode-build-server";
    rev = "438d0ae21778af955d7025d2013ebd419d161427";
    hash = "sha256-i8J/YvQK+u/H06t6u1JVWbAnQKVmh2j0oUIjxVBXcSM=";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/libexec/xcode-build-server" "$out/bin"
    cp -R . "$out/libexec/xcode-build-server/"
    makeWrapper ${python3}/bin/python3 "$out/bin/xcode-build-server" \
      --add-flags "$out/libexec/xcode-build-server/xcode-build-server"
    runHook postInstall
  '';
  meta = {
    description = "Build Server Protocol support for Xcode projects";
    homepage = "https://github.com/SolaWing/xcode-build-server";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "xcode-build-server";
  };
}
