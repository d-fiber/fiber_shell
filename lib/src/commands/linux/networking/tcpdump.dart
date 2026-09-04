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

import '../../../builder.dart';

/// `tcpdump`, the libpcap packet capture tool. Present on Linux, macOS and
/// most Unixes; this wrapper documents the Linux flag set, which the macOS
/// build mostly shares since both link the same libpcap.
///
/// ```dart
/// await Tcpdump.interface('eth0').noResolve().writeFile('capture.pcap').count(100).asRoot().execute();
/// final ShellResult http = await Tcpdump.readFile('capture.pcap').asciiOutput().filter('port 80').output();
/// ```
///
/// [filter] is the trailing capture-filter expression (`port 80`, `host
/// 10.0.0.1 and tcp`) in `pcap-filter` syntax — its own small grammar that this
/// wrapper does not model, so it goes through verbatim as one bare argument.
/// [writeFile] wraps `-w`, not [PipeStage.writeTo]/[CommandBuilder.writeTo],
/// the runner that pipes a command's *stdout* to a file: `tcpdump -w` writes
/// raw pcap data as a capture, not something to layer a second file sink on
/// top of. Live capture needs `CAP_NET_RAW` — in practice root — on every
/// distribution; reading back a saved file with [readFile] does not.
class TcpdumpCmd extends CommandBuilder<TcpdumpCmd> {
  @override
  final String executable = 'tcpdump';

  /// Captures on this interface; `any` captures on every interface (`-i`, `--interface`).
  TcpdumpCmd interface(String name) => pair('--interface', name);

  /// Stops after this many packets (`-c`).
  TcpdumpCmd count(int packets) => pair('-c', '$packets');

  /// Captures this many bytes per packet instead of the full packet (`-s`, `--snapshot-length`).
  TcpdumpCmd snapshotLength(int bytes) => pair('--snapshot-length', '$bytes');

  /// Writes raw captured packets to this pcap file instead of printing them (`-w`).
  ///
  /// Wraps tcpdump's own `-w`, distinct from `CommandBuilder.writeTo`, which
  /// redirects a command's stdout — this writes libpcap's binary format, not
  /// the printed decode.
  TcpdumpCmd writeFile(String path) => pair('-w', path);

  /// Reads packets from this pcap file instead of capturing live (`-r`).
  TcpdumpCmd readFile(String path) => pair('-r', path);

  /// Reads the list of files to process, one per line, from this file (`-V`).
  TcpdumpCmd fileList(String path) => pair('-V', path);

  /// Skips resolving addresses to names (`-n`).
  TcpdumpCmd noResolve() => token('-n');

  /// Prints as little protocol detail as fits on one line (`-q`).
  TcpdumpCmd quiet() => token('-q');

  /// Adds one level of extra protocol detail (`-v`).
  TcpdumpCmd verbose() => token('-v');

  /// Adds two levels of extra detail (`-vv`).
  TcpdumpCmd veryVerbose() => token('-vv');

  /// Adds three levels of extra detail (`-vvv`).
  TcpdumpCmd extremelyVerbose() => token('-vvv');

  /// Omits the timestamp from each printed line (`-t`).
  TcpdumpCmd noTimestamp() => token('-t');

  /// Prints the timestamp as seconds since the epoch, with a fractional part (`-tt`).
  TcpdumpCmd timestampEpoch() => token('-tt');

  /// Prints the delta since the previous printed packet (`-ttt`).
  TcpdumpCmd timestampDelta() => token('-ttt');

  /// Prints the full date and time with a fractional part (`-tttt`).
  TcpdumpCmd timestampFull() => token('-tttt');

  /// Prints the delta since the first printed packet (`-ttttt`).
  TcpdumpCmd timestampDeltaFromFirst() => token('-ttttt');

  /// Prints the link-level header of each packet (MAC addresses, for Ethernet) (`-e`).
  TcpdumpCmd linkLevelHeader() => token('-e');

