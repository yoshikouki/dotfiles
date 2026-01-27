# Dotfiles Project Instructions

## Supported Operating Systems

This dotfiles project supports **macOS** and **Ubuntu**. When writing scripts or configurations:
- Use conditional checks to handle OS-specific paths and commands
- Avoid hardcoding OS-specific paths without fallbacks
- Test compatibility on both platforms when possible

## Package Management

This project uses **Homebrew** and **mise** for package management:
- **Homebrew**: CLI tools and GUI applications (both macOS and Linux via Linuxbrew)
- **mise**: Runtime version management (Node.js, Python, Ruby, Go, Rust, Bun)

### Adding CLI tools
Add to `.Brewfile` and run:
```bash
brew bundle --global
```

### Adding runtimes
Edit `.mise.toml` to specify versions, then run:
```bash
mise install
```

### Update all packages
```bash
pkg-update  # alias for: brew update && brew upgrade && mise upgrade
```

## Local Bin Scripts

When creating or modifying scripts in `local-bin/`:
1. Create or edit the script in `~/dotfiles/local-bin/`
2. Set executable permissions with `chmod +x`
3. **MUST** create a symbolic link in `~/.local/bin/` pointing to the script
   - Example: `ln -s ~/dotfiles/local-bin/scriptname ~/.local/bin/scriptname`
4. Verify the symbolic link was created successfully

This ensures scripts are immediately available in the PATH without manual setup.
