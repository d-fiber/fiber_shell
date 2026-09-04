# Changelog

## 1.4.0

- Fifty more wrappers, ten per platform group:
  - `common/`: `Age` (`age`), `Aws` (`aws`), `Az` (`az`), `Gcloud` (`gcloud`),
    `Go` (`go`), `Packer` (`packer`), `Redis` (`redis-cli`), `Ruby` (`ruby`),
    `Sqlite3` (`sqlite3`), `Vault` (`vault`) — `cloud/` is a new family.
  - `unix/`: `Basename`, `Date`, `Dirname`, `Env`, `Nc`, `Nohup`, `Printf`,
    `Readlink`, `Stat`, `Top` — `network/` is a new family, `date` joins
    `system/`.
  - `linux/`: `Blkid`, `Chroot`, `Ethtool`, `Fdisk`, `Loginctl`, `Nsenter`,
    `Setenforce`, `Tcpdump`, `Timedatectl`, `Unshare` — `namespaces/` and
    `security/` are new families.
  - `macos/`: `Csrutil`, `Hdiutil`, `Ioreg`, `Pbcopy`, `Pbpaste`, `Profiles`,
    `Qlmanage`, `Say`, `Screencapture`, `SwVers` — `clipboard/` and `media/`
    are new families.
  - `windows/`: `Bcdedit`, `Chkdsk`, `Diskpart`, `Dism`, `Fsutil`, `Gpresult`,
    `Gpupdate`, `Sfc`, `Takeown`, `Wusa` — `storage/` and `policy/` are new
    families.
- As before, every option was sourced from a man page, `--help` output, or
  official docs rather than guessed at. `Dism`, `Ethtool`, `Aws`, `Gcloud`,
  `Az` and `Vault` in particular carry a generic escape-hatch method
  alongside their dedicated ones, for the tail of subcommand-specific flags
  too deep to enumerate exhaustively — the same pattern `Certutil` already
  used in 1.2.0.

## 1.3.1

- No changes.

## 1.2.0

- Fifty new wrappers, ten per platform group:
  - `common/`: `AnsiblePlaybook` (`ansible-playbook`), `Gpg` (`gpg`), `Helm`
    (`helm`), `Kubectl` (`kubectl`), `Mysql` (`mysql`), `Node` (`node`), `Pip`
    (`pip3`), `Terraform` (`terraform`), `Wget` (`wget`), `Yq` (`yq`).
  - `unix/`: `Cat`, `Df`, `Diff`, `Head`, `Sort`, `Tail`, `Touch`, `Uniq`,
    `Uptime`, `Wc` — `df` and `uptime` open a new `system/` family.
  - `linux/`: `Crontab`, `Dmesg`, `Free`, `Groupadd`, `Lsblk`, `Lsmod`,
    `Modprobe`, `Mount`, `Nmcli`, `Useradd` — `storage/` (`lsblk`, `mount`)
    and `kernel/` (`dmesg`, `lsmod`, `modprobe`) are new families.
  - `macos/`: `Codesign`, `Mdfind`, `Mdls`, `Open`, `Osascript`, `Spctl`,
    `SystemProfiler`, `Tmutil`, `XcodeSelect`, `Xcrun` — `search/`
    (`mdfind`, `mdls`), `apps/` (`open`), `automation/` (`osascript`),
    `developer/` (`xcode-select`, `xcrun`) and a `security/` family
    (`codesign`, distinct from `common/security/`) are new.
  - `windows/`: `Attrib`, `Certutil`, `Driverquery`, `Ipconfig`, `Netstat`,
    `Shutdown`, `Systeminfo`, `Whoami`, `Wevtutil`, `Xcopy` — `system/`
    (`systeminfo`, `whoami`, `driverquery`), `power/` (`shutdown`),
    `security/` (`certutil`) and `eventlog/` (`wevtutil`) are new families.
- As with 1.1.0, the barrel is the only public surface and every new wrapper
  follows the same shape: one method per documented option, verified against
  the tool's own manual rather than guessed at.

## 1.1.0

- Licensed under the Mozilla Public License 2.0, replacing the all-rights-reserved
  header every file carried in 1.0.0.
- Thirteen new wrappers, one per tool: `Gh` (`gh`), `Bun` (`bun`) and `Tofu`
  (`tofu`) in `common/`; `Rsync` (`rsync`) in `unix/`; `Nproc` (`nproc`),
  `Lscpu` (`lscpu`), `Dnf` (`dnf`), `Pacman` (`pacman`) and `Apk` (`apk`) in
  `linux/`; `DarwinSysctl` (`sysctl`) and `Brew` (`brew`) in `macos/`;
  `Winget` (`winget`) and `Scoop` (`scoop`) in `windows/`. `DarwinSysctl` is a
  separate wrapper from `Sysctl`: the same command name, but a different
  program with a different flag grammar on macOS than on Linux.
- `lib/src/commands/` is now grouped in two levels, platform then family
  (`linux/package_managers/dnf.dart`, `unix/text/grep.dart`, and so on),
  rather than one flat directory per platform. The barrel is the only public
  surface and its exports are unchanged, so this does not affect a caller
  that only ever does `import 'package:fiber_shell/fiber_shell.dart';`.

## 1.0.0

First release.

### Core

