# Dotfiles Project Instructions

## Local Bin Scripts

When creating or modifying scripts in `local-bin/`:
1. Create or edit the script in `/Users/yoshikouki/dotfiles/local-bin/`
2. Set executable permissions with `chmod +x`
3. **MUST** create a symbolic link in `~/.local/bin/` pointing to the script
   - Example: `ln -s /Users/yoshikouki/dotfiles/local-bin/scriptname ~/.local/bin/scriptname`
4. Verify the symbolic link was created successfully

This ensures scripts are immediately available in the PATH without manual setup.
