{ lib, ... }:
{
  # Reserve Ctrl+Space for Raycast. Use -dict-add to preserve every other shortcut;
  # declaring the entire AppleSymbolicHotKeys dictionary would replace them.
  home.activation.reserveRaycastHotkey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys \
      -dict-add 60 '<dict><key>enabled</key><false/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array></dict></dict>'
  '';
}
