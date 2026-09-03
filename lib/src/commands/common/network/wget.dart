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

/// `wget`, the non-interactive network fetcher. GNU wget on Linux and through
/// Homebrew on macOS; not shipped with either macOS or Windows, so
/// `commandExists` first. Where [Curl] streams and composes with pipes, wget's
/// whole reason to exist is the other half of the job: retrying a flaky
/// transfer, mirroring a site to disk, and resuming where a previous run left
/// off.
///
/// ```dart
/// await Wget.quiet().tries('3').timeout('30').outputDocument('build.tar.gz').url(archiveUrl).execute();
/// ```
///
/// Three habits matter for automation. [tries] plus [timeout] is what keeps a
/// flaky network from hanging a build forever; wget alone will retry
/// indefinitely by default. [noClobber] and [continueDownload] answer two
/// different questions, "skip it" versus "resume it", and combining them is an
/// error wget itself refuses. And [mirror] is shorthand for a specific bundle of
/// recursive flags, not a single knob: read what it expands to before reaching
/// for it against a site you do not control.
class WgetCmd extends CommandBuilder<WgetCmd> {
  @override
  final String executable = 'wget';

  /// Prints the version and exits (`-V`).
  WgetCmd version() => token('-V');

  /// Prints the usage summary (`-h`).
  WgetCmd help() => token('-h');

  /// Goes to the background right after startup (`-b`).
  ///
  /// Named around [PipeStage.background], the base class's own async job runner.
  WgetCmd backgroundFlag() => token('-b');

  /// Runs a `.wgetrc` command inline, before anything else is parsed (`-e`).
  WgetCmd executeCommand(String command) => pair('-e', command);

  /// Logs every message to this file instead of stderr (`-o`).
  WgetCmd outputFile(String logfile) => pair('-o', logfile);

  /// Appends to the log file instead of overwriting it (`-a`).
  WgetCmd appendOutput(String logfile) => pair('-a', logfile);

  /// Turns on developer debug output (`-d`). Requires a debug build.
  WgetCmd debugFlag() => token('-d');

  /// Silences everything (`-q`).
  WgetCmd quiet() => token('-q');

  /// Turns on verbose output, the default (`-v`).
  WgetCmd verbose() => token('-v');

  /// Turns off verbose without going fully quiet (`-nv`).
  WgetCmd noVerbose() => token('-nv');

  /// Chooses how bandwidth is reported: `bits` or `bytes` (`--report-speed`).
  WgetCmd reportSpeed(String type) => pair('--report-speed', type);

  /// Reads URLs from this file instead of the command line (`-i`).
  WgetCmd inputFile(String file) => pair('-i', file);

  /// Treats the [inputFile] as HTML and pulls its links (`-F`).
  WgetCmd forceHtml() => token('-F');

  /// The base URL relative links in [inputFile] are resolved against (`-B`).
  WgetCmd base(String url) => pair('-B', url);

  /// Reads startup options from this file instead of `.wgetrc` (`--config`).
  WgetCmd config(String file) => pair('--config', file);

  /// Logs every rejected URL, and why, to this file (`--rejected-log`).
  WgetCmd rejectedLog(String logfile) => pair('--rejected-log', logfile);

  /// The local address to bind outgoing connections to (`--bind-address`).
  WgetCmd bindAddress(String address) => pair('--bind-address', address);

  /// The local address DNS requests go out from (`--bind-dns-address`).
  WgetCmd bindDnsAddress(String address) => pair('--bind-dns-address', address);

  /// The nameservers to ask instead of the system resolver (`--dns-servers`).
  WgetCmd dnsServers(String addresses) => pair('--dns-servers', addresses);

  /// How many times to retry a failed fetch, `0` for unlimited (`-t`).
  ///
  /// Without a cap wget retries forever, which is rarely what a script wants; pair with [timeout].
  WgetCmd tries(String number) => pair('-t', number);

  /// Writes everything to this single file instead of one per URL (`-O`).
  WgetCmd outputDocument(String file) => pair('-O', file);

  /// Refuses to overwrite an existing file (`-nc`). Not combinable with [continueDownload].
  WgetCmd noClobber() => token('-nc');

  /// Backs up an existing file before overwriting it, keeping this many numbered copies (`--backups`).
  WgetCmd backups(String count) => pair('--backups', count);

  /// Ignores `.netrc` for credentials (`--no-netrc`).
  WgetCmd noNetrc() => token('--no-netrc');

  /// Resumes a partially-downloaded file rather than restarting it (`-c`).
  ///
  /// Named around the Dart keyword `continue`. Errors out if combined with [noClobber].
  WgetCmd continueDownload() => token('-c');

