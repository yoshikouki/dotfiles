[
  (_final: prev: {
    # Remove when the release channel includes the CVE-2026-111497 fix.
    brotli = prev.brotli.overrideAttrs (finalAttrs: _: {
      version = "1.2.1";
      src = prev.fetchFromGitHub {
        owner = "google";
        repo = "brotli";
        tag = "v${finalAttrs.version}";
        hash = "sha256-llY72cYffDv0ugsH0p89xIPEbElV4L8u7U/Fe8hT3gI=";
      };
    });
  })
]
