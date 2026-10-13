# macOS settings with nix-darwin

This configuration migrates keyboard, trackpad, Dock and Finder preferences from
`bin/macos-defaults.sh`. The old script remains available for the legacy setup;
do not run it alongside this configuration. Spotlight shortcuts and Dock items
are preserved in this first migration.

The existing Lix installation manages the daemon and `/etc/nix/nix.conf`
(`nix.enable = false`). Home Manager manages common CLI packages, Git, shell files and local scripts.
The mise executable and global configuration links are managed by Home Manager;
language runtimes remain managed by mise. GUI apps are not managed yet.

From the repository root, build without applying:

```sh
nix build "path:$PWD#darwinConfigurations.mbp.system" --out-link /tmp/macbook-darwin-result
```

Apply the built configuration:

```sh
sudo /tmp/macbook-darwin-result/sw/bin/darwin-rebuild switch --flake "path:$PWD#mbp"
```

The explicit `path:` reference includes new files before they are tracked by Git.
After the initial switch, `darwin-rebuild` is available in a new login shell.
Some preferences require logout/login. Caps Lock mapping is applied during
activation; reconnecting a keyboard may require reapplying the configuration.

Update locked dependencies deliberately with `nix flake update "path:$PWD"`,
then build and apply again. `system.stateVersion` is a compatibility setting,
not the package release version; leave it at its initial value.

If the initial activation reports an existing `/etc` file conflict, inspect
that file and the diagnostic before changing anything; do not delete it blindly.


## User environment

- `home/packages.nix`: common CLI tools, MySQL 8.4, PostgreSQL 17 and Apple
  development tools. Installing DB packages does not enable DB services.
- `packages/xcode-build-server.nix`: upstream source pinned by commit and hash,
  using its own Nix Python interpreter.
- `home/git.nix`: shared Git settings; ghq repositories live in `~/src`.
- `home/zsh.nix`: existing zsh functions and bindings, with Nix plugin paths and
  a Nix-based `pkg-update` function. Shell files are generated snapshots; edit
  the repository and rebuild, rather than editing files in the home directory.
- `home/default.nix`: shared files, local CLI wrappers and configuration links.

Machine-specific `~/.config/git/local.gitconfig` is created once from the macOS
source template and remains editable. Local zsh overrides and authentication
files are not imported into the flake.

This first step retains the legacy root Git and zsh files for the old bootstrap
and Linux setup. Git configuration for this Mac now lives in `home/git.nix`, generating
`~/.config/git/config` (Git reads this standard XDG path automatically).
Neovim and Yazi configuration directories link to the editable checkout.
Lazy.nvim manages Neovim plugins using `nvim/lazy-lock.json`; Yazi plugins are
recorded in `yazi/package.toml`. Run `ya pkg install` after the first switch to
install the recorded Yazi plugins. Plugin downloads remain outside the Nix store.
Mise config and lockfile links point to the editable `mise/` directory in the
checkout. This is intentional: mise writes its lockfile during installs and
upgrades, so it cannot be a read-only Nix-store snapshot. Changes are reviewed
with `git diff -- mise` and preserved in the repository. Keep the checkout at
its configured ghq location.

Install the recorded runtimes and service CLIs with `mise install --locked`.
Google Workspace CLI (`gws`), summarize and Playwright CLI (`playwright-cli`)
use mise's npm backend with explicit versions because the pinned Nixpkgs release
does not package them. Their transitive npm dependencies are resolved by npm;
the mise lockfile does not pin that dependency graph. These tools require no
Homebrew installation. Authentication remains machine-local.
The existing `local-bin/gh` wrapper selects GitHub credentials by repository;
its default personal-account configuration directory is `~/.config/gh-yoshikouki`.

After applying, open a new shell. Confirm `ghq root` returns `~/src`, and run
`gh auth login` when ready to authenticate. The earlier ad-hoc user-profile
installs of gh and ghq may then be removed once Home Manager supplies both.
Use `pkg-update` for Nix updates. Use `mise upgrade` separately for language
runtimes; do not run `mise self-update` on the Nix-managed executable.

The legacy `.Brewfile` and bootstrap scripts remain for the Homebrew/Linux path.
On this Mac, package declarations belong in Nix or mise; do not run the legacy
bootstrap alongside Home Manager. The shared zsh files select package-manager
behavior using `DOTFILES_PACKAGE_MANAGER`, supplied by Home Manager, rather than
rewriting shell code during Nix evaluation. GUI casks, Xcode itself and the
optional GUI installation script remain outside this migration.
