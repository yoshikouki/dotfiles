{ config, lib, ... }:
let
  home = config.home.homeDirectory;
  agentRepository = "${home}/src/github.com/yoshikouki/agent";
  archive = "${home}/.local/share/prompt-archive";
  stateDirectory = "${home}/.local/state/prompt-archive";
  mise = "${config.home.profileDirectory}/bin/mise";
  ssh = "/usr/bin/ssh -o BatchMode=yes";
  # Collect, then copy this host's archive to raspi even when a source failed:
  # what was read is still worth keeping. The success marker goes last and
  # only after the archive itself arrived, so its age on raspi is the alert.
  script = ''
    cd ${agentRepository}
    ${mise} exec -- bun --silent cli prompts collect --host mbp --archive ${archive}
    collected=$?
    ${ssh} raspi 'mkdir -p -m 700 .local/share/prompt-archive' &&
      /usr/bin/rsync -a -e "${ssh}" --exclude .last-success ${archive}/mbp/ raspi:.local/share/prompt-archive/mbp/ &&
      { [ ! -e ${archive}/mbp/.last-success ] ||
        /usr/bin/rsync -a -e "${ssh}" ${archive}/mbp/.last-success raspi:.local/share/prompt-archive/mbp/; }
    synced=$?
    [ "$collected" -eq 0 ] && [ "$synced" -eq 0 ]
  '';
in
{
  launchd.agents.prompt-archive = {
    enable = true;
    config = {
      ProgramArguments = [ "/bin/zsh" "-c" script ];
      # launchd runs a missed calendar job once when the Mac wakes up.
      StartCalendarInterval = [{ Hour = 12; Minute = 30; }];
      StandardOutPath = "${stateDirectory}/stdout.log";
      StandardErrorPath = "${stateDirectory}/stderr.log";
      ProcessType = "Background";
    };
  };
  home.activation.promptArchiveDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p -m 700 ${archive} ${stateDirectory}
  '';
}