  /// Starts the download at this byte offset (`--start-pos`).
  WgetCmd startPos(String offset) => pair('--start-pos', offset);

  /// The progress indicator style: `dot` or `bar` (`--progress`).
  WgetCmd progress(String type) => pair('--progress', type);

  /// Forces the progress bar even when output is not a terminal (`--show-progress`).
  WgetCmd showProgress() => token('--show-progress');

  /// Skips a file whose remote timestamp is no newer than the local copy (`-N`).
  WgetCmd timestamping() => token('-N');

  /// Prints the HTTP or FTP server's response headers (`-S`).
  WgetCmd serverResponse() => token('-S');

  /// Checks a URL exists without downloading it (`--spider`).
  WgetCmd spider() => token('--spider');

  /// The network timeout, applied to DNS, connect and read alike unless overridden (`-T`).
  WgetCmd timeout(String seconds) => pair('-T', seconds);

  /// The DNS lookup timeout alone (`--dns-timeout`).
  WgetCmd dnsTimeout(String seconds) => pair('--dns-timeout', seconds);

  /// The TCP connect timeout alone (`--connect-timeout`).
  WgetCmd connectTimeout(String seconds) => pair('--connect-timeout', seconds);

  /// The idle-between-reads timeout alone (`--read-timeout`).
  WgetCmd readTimeout(String seconds) => pair('--read-timeout', seconds);

  /// Caps the transfer rate, `20k` or `1m` style (`--limit-rate`).
  WgetCmd limitRate(String amount) => pair('--limit-rate', amount);

  /// Pauses this long between retrievals (`-w`).
  WgetCmd wait(String seconds) => pair('-w', seconds);

  /// Waits only between retries, not between ordinary retrievals (`--waitretry`).
  WgetCmd waitretry(String seconds) => pair('--waitretry', seconds);

  /// Randomises [wait] between 0.5x and 1.5x itself (`--random-wait`).
  WgetCmd randomWait() => token('--random-wait');

  /// Ignores any configured proxy (`--no-proxy`).
  WgetCmd noProxy() => token('--no-proxy');

  /// Stops after downloading this much in total, `5m` style (`-Q`).
  WgetCmd quota(String quota) => pair('-Q', quota);

  /// Turns off DNS caching, so every request re-resolves the host (`--no-dns-cache`).
  WgetCmd noDnsCache() => token('--no-dns-cache');

  /// How aggressively to escape local filenames: `unix` or `windows` (`--restrict-file-names`).
  WgetCmd restrictFileNames(String modes) => pair('--restrict-file-names', modes);

  /// Connects to IPv4 addresses only (`-4`).
  WgetCmd inet4Only() => token('-4');

  /// Connects to IPv6 addresses only (`-6`).
  WgetCmd inet6Only() => token('-6');

  /// Which address family to prefer when both are available (`--prefer-family`).
  WgetCmd preferFamily(String family) => pair('--prefer-family', family);

  /// Treats a refused connection as a transient, retryable error (`--retry-connrefused`).
  ///
  /// What you want while polling for a service that has not come up yet.
  WgetCmd retryConnrefused() => token('--retry-connrefused');

  /// The FTP or HTTP username (`--user`).
  WgetCmd user(String value) => pair('--user', value);

  /// The FTP or HTTP password (`--password`).
  ///
  /// Lands in argv, where `ps` can see it; prefer a `.netrc` or [askPassword] for anything sensitive.
  WgetCmd password(String value) => pair('--password', value);

  /// Prompts for the password interactively instead of taking it on the command line (`--ask-password`).
  WgetCmd askPassword() => token('--ask-password');

  /// Runs this command to obtain a password instead of prompting (`--use-askpass`).
  WgetCmd useAskpass(String command) => pair('--use-askpass', command);

  /// Turns off IRI (internationalised URL) support (`--no-iri`).
  WgetCmd noIri() => token('--no-iri');

  /// The encoding local filenames are written in (`--local-encoding`).
  WgetCmd localEncoding(String encoding) => pair('--local-encoding', encoding);

  /// The encoding the remote server's filenames are assumed to be in (`--remote-encoding`).
  WgetCmd remoteEncoding(String encoding) => pair('--remote-encoding', encoding);

  /// Unlinks a file before writing to it rather than truncating it in place (`--unlink`).
  ///
  /// The safe choice for a file another process might still hold open.
  WgetCmd unlink() => token('--unlink');