  /// Prints packet data in hex and ASCII, excluding the link-level header (`-X`).
  TcpdumpCmd hexAscii() => token('-X');

  /// Like [hexAscii], including the link-level header (`-XX`).
  TcpdumpCmd hexAsciiWithLink() => token('-XX');

  /// Prints packet data in hex only, excluding the link-level header (`-x`).
  TcpdumpCmd hex() => token('-x');

  /// Like [hex], including the link-level header (`-xx`).
  TcpdumpCmd hexWithLink() => token('-xx');

  /// Prints packet payload in ASCII, handy for skimming cleartext protocols (`-A`).
  TcpdumpCmd asciiOutput() => token('-A');

  /// Prefixes each line with a packet sequence number (`-#`, `--number`).
  TcpdumpCmd number() => token('--number');

  /// Prints the captured and original lengths of each packet (`--lengths`).
  TcpdumpCmd lengths() => token('--lengths');

  /// Suppresses the line break `-v` inserts after the IP header (`-g`, `--ip-oneline`).
  TcpdumpCmd ipOneline() => token('--ip-oneline');

  /// Lists the interfaces tcpdump can capture on, then exits (`-D`, `--list-interfaces`).
  TcpdumpCmd listInterfaces() => token('--list-interfaces');

  /// Reads the capture filter expression from this file instead of the command line (`-F`).
  TcpdumpCmd filterFile(String path) => pair('-F', path);

  /// Forces packets to be interpreted as this protocol type, e.g. `rpc`, `snmp`, `vxlan` (`-T`).
  TcpdumpCmd forceType(String type) => pair('-T', type);

  /// Dumps the compiled packet-matching code, human readable, then exits (`-d`).
  TcpdumpCmd dumpFilterCode() => token('-d');

  /// Dumps the matching code as a C array of BPF instructions (`-dd`).
  TcpdumpCmd dumpFilterCodeAsC() => token('-dd');

  /// Dumps the matching code as decimal numbers (`-ddd`).
  TcpdumpCmd dumpFilterCodeAsDecimal() => token('-ddd');

  /// Sets the link-layer type to assume, for [readFile] or filter compilation (`-y`, `--linktype`).
  TcpdumpCmd linkType(String type) => pair('--linktype', type);

  /// Lists the link-layer types the interface supports, then exits (`-L`, `--list-data-link-types`).
  TcpdumpCmd listLinkTypes() => token('--list-data-link-types');

  /// Skips verifying IP, TCP and UDP checksums (`-K`, `--dont-verify-checksums`).
  TcpdumpCmd dontVerifyChecksums() => token('--dont-verify-checksums');

  /// Prints absolute TCP sequence numbers instead of relative ones (`-S`, `--absolute-tcp-sequence-numbers`).
  TcpdumpCmd absoluteSequenceNumbers() => token('--absolute-tcp-sequence-numbers');

  /// Leaves the interface out of promiscuous mode (`-p`, `--no-promiscuous-mode`).
  TcpdumpCmd noPromiscuousMode() => token('--no-promiscuous-mode');

  /// Captures only this direction: `in`, `out` or `inout` (`-Q`, `--direction`).
  TcpdumpCmd direction(String value) => pair('--direction', value);

  /// Skips this many packets before processing starts (`--skip`).
  TcpdumpCmd skip(int packets) => joined('--skip', '$packets');

  /// Uses this secret to validate TCP-MD5 digests, RFC 2385 (`-M`).
  TcpdumpCmd tcpMd5Secret(String secret) => pair('-M', secret);

  /// Decrypts an IPsec ESP packet: `spi@ipaddr algo:secret` (`-E`).
  TcpdumpCmd espDecrypt(String spec) => pair('-E', spec);

  /// Prints undecoded NFS file handles (`-u`).
  TcpdumpCmd undecodedNfsHandles() => token('-u');

  /// Rotates the [writeFile] output when it reaches this size; a `k`/`m`/`g` suffix picks the unit (`-C`).
  TcpdumpCmd rotateSize(String size) => pair('-C', size);

