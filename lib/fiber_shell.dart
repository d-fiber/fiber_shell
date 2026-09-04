// Copyright (C) 2026 Fiber
//
// This Source Code Form is subject to the terms of the Mozilla Public License,
// v. 2.0. If a copy of the MPL was not distributed with this file, You can
// obtain one at https://mozilla.org/MPL/2.0/.
//
// What you may do:
// - Use this software for any purpose, including commercially, and build and
//   sell your own products on top of it.
// - Change it, and create new works based on it.
// - Distribute copies of it, with or without your changes.
// - Combine it with files under any other licence, proprietary ones included,
//   and licence that larger work on your own terms.
//
// What you must do in return:
// - Keep this notice on every file you received it on.
// - Publish, under these same terms, the source of every file covered by them
//   that you distribute, including the ones you changed, so that whoever
//   receives your version can obtain that source.
// - Leave Fiber out of it: the name "Fiber", its branding, its logos and its
//   trademarks may not be used to endorse or promote what you build, and this
//   licence grants no right to them.
//
// Disclaimer:
// AS FAR AS THE LAW ALLOWS, THIS SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
// OR CONDITION OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
// NON-INFRINGEMENT. IN NO EVENT SHALL FIBER BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT
// LIMITED TO LOSS OF USE, DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT
// OF OR RELATED TO THESE TERMS OR THE USE OR NATURE OF THE SOFTWARE, UNDER ANY
// KIND OF LEGAL CLAIM.
//
// This header is a summary written for convenience. Where it differs from the
// LICENSE file, the LICENSE file governs.

library;