  /// Saves every file flat, with no directory hierarchy (`-nd`).
  WgetCmd noDirectories() => token('-nd');

  /// Creates the directory hierarchy even for a single file (`-x`).
  WgetCmd forceDirectories() => token('-x');

  /// Drops the hostname from the saved directory structure (`-nH`).
  WgetCmd noHostDirectories() => token('-nH');

  /// Prefixes the saved path with the protocol name (`--protocol-directories`).
  WgetCmd protocolDirectories() => token('--protocol-directories');

  /// Ignores this many leading directory components of the remote path (`--cut-dirs`).
  WgetCmd cutDirs(String number) => pair('--cut-dirs', number);

  /// The directory everything is saved under (`-P`).
  WgetCmd directoryPrefix(String prefix) => pair('-P', prefix);

  /// The filename to assume for a URL ending in `/` (`--default-page`).
  WgetCmd defaultPage(String name) => pair('--default-page', name);

  /// Appends `.html` to a saved file whose content type says so but whose name does not already end in it (`-E`).
  WgetCmd adjustExtension() => token('-E');

  /// The HTTP username, kept separate from [user] for sites that also speak FTP (`--http-user`).
  WgetCmd httpUser(String user) => pair('--http-user', user);

  /// The HTTP password (`--http-password`).
  WgetCmd httpPassword(String password) => pair('--http-password', password);

  /// Closes the connection after every request instead of reusing it (`--no-http-keep-alive`).
  WgetCmd noHttpKeepAlive() => token('--no-http-keep-alive');

  /// Asks the server to skip its cache for this request (`--no-cache`).
  WgetCmd noCache() => token('--no-cache');

  /// Sends and stores no cookies at all (`--no-cookies`).
  WgetCmd noCookies() => token('--no-cookies');

  /// Loads cookies from this file before the first request (`--load-cookies`).
  WgetCmd loadCookies(String file) => pair('--load-cookies', file);

  /// Saves cookies to this file when done (`--save-cookies`).
  WgetCmd saveCookies(String file) => pair('--save-cookies', file);

  /// Also saves the session cookies [saveCookies] would otherwise drop (`--keep-session-cookies`).
  WgetCmd keepSessionCookies() => token('--keep-session-cookies');

  /// Ignores a bogus or missing `Content-Length` rather than failing on it (`--ignore-length`).
  WgetCmd ignoreLength() => token('--ignore-length');

  /// Adds a request header, `Name: value` (`--header`). Repeatable.
  WgetCmd header(String value) => pair('--header', value);

  /// Requests compression: `auto`, `gzip` or `none` (`--compression`).
  WgetCmd compression(String type) => pair('--compression', type);

  /// Caps how many redirects to follow (`--max-redirect`).
  WgetCmd maxRedirect(String number) => pair('--max-redirect', number);

  /// The proxy username (`--proxy-user`).
  WgetCmd proxyUser(String user) => pair('--proxy-user', user);

  /// The proxy password (`--proxy-password`).
  WgetCmd proxyPassword(String password) => pair('--proxy-password', password);

  /// The `Referer` header to send (`--referer`).
  WgetCmd referer(String url) => pair('--referer', url);

  /// Saves the raw response headers alongside the body (`--save-headers`).
  WgetCmd saveHeaders() => token('--save-headers');

  /// The `User-Agent` header to send (`-U`).
  WgetCmd userAgent(String agentString) => pair('-U', agentString);

  /// POSTs this data with `Content-Type: application/x-www-form-urlencoded` (`--post-data`).
  WgetCmd postData(String value) => pair('--post-data', value);

  /// POSTs the contents of this file (`--post-file`).
  WgetCmd postFile(String file) => pair('--post-file', file);

  /// Sets the HTTP method explicitly, for anything beyond GET and POST (`--method`).
  WgetCmd method(String httpMethod) => pair('--method', httpMethod);

  /// The request body for [method], inline (`--body-data`).
  WgetCmd bodyData(String value) => pair('--body-data', value);

  /// The request body for [method], from a file (`--body-file`).
  WgetCmd bodyFile(String file) => pair('--body-file', file);

  /// Honours `Content-Disposition` when naming the saved file (`--content-disposition`).
  WgetCmd contentDisposition() => token('--content-disposition');

  /// Keeps the response body of an HTTP error instead of discarding it (`--content-on-error`).
  WgetCmd contentOnError() => token('--content-on-error');

  /// Names the saved file after the final redirected URL rather than the original (`--trust-server-names`).
  WgetCmd trustServerNames() => token('--trust-server-names');

