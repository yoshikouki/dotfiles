{ config, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
  system.primaryUser = "yoshikouki";
  users.users.yoshikouki.home = "/Users/${config.system.primaryUser}";

  # Keep the existing Lix installer responsible for the daemon and nix.conf.
  nix.enable = false;

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
      "com.apple.swipescrolldirection" = true;
      "com.apple.mouse.tapBehavior" = 1;
      AppleShowAllExtensions = true;
    };
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
      TrackpadRightClick = true;
      TrackpadCornerSecondaryClick = 2;
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