  /// Rotates the [writeFile] output every this many seconds (`-G`).
  TcpdumpCmd rotateSeconds(int seconds) => pair('-G', '$seconds');

  /// Keeps only this many rotated files, cycling through them (`-W`).
  TcpdumpCmd rotateFileCount(int count) => pair('-W', '$count');

  /// Runs this command on each file as it is closed by rotation (`-z`).
  TcpdumpCmd postRotateCommand(String command) => pair('-z', command);

  /// Flushes stdout after every printed line, so `| tee` sees output live (`-l`).
  TcpdumpCmd lineBuffered() => token('-l');

  /// Writes each packet to [writeFile] as it is captured, rather than buffering (`-U`, `--packet-buffered`).
  TcpdumpCmd packetBuffered() => token('--packet-buffered');

  /// Prints the parsed decode even while [writeFile] is also saving raw packets (`--print`).
  TcpdumpCmd printAlongsideWrite() => token('--print');

  /// Prints only every Nth packet (`--print-sampling`).
  TcpdumpCmd printSampling(int nth) => joined('--print-sampling', '$nth');

  /// Sets the capture timestamp source, e.g. `host`, `adapter` (`-j`, `--time-stamp-type`).
  TcpdumpCmd timeStampType(String type) => pair('--time-stamp-type', type);

  /// Lists the timestamp types the interface supports, then exits (`-J`, `--list-time-stamp-types`).
  TcpdumpCmd listTimeStampTypes() => token('--list-time-stamp-types');

  /// Sets timestamp precision: `micro` or `nano` (`--time-stamp-precision`).
  TcpdumpCmd timeStampPrecision(String value) => joined('--time-stamp-precision', value);

  /// Shorthand for microsecond timestamp precision (`--micro`).
  TcpdumpCmd micro() => token('--micro');

  /// Shorthand for nanosecond timestamp precision (`--nano`).
  TcpdumpCmd nano() => token('--nano');

  /// Puts an 802.11 interface into monitor mode for the capture (`-I`, `--monitor-mode`).
  TcpdumpCmd monitorMode() => token('--monitor-mode');

  /// Attempts to detect 802.11s draft mesh headers (`-H`).
  TcpdumpCmd meshHeaders() => token('-H');

  /// Drops root privileges to this user once the capture device is open (`-Z`, `--relinquish-privileges`).
  TcpdumpCmd relinquishPrivileges(String user) => pair('--relinquish-privileges', user);

  /// Loads SMI MIB module definitions from this file, for SNMP decoding (`-m`).
  TcpdumpCmd mibModule(String path) => pair('-m', path);

  /// Sets the OS capture buffer size, in KiB (`-B`, `--buffer-size`).
  TcpdumpCmd bufferSize(int kib) => pair('--buffer-size', '$kib');

  /// Delivers packets to the decoder immediately instead of waiting for the buffer to fill (`--immediate-mode`).
  TcpdumpCmd immediateMode() => token('--immediate-mode');

  /// Prints BGP AS numbers in `asdot` notation, RFC 5396 (`-b`).
  TcpdumpCmd asdotNotation() => token('-b');

  /// Disables the packet-matching code optimizer (`-O`, `--no-optimize`).
  TcpdumpCmd noOptimize() => token('--no-optimize');

  /// Prints the usage summary and version, then exits (`-h`, `--help`).
  TcpdumpCmd help() => token('--help');

  /// Prints the version, then exits (`--version`).
  TcpdumpCmd version() => token('--version');

  /// The trailing capture filter expression, e.g. `port 80` or `host 10.0.0.1 and tcp` (`pcap-filter` syntax).
  ///
  /// This is its own small grammar, so it goes through as one bare argument
  /// rather than being modelled flag by flag; quote or pre-join multi-word
  /// expressions yourself.
  TcpdumpCmd filter(String expression) => token(expression);
}

/// `tcpdump`, ready to take its capture options and filter.
// ignore: non_constant_identifier_names
TcpdumpCmd get Tcpdump => TcpdumpCmd();