  /// Sends Basic auth on the first request instead of waiting for a 401 (`--auth-no-challenge`).
  WgetCmd authNoChallenge() => token('--auth-no-challenge');

  /// Treats a host-resolution failure as transient and retryable (`--retry-on-host-error`).
  WgetCmd retryOnHostError() => token('--retry-on-host-error');

  /// Retries on these HTTP status codes too, comma-separated (`--retry-on-http-error`).
  WgetCmd retryOnHttpError(String codes) => pair('--retry-on-http-error', codes);

  /// The TLS/SSL protocol to use: `auto`, `SSLv3`, `TLSv1` and so on (`--secure-protocol`).
  WgetCmd secureProtocol(String protocol) => pair('--secure-protocol', protocol);

  /// While recursing, follows only `https://` links (`--https-only`).
  WgetCmd httpsOnly() => token('--https-only');

  /// The TLS cipher list string (`--ciphers`).
  WgetCmd ciphers(String list) => pair('--ciphers', list);

  /// Skips certificate verification entirely (`--no-check-certificate`). For a self-signed dev server, nothing more.
  WgetCmd noCheckCertificate() => token('--no-check-certificate');

  /// The client certificate file (`--certificate`).
  WgetCmd certificate(String file) => pair('--certificate', file);

  /// The client certificate type: `PEM` or `DER` (`--certificate-type`).
  WgetCmd certificateType(String type) => pair('--certificate-type', type);

  /// The client private key file (`--private-key`).
  WgetCmd privateKey(String file) => pair('--private-key', file);

  /// The client private key type (`--private-key-type`).
  WgetCmd privateKeyType(String type) => pair('--private-key-type', type);

  /// The CA bundle to verify the server against (`--ca-certificate`).
  WgetCmd caCertificate(String file) => pair('--ca-certificate', file);

  /// A directory of CA certificates to verify the server against (`--ca-directory`).
  WgetCmd caDirectory(String directory) => pair('--ca-directory', directory);

  /// A certificate revocation list to check against (`--crl-file`).
  WgetCmd crlFile(String file) => pair('--crl-file', file);

  /// Pins the peer's public key, by file or hash (`--pinnedpubkey`).
  WgetCmd pinnedpubkey(String value) => pair('--pinnedpubkey', value);

  /// A file to seed the PRNG from (`--random-file`).
  WgetCmd randomFile(String file) => pair('--random-file', file);

  /// An EGD socket to seed randomness from (`--egd-file`).
  WgetCmd egdFile(String file) => pair('--egd-file', file);

  /// Disables HSTS support (`--no-hsts`).
  WgetCmd noHsts() => token('--no-hsts');

  /// The HSTS database file (`--hsts-file`).
  WgetCmd hstsFile(String file) => pair('--hsts-file', file);

  /// Writes a WARC archive to this file instead of, or alongside, ordinary output (`--warc-file`).
  WgetCmd warcFile(String file) => pair('--warc-file', file);

  /// A string added to the WARC file's `warcinfo` record (`--warc-header`).
  WgetCmd warcHeader(String value) => pair('--warc-header', value);

  /// The maximum size of one WARC file before wget splits it (`--warc-max-size`).
  WgetCmd warcMaxSize(String size) => pair('--warc-max-size', size);

  /// Also writes a CDX index alongside the WARC file (`--warc-cdx`).
  WgetCmd warcCdx() => token('--warc-cdx');

  /// Skips records already listed in this CDX deduplication file (`--warc-dedup`).
  WgetCmd warcDedup(String file) => pair('--warc-dedup', file);

  /// Writes the WARC file uncompressed (`--no-warc-compression`).
  WgetCmd noWarcCompression() => token('--no-warc-compression');

  /// Skips the SHA1 digests WARC normally records (`--no-warc-digests`).
  WgetCmd noWarcDigests() => token('--no-warc-digests');

  /// Leaves the run's log out of the WARC file (`--no-warc-keep-log`).
  WgetCmd noWarcKeepLog() => token('--no-warc-keep-log');

  /// Where WARC writes its temporary files (`--warc-tempdir`).
  WgetCmd warcTempdir(String dir) => pair('--warc-tempdir', dir);

  /// The FTP username, kept separate from [user] for sites that also speak HTTP (`--ftp-user`).
  WgetCmd ftpUser(String user) => pair('--ftp-user', user);

  /// The FTP password (`--ftp-password`).
  WgetCmd ftpPassword(String password) => pair('--ftp-password', password);

  /// Keeps the `.listing` files FTP mode writes, instead of deleting them (`--no-remove-listing`).
  WgetCmd noRemoveListing() => token('--no-remove-listing');

