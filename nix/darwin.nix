{ config, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.overlays = import ./overlays.nix ++ [
    (_final: prev: {
      # CoreText on macOS 27.2 shapes this malformed puzzle font like DirectWrite.
      # Keep the test enabled and check its observed output; runtime code is unchanged.
      harfbuzz = prev.harfbuzz.overrideAttrs (old: {
        postPatch = old.postPatch + ''
          substituteInPlace test/shape/data/in-house/tests/harfbust.tests \
            --replace-fail '@shapers=ot,coretext' '@shapers=ot' \
            --replace-fail '@shapers=harfrust,uniscribe,directwrite' '@shapers=harfrust,uniscribe,directwrite,coretext'
        '';
      });
    })
  ];
  system.stateVersion = 6;
  system.primaryUser = "yoshikouki";
  users.users.yoshikouki.home = "/Users/${config.system.primaryUser}";

  # Keep the existing Lix installer responsible for the daemon and nix.conf.
  nix.enable = false;

  # Block both trust paths for the compromised eMudhra intermediates.
  # https://emudhra.we-have-a-problem.com/
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
  ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Initial migration from bin/macos-defaults.sh.
  # Keep Spotlight shortcuts and existing Dock items until GUI setup is ready.
  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 1;
      InitialKeyRepeat = 15;
      "com.apple.keyboard.fnState" = true;
      "com.apple.trackpad.scaling" = 3.0;
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.swipescrolldirection" = true;
      "com.apple.mouse.tapBehavior" = 1;
      AppleShowAllExtensions = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick = true;
      # Use two-finger tap/click without assigning a corner gesture.
      TrackpadCornerSecondaryClick = 0;
    };
    dock = {
      autohide = true;
      tilesize = 42;
      show-recents = false;
    };
    finder = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf";
    };
    CustomUserPreferences = {
      NSGlobalDomain = {
        ContextMenuGesture = 1;
        "com.apple.mouse.scaling" = 5.0;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };
}