- `CommandBuilder<T>`, the base every wrapper extends. One method is one option,
  and each option returns the concrete wrapper, so a chain stays typed to the
  end. Four helpers cover the argument shapes tools use: `token`, `pair`,
  `joined` and `joinedAll`.
- Four ways to run a command: `execute()` with stdio inherited, `output()` which
  captures both streams and never throws, `writeTo(File)` for stdout into a
  file, and `background()` for a job you keep a handle on.
- `ShellResult`, returned by `output()`: `exitCode`, `success`, `failed`,
  `text`, `lines`, `error`, `bytes`, `duration`, `textOrNull` and `orThrow()`.
  Output is kept undecoded, so the same type carries text and binary alike.
- `ShellException`, thrown by the runners that treat a non-zero status as fatal.
- Pipes through the `|` operator. Every stage starts at once and each stdout is
  wired into the next stdin through Dart streams. The status follows
  `set -o pipefail`: the rightmost stage that failed, or zero when they all
  succeeded.
- Chaining through `and()`, `or()` and `then()`, standing in for `&&`, `||` and
  `;`. Dart cannot overload the first two, so they are named rather than guessed
  at.
- `asRoot()`, which marks the command rather than the run, so elevation survives
  being piped or chained. It adds `sudo` on Linux and leaves the command
  untouched elsewhere.
- `line`, which renders a command, a pipeline or a whole chain as a terminal
  would show it, without running it.
- `BackgroundJob` with `pid`, `wait()` and `kill([signal])`.
- Helpers for the tools that may not be installed: `commandExists(name)` and
  `waitUntil(cmd, interval:, timeout:)`.
- Lower-level entry points for callers that already hold an argv: `sh`,
  `capture`, `captureWithStdin`, `shToFile`, `captureResult`, `commandLine`,
  `commandArgv` and `privileged`.

Every runner takes `cwd` and `env`; `output()` also takes `input` for stdin.
Nothing is ever interpolated into a string, so there is nothing to escape.

### Commands: cross-platform

| Facade | Tool |
|--------|------|
| `Curl` | `curl` |
| `Deno` | `deno` |
| `Direnv` | `direnv` |
| `Docker` | `docker` |
| `DockerCompose` | `docker compose` |
| `Git` | `git` |
| `Jq` | `jq` |
| `Npm` | `npm` |
| `OpenSSL` | `openssl` |
| `PgDump` | `pg_dump` |
| `PgRestore` | `pg_restore` |
| `Psql` | `psql` |
| `Python3` | `python3` |
| `Scp` | `scp` |
| `Ssh` | `ssh` |
| `SshKeygen` | `ssh-keygen` |
| `Tar` | `tar` |

### Commands: Unix

Present on macOS and Linux, and on Windows only through a POSIX layer.

| Facade | Tool |
|--------|------|
| `Awk` | `awk` |
| `Bash` | `bash` |
| `Chmod` | `chmod` |
| `Chown` | `chown` |
| `Cp` | `cp` |
| `Du` | `du` |
| `Find` | `find` |
| `Grep` | `grep` |
| `Install` | `install` |
| `Kill` | `kill` |
| `Ln` | `ln` |
| `Lsof` | `lsof` |
| `Mkdir` | `mkdir` |
| `Ps` | `ps` |
| `Rm` | `rm` |
| `Sed` | `sed` |
| `Sh` | `sh` |
| `Tee` | `tee` |
| `Xargs` | `xargs` |

### Commands: Linux

| Facade | Tool |
|--------|------|
| `AptGet` | `apt-get` |
| `Ip` | `ip` |
| `Iptables` | `iptables` |
| `Journalctl` | `journalctl` |
| `SecretTool` | `secret-tool` |
| `Ss` | `ss` |
| `Sysctl` | `sysctl` |
| `Systemctl` | `systemctl` |
| `Ufw` | `ufw` |
| `Usermod` | `usermod` |
| `Wg` | `wg` |

### Commands: macOS

| Facade | Tool |
|--------|------|
| `Caffeinate` | `caffeinate` |
| `Defaults` | `defaults` |
| `Diskutil` | `diskutil` |
| `Dscl` | `dscl` |
| `Launchctl` | `launchctl` |
| `Networksetup` | `networksetup` |
| `Plutil` | `plutil` |
| `Pmset` | `pmset` |
| `Scutil` | `scutil` |
| `Security` | `security` |
| `Softwareupdate` | `softwareupdate` |

### Commands: Windows

| Facade | Tool |
|--------|------|
| `Cmd` | `cmd.exe` |
| `Icacls` | `icacls` |
| `Netsh` | `netsh` |
| `PowerShell` | `powershell` |
| `Reg` | `reg.exe` |
| `Robocopy` | `robocopy` |
| `Sc` | `sc.exe` |
| `Schtasks` | `schtasks` |
| `Taskkill` | `taskkill` |
| `Tasklist` | `tasklist` |

Every wrapper documents the tool it covers: which platforms have it, which of
its options bite in automation, and the traps worth knowing about before
reaching for a flag.

### Docs and tests

- `example/` holds a runnable tour in eight chapters, from a first command to
  writing your own wrapper.
- The test suite covers the builders, `ShellResult`, the runners, pipelines,
  chaining and background jobs, plus a structural pass that guards the barrel
  exports and the wrapper contract.