  /// Turns off FTP wildcard expansion (`--no-glob`).
  WgetCmd noGlob() => token('--no-glob');

  /// Turns off passive FTP, using active mode instead (`--no-passive-ftp`).
  WgetCmd noPassiveFtp() => token('--no-passive-ftp');

  /// Applies the remote file's permissions to the local copy (`--preserve-permissions`).
  WgetCmd preservePermissions() => token('--preserve-permissions');

  /// Follows FTP symlinks instead of skipping them (`--retr-symlinks`).
  WgetCmd retrSymlinks() => token('--retr-symlinks');

  /// Connects with implicit FTPS rather than negotiating `AUTH TLS` (`--ftps-implicit`).
  WgetCmd ftpsImplicit() => token('--ftps-implicit');

  /// Skips resuming the TLS session on the FTPS data channel (`--no-ftps-resume-ssl`).
  WgetCmd noFtpsResumeSsl() => token('--no-ftps-resume-ssl');

  /// Sends the FTPS data channel in the clear (`--ftps-clear-data-connection`).
  WgetCmd ftpsClearDataConnection() => token('--ftps-clear-data-connection');

  /// Falls back to plain FTP when the server refuses FTPS (`--ftps-fallback-to-ftp`).
  WgetCmd ftpsFallbackToFtp() => token('--ftps-fallback-to-ftp');

  /// Follows links and downloads recursively (`-r`).
  WgetCmd recursive() => token('-r');

  /// How many levels deep [recursive] goes, `0` for unlimited (`-l`).
  WgetCmd level(String depth) => pair('-l', depth);

  /// Deletes each file right after downloading it, once recursion is over (`--delete-after`).
  ///
  /// What a spider run uses to walk pages without keeping any of them.
  WgetCmd deleteAfter() => token('--delete-after');

  /// Rewrites links in downloaded pages so they work when browsed locally (`-k`).
  WgetCmd convertLinks() => token('-k');

  /// Under [convertLinks], only converts the filename part of a URL, not the path (`--convert-file-only`).
  WgetCmd convertFileOnly() => token('--convert-file-only');

  /// Keeps the original file as `.orig` before [convertLinks] rewrites it (`-K`).
  WgetCmd backupConverted() => token('-K');

  /// Turns on a whole bundle of recursive flags meant for mirroring a site (`-m`).
  ///
  /// Expands to infinite recursion depth, timestamping, and preserving the remote directory structure — read what that means for the target before pointing it at a site you do not control.
  WgetCmd mirror() => token('-m');

  /// While recursing, also fetches the images and stylesheets a page needs to render (`-p`).
  WgetCmd pageRequisites() => token('-p');

  /// Requires strict HTML comment syntax while parsing (`--strict-comments`).
  WgetCmd strictComments() => token('--strict-comments');

  /// Only saves files whose name matches these suffixes or patterns (`-A`).
  WgetCmd accept(String list) => pair('-A', list);

  /// Skips files whose name matches these suffixes or patterns (`-R`).
  WgetCmd reject(String list) => pair('-R', list);

  /// Only follows URLs matching this regular expression (`--accept-regex`).
  WgetCmd acceptRegex(String urlRegex) => pair('--accept-regex', urlRegex);

  /// Skips URLs matching this regular expression (`--reject-regex`).
  WgetCmd rejectRegex(String urlRegex) => pair('--reject-regex', urlRegex);

  /// The regex dialect [acceptRegex] and [rejectRegex] use: `posix` or `pcre` (`--regex-type`).
  WgetCmd regexType(String type) => pair('--regex-type', type);

  /// Only follows links to these domains, comma-separated (`-D`).
  WgetCmd domains(String domainList) => pair('-D', domainList);

  /// Skips links to these domains, comma-separated (`--exclude-domains`).
  WgetCmd excludeDomains(String domainList) => pair('--exclude-domains', domainList);

  /// Follows FTP links found inside an HTML page (`--follow-ftp`).
  WgetCmd followFtp() => token('--follow-ftp');

  /// Only follows links found inside these HTML tags (`--follow-tags`).
  WgetCmd followTags(String list) => pair('--follow-tags', list);

  /// Skips links found inside these HTML tags (`--ignore-tags`).
  WgetCmd ignoreTags(String list) => pair('--ignore-tags', list);

  /// The URL to fetch. Repeatable for several transfers in one run.
  WgetCmd url(String value) => token(value);
}

/// `wget`, ready to take its first option.
// ignore: non_constant_identifier_names
WgetCmd get Wget => WgetCmd();