export 'src/builder.dart';
export 'src/commands/common/archives/tar.dart';
export 'src/commands/common/cloud/aws.dart';
export 'src/commands/common/cloud/az.dart';
export 'src/commands/common/cloud/gcloud.dart';
export 'src/commands/common/containers/docker_compose.dart';
export 'src/commands/common/containers/docker.dart';
export 'src/commands/common/containers/helm.dart';
export 'src/commands/common/containers/kubectl.dart';
export 'src/commands/common/databases/mysql.dart';
export 'src/commands/common/databases/pg_dump.dart';
export 'src/commands/common/databases/pg_restore.dart';
export 'src/commands/common/databases/psql.dart';
export 'src/commands/common/databases/redis.dart';
export 'src/commands/common/databases/sqlite3.dart';
export 'src/commands/common/env/direnv.dart';
export 'src/commands/common/infrastructure/ansible_playbook.dart';
export 'src/commands/common/infrastructure/packer.dart';
export 'src/commands/common/infrastructure/terraform.dart';
export 'src/commands/common/infrastructure/tofu.dart';
export 'src/commands/common/network/curl.dart';
export 'src/commands/common/network/jq.dart';
export 'src/commands/common/network/wget.dart';
export 'src/commands/common/network/yq.dart';
export 'src/commands/common/remote/scp.dart';
export 'src/commands/common/remote/ssh_keygen.dart';
export 'src/commands/common/remote/ssh.dart';
export 'src/commands/common/runtimes/bun.dart';
export 'src/commands/common/runtimes/deno.dart';
export 'src/commands/common/runtimes/go.dart';
export 'src/commands/common/runtimes/node.dart';
export 'src/commands/common/runtimes/npm.dart';
export 'src/commands/common/runtimes/pip.dart';
export 'src/commands/common/runtimes/python3.dart';
export 'src/commands/common/runtimes/ruby.dart';
export 'src/commands/common/security/age.dart';
export 'src/commands/common/security/gpg.dart';
export 'src/commands/common/security/openssl.dart';
export 'src/commands/common/security/vault.dart';
export 'src/commands/common/vcs/gh.dart';
export 'src/commands/common/vcs/git.dart';
export 'src/commands/linux/firewall/iptables.dart';
export 'src/commands/linux/firewall/ufw.dart';
export 'src/commands/linux/hardware/free.dart';
export 'src/commands/linux/hardware/lscpu.dart';
export 'src/commands/linux/hardware/nproc.dart';
export 'src/commands/linux/kernel/dmesg.dart';
export 'src/commands/linux/kernel/lsmod.dart';
export 'src/commands/linux/kernel/modprobe.dart';
export 'src/commands/linux/namespaces/chroot.dart';
export 'src/commands/linux/namespaces/nsenter.dart';
export 'src/commands/linux/namespaces/unshare.dart';
export 'src/commands/linux/networking/ethtool.dart';
export 'src/commands/linux/networking/ip.dart';
export 'src/commands/linux/networking/nmcli.dart';
export 'src/commands/linux/networking/ss.dart';
export 'src/commands/linux/networking/tcpdump.dart';
export 'src/commands/linux/networking/wg.dart';
export 'src/commands/linux/package_managers/apk.dart';
export 'src/commands/linux/package_managers/apt_get.dart';
export 'src/commands/linux/package_managers/dnf.dart';
export 'src/commands/linux/package_managers/pacman.dart';
export 'src/commands/linux/security/setenforce.dart';
export 'src/commands/linux/services/crontab.dart';
export 'src/commands/linux/services/journalctl.dart';
export 'src/commands/linux/services/loginctl.dart';
export 'src/commands/linux/services/systemctl.dart';
export 'src/commands/linux/services/timedatectl.dart';
export 'src/commands/linux/storage/blkid.dart';
export 'src/commands/linux/storage/fdisk.dart';
export 'src/commands/linux/storage/lsblk.dart';
export 'src/commands/linux/storage/mount.dart';
export 'src/commands/linux/system/groupadd.dart';
export 'src/commands/linux/system/secret_tool.dart';
export 'src/commands/linux/system/sysctl.dart';
export 'src/commands/linux/system/useradd.dart';
export 'src/commands/linux/system/usermod.dart';
export 'src/commands/macos/apps/open.dart';
export 'src/commands/macos/automation/osascript.dart';
export 'src/commands/macos/clipboard/pbcopy.dart';
export 'src/commands/macos/clipboard/pbpaste.dart';
export 'src/commands/macos/developer/qlmanage.dart';
export 'src/commands/macos/developer/xcode_select.dart';
export 'src/commands/macos/developer/xcrun.dart';
export 'src/commands/macos/media/say.dart';
export 'src/commands/macos/media/screencapture.dart';
export 'src/commands/macos/networking/networksetup.dart';
export 'src/commands/macos/networking/scutil.dart';
export 'src/commands/macos/package_managers/brew.dart';
export 'src/commands/macos/power/caffeinate.dart';
export 'src/commands/macos/power/pmset.dart';
export 'src/commands/macos/search/mdfind.dart';
export 'src/commands/macos/search/mdls.dart';
export 'src/commands/macos/security/codesign.dart';
export 'src/commands/macos/security/csrutil.dart';
export 'src/commands/macos/services/launchctl.dart';
export 'src/commands/macos/storage/diskutil.dart';
export 'src/commands/macos/storage/hdiutil.dart';
export 'src/commands/macos/storage/tmutil.dart';
export 'src/commands/macos/system/defaults.dart';
export 'src/commands/macos/system/dscl.dart';
export 'src/commands/macos/system/ioreg.dart';
export 'src/commands/macos/system/plutil.dart';
export 'src/commands/macos/system/profiles.dart';
export 'src/commands/macos/system/security.dart';
export 'src/commands/macos/system/softwareupdate.dart';
export 'src/commands/macos/system/spctl.dart';
export 'src/commands/macos/system/sw_vers.dart';
export 'src/commands/macos/system/sysctl.dart';
export 'src/commands/macos/system/system_profiler.dart';
export 'src/commands/unix/filesystem/basename.dart';
export 'src/commands/unix/filesystem/cp.dart';
export 'src/commands/unix/filesystem/dirname.dart';
export 'src/commands/unix/filesystem/du.dart';
export 'src/commands/unix/filesystem/find.dart';
export 'src/commands/unix/filesystem/install.dart';
export 'src/commands/unix/filesystem/ln.dart';
export 'src/commands/unix/filesystem/mkdir.dart';
export 'src/commands/unix/filesystem/readlink.dart';
export 'src/commands/unix/filesystem/rm.dart';
export 'src/commands/unix/filesystem/stat.dart';
export 'src/commands/unix/filesystem/touch.dart';
export 'src/commands/unix/network/nc.dart';
export 'src/commands/unix/permissions/chmod.dart';
export 'src/commands/unix/permissions/chown.dart';
export 'src/commands/unix/pipeline/tee.dart';
export 'src/commands/unix/pipeline/xargs.dart';
export 'src/commands/unix/process/kill.dart';
export 'src/commands/unix/process/lsof.dart';
export 'src/commands/unix/process/nohup.dart';
export 'src/commands/unix/process/ps.dart';
export 'src/commands/unix/process/top.dart';
export 'src/commands/unix/shell/bash.dart';
export 'src/commands/unix/shell/env.dart';
export 'src/commands/unix/shell/sh.dart';
export 'src/commands/unix/system/date.dart';
export 'src/commands/unix/system/df.dart';
export 'src/commands/unix/system/uptime.dart';
export 'src/commands/unix/text/awk.dart';
export 'src/commands/unix/text/cat.dart';
export 'src/commands/unix/text/diff.dart';
export 'src/commands/unix/text/grep.dart';
export 'src/commands/unix/text/head.dart';
export 'src/commands/unix/text/printf.dart';
export 'src/commands/unix/text/sed.dart';
export 'src/commands/unix/text/sort.dart';
export 'src/commands/unix/text/tail.dart';
export 'src/commands/unix/text/uniq.dart';
export 'src/commands/unix/text/wc.dart';
export 'src/commands/unix/transfer/rsync.dart';
export 'src/commands/windows/eventlog/wevtutil.dart';
export 'src/commands/windows/filesystem/attrib.dart';
export 'src/commands/windows/filesystem/robocopy.dart';
export 'src/commands/windows/filesystem/xcopy.dart';
export 'src/commands/windows/networking/ipconfig.dart';
export 'src/commands/windows/networking/netsh.dart';
export 'src/commands/windows/networking/netstat.dart';
export 'src/commands/windows/package_managers/scoop.dart';
export 'src/commands/windows/package_managers/winget.dart';
export 'src/commands/windows/permissions/icacls.dart';
export 'src/commands/windows/permissions/takeown.dart';
export 'src/commands/windows/policy/gpresult.dart';
export 'src/commands/windows/policy/gpupdate.dart';
export 'src/commands/windows/power/shutdown.dart';
export 'src/commands/windows/process/taskkill.dart';
export 'src/commands/windows/process/tasklist.dart';
export 'src/commands/windows/registry/reg.dart';
export 'src/commands/windows/security/certutil.dart';
export 'src/commands/windows/services/sc.dart';
export 'src/commands/windows/services/schtasks.dart';
export 'src/commands/windows/shell/cmd.dart';
export 'src/commands/windows/shell/powershell.dart';
export 'src/commands/windows/storage/chkdsk.dart';
export 'src/commands/windows/storage/diskpart.dart';
export 'src/commands/windows/storage/fsutil.dart';
export 'src/commands/windows/system/bcdedit.dart';
export 'src/commands/windows/system/dism.dart';
export 'src/commands/windows/system/driverquery.dart';
export 'src/commands/windows/system/sfc.dart';
export 'src/commands/windows/system/systeminfo.dart';
export 'src/commands/windows/system/whoami.dart';
export 'src/commands/windows/system/wusa.dart';
export 'src/exception.dart';
export 'src/process.dart';
export 'src/result.dart';
export 'src/script.dart';
