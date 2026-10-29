install:
	@case "$$(uname -s)" in Darwin) bin/install.mac.sh ;; Linux) bin/install.linux.sh ;; *) exit 1 ;; esac

applications:
	@bin/install_applications.sh

macos:
	@bin/macos-defaults.sh
