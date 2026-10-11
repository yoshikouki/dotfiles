{ lib, ... }:
{
  # Reserve Ctrl+Space for Raycast. Use -dict-add to preserve every other shortcut;
  # declaring the entire AppleSymbolicHotKeys dictionary would replace them.
  home.activation.reserveRaycastHotkey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
      -dict-add 60 '<dict><key>enabled</key><false/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array></dict></dict>'
  '';
  # macOS Keyboard > Move focus to next window (symbolic hotkey 27).
  # Match Tab by virtual key 48 (65535 means no character); Option: mask 524288.
  # Update this entry only so plain Tab and unrelated shortcuts stay intact.
  home.activation.switchAppWindow = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
      -dict-add 27 '<dict><key>enabled</key><true/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>65535</integer><integer>48</integer><integer>524288</integer></array></dict></dict>'
    run /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
