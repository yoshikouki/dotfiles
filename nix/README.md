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

## TLS trust stores

`darwin.nix` excludes the Comodo AAA Services and emSign ECC G3 roots to block
the compromised eMudhra intermediate chains. Nix manages
`/etc/ssl/certs/ca-certificates.crt`; macOS's separate `/etc/ssl/cert.pem` and
runtime-bundled roots require their own verification and updates. Back up the
macOS file before changing it, and recheck it after OS updates.
Home Manager sets `SSL_CERT_FILE` to the Nix bundle so OpenSSL clients such as
mise Python have current replacement trust paths when old roots are removed.
Open a fresh terminal after activation to load this environment setting.

`home/packages.nix` temporarily pins the CLI curl to the official 8.23.0 source
archive because the pinned release channel still has vulnerable 8.22.0.
Remove the override when the release channel includes 8.23.0 or later. This
updates the user's curl command, not libcurl dependencies in other packages.
The mise lock records the Node.js 24.22.1 LTS and Go 1.27.3 security updates;
existing processes must restart and existing Go programs must be rebuilt.

`darwin.nix` overrides Brotli throughout the package set to the official 1.2.1
release to fix CVE-2026-111497. It retains the upstream Nix build recipe, patches
and tests. Dependencies are rebuilt normally; this does not rewrite installed
binaries. Remove the overlay when the release channel includes a fixed Brotli.
The rebuild includes libraries and build tools, so it can be substantial.
The installer-managed Nix/Lix executable (`nix.enable = false`) and application
bundles have separate dependencies and update paths.
The flake's `lix` package builds the pinned official Lix release with the same
fixed Brotli. It does not transfer daemon management to nix-darwin.
Keep the previous system generation until the new commands and decoder paths
have been verified. `darwin-rebuild --switch-generation <number>` can reactivate
a retained generation without rebuilding it.

On macOS 27.2, CoreText shapes the intentionally malformed HarfBust puzzle font
like DirectWrite. This differs from the HarfBuzz test's expected output even
with the existing cached package. The overlay changes only that test's shaper
group so it checks the observed output; it does not change HarfBuzz runtime code
or disable tests. Remove this adjustment when upstream accounts for the
CoreText behavior. See [the upstream puzzle discussion](https://github.com/harfbuzz/harfbuzz/issues/5535).

Build and verify the standalone Lix package before upgrading its existing root
profile. On this Mac, the installer's default profile points to the root profile:

```sh
nix build '.#lix' --out-link result-lix
sudo "$(realpath result-lix)/bin/nix" --store local upgrade-nix \
  --profile /nix/var/nix/profiles/per-user/root/profile \
  --store-path "$(realpath result-lix)"
sudo launchctl kickstart -k system/org.nixos.nix-daemon
nix --version
nix store ping --json
```

Wait for active builds to finish before restarting the daemon. Keep the previous
root profile generation for recovery, and verify both the CLI and daemon after
the upgrade. Use the upstream binary upgrade again only after checking that its
Brotli dependency includes the fix.

The mise configuration selects Bun
1.4, with 1.4.4 locked for macOS and Linux; restart Bun services after updating.

Verify both Nix and `/usr/bin/curl` with all test chains listed at
<https://emudhra.we-have-a-problem.com/> and a normal HTTPS site. Expect a
certificate error (curl exit 60), not DNS failure or timeout. Test the default
configuration after activation as well as explicit CA bundles before it.
