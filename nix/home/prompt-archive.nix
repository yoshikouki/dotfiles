{ config, lib, ... }:
let
  home = config.home.homeDirectory;
  agentRepository = "${home}/src/github.com/yoshikouki/agent";
  archive = "${home}/.local/share/prompt-archive";
  stateDirectory = "${home}/.local/state/prompt-archive";
  mise = "${config.home.profileDirectory}/bin/mise";
  ssh = "/usr/bin/ssh -o BatchMode=yes";
  marker = "${archive}/mbp/.last-success";
  snapshot = "${stateDirectory}/last-success.sent";
  # Collect, then copy this host's archive to raspi even when a source failed:
  # what was read is still worth keeping. The success marker is copied aside
  # before the archive is sent and goes last, only after the archive arrived,
  # so raspi never holds a marker newer than the archive beside it.
  script = ''
    cd ${agentRepository}
    ${mise} exec -- bun --silent cli prompts collect --host mbp --archive ${archive}
    collected=$?
    rm -f ${snapshot}
    [ ! -e ${marker} ] || cp -p ${marker} ${snapshot}
    ${ssh} raspi 'mkdir -p -m 700 .local/share/prompt-archive' &&
      /usr/bin/rsync -a -e "${ssh}" --exclude '.last-success' --exclude '.lock*' ${archive}/mbp/ raspi:.local/share/prompt-archive/mbp/ &&
      { [ ! -e ${snapshot} ] ||
        /usr/bin/rsync -a -e "${ssh}" ${snapshot} raspi:.local/share/prompt-archive/mbp/.last-success; }
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
