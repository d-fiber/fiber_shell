// Copyright (C) 2026 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import '../../builder.dart';

/// `curl`, the transfer tool. Preinstalled on macOS and on current Windows,
/// packaged by every Linux distribution, which makes it the safest network
/// assumption in this directory.
///
/// ```dart
/// final ShellResult r = await Curl.failFast().silent().showError().location()
///     .header('Authorization: Bearer $token').url(endpoint).output();
/// ```
///
/// Builds differ in what was compiled into them, and in which TLS library they
/// were linked against. HTTP/3 is absent from most stock builds, and an option
/// naming an OpenSSL feature can be quietly ignored by a build linked against
/// something else. `curl --version` lists what the one you got actually has.
///
/// Three flags belong on almost every scripted call. [failFast] turns an HTTP 4xx
/// or 5xx into a non-zero status, without which curl reports success for a 500.
/// [silent] drops the progress meter, and [showError] puts the error message back
/// after [silent] took it away.
class CurlCmd extends CommandBuilder<CurlCmd> {
  @override
  final String executable = 'curl';

  /// Connects through an abstract Unix socket (`--abstract-unix-socket`).
  CurlCmd abstractUnixSocket(String path) => pair('--abstract-unix-socket', path);

  /// Turns Alt-Svc on, cached in this file (`--alt-svc`).
  CurlCmd altSvc(String filename) => pair('--alt-svc', filename);

  /// Lets curl pick whichever authentication method the server offers (`--anyauth`).
  CurlCmd anyauth() => token('--anyauth');

  /// Appends to the remote file when uploading rather than replacing it (`-a`).
  CurlCmd append() => token('-a');

  /// Signs the request with AWS Signature V4 (`--aws-sigv4`).
  CurlCmd awsSigv4(String provider) => pair('--aws-sigv4', provider);

  /// Uses HTTP Basic authentication (`--basic`).
  CurlCmd basic() => token('--basic');

  /// Takes the CA certificates from the operating system store (`--ca-native`).
  CurlCmd caNative() => token('--ca-native');

  /// The CA bundle to verify the peer against (`--cacert`).
  CurlCmd cacert(String file) => pair('--cacert', file);

  /// A directory of CA certificates to verify the peer against (`--capath`).
  CurlCmd capath(String dir) => pair('--capath', dir);

  /// The client certificate, optionally `cert:password` (`-E`).
  CurlCmd cert(String certificate) => pair('-E', certificate);

  /// Checks the server certificate's OCSP staple (`--cert-status`).
  CurlCmd certStatus() => token('--cert-status');

  /// The client certificate type: `DER`, `PEM`, `ENG` or `P12` (`--cert-type`).
  CurlCmd certType(String type) => pair('--cert-type', type);

  /// The TLS 1.2 and below cipher list (`--ciphers`).
  CurlCmd ciphers(String list) => pair('--ciphers', list);

  /// Asks for a compressed response and decompresses it (`--compressed`).
  CurlCmd compressed() => token('--compressed');

  /// Turns SSH compression on (`--compressed-ssh`).
  CurlCmd compressedSsh() => token('--compressed-ssh');

  /// Reads more options from this file (`-K`).
  CurlCmd config(String file) => pair('-K', file);

  /// How long to wait for the connection alone (`--connect-timeout`).
  CurlCmd connectTimeout(String seconds) => pair('--connect-timeout', seconds);

  /// Connects to a different host and port than the URL says (`--connect-to`).
  CurlCmd connectTo(String value) => pair('--connect-to', value);

  /// Resumes a transfer at this offset (`-C`).
  CurlCmd continueAt(String offset) => pair('-C', offset);

  /// Sends cookies, from a string or a file (`-b`).
  CurlCmd cookie(String value) => pair('-b', value);

  /// Writes the cookies out to this file when done (`-c`).
  CurlCmd cookieJar(String filename) => pair('-c', filename);

  /// Creates the local directories the output path needs (`--create-dirs`).
  CurlCmd createDirs() => token('--create-dirs');

  /// The mode for files curl creates (`--create-file-mode`).
  CurlCmd createFileMode(String mode) => pair('--create-file-mode', mode);

  /// Converts LF to CRLF while uploading (`--crlf`).
  CurlCmd crlf() => token('--crlf');

  /// The certificate revocation list to check against (`--crlfile`).
  CurlCmd crlfile(String file) => pair('--crlfile', file);

  /// The TLS key exchange curves to offer (`--curves`).
  CurlCmd curves(String list) => pair('--curves', list);

  /// POSTs this data, `@file` to read it from a file (`-d`).
  CurlCmd data(String value) => pair('-d', value);

  /// The same as [data] (`--data-ascii`).
  CurlCmd dataAscii(String value) => pair('--data-ascii', value);

  /// POSTs this data without touching the newlines (`--data-binary`).
  CurlCmd dataBinary(String value) => pair('--data-binary', value);

  /// POSTs this data with `@` taken literally (`--data-raw`).
  CurlCmd dataRaw(String value) => pair('--data-raw', value);

  /// POSTs this data, URL-encoded (`--data-urlencode`).
  CurlCmd dataUrlencode(String value) => pair('--data-urlencode', value);

  /// How far to delegate GSS-API credentials (`--delegation`).
  CurlCmd delegation(String level) => pair('--delegation', level);

  /// Uses HTTP Digest authentication (`--digest`).
  CurlCmd digest() => token('--digest');

  /// Ignores `.curlrc` (`-q`). Worth it whenever the run must be reproducible.
  CurlCmd disable() => token('-q');

  /// Stops using EPRT and LPRT for FTP (`--disable-eprt`).
  CurlCmd disableEprt() => token('--disable-eprt');

  /// Stops using EPSV for FTP (`--disable-epsv`).
  CurlCmd disableEpsv() => token('--disable-epsv');

  /// Refuses a URL carrying a username (`--disallow-username-in-url`).
  CurlCmd disallowUsernameInUrl() => token('--disallow-username-in-url');

  /// The interface to send DNS queries from (`--dns-interface`).
  CurlCmd dnsInterface(String name) => pair('--dns-interface', name);

  /// The IPv4 address to send DNS queries from (`--dns-ipv4-addr`).
  CurlCmd dnsIpv4Addr(String address) => pair('--dns-ipv4-addr', address);

  /// The IPv6 address to send DNS queries from (`--dns-ipv6-addr`).
  CurlCmd dnsIpv6Addr(String address) => pair('--dns-ipv6-addr', address);

  /// The DNS servers to ask (`--dns-servers`).
  CurlCmd dnsServers(String addresses) => pair('--dns-servers', addresses);

  /// Checks the DoH server's OCSP staple (`--doh-cert-status`).
  CurlCmd dohCertStatus() => token('--doh-cert-status');

  /// Skips verification of the DoH server (`--doh-insecure`).
  CurlCmd dohInsecure() => token('--doh-insecure');

  /// Resolves names over DNS-over-HTTPS at this URL (`--doh-url`).
  CurlCmd dohUrl(String url) => pair('--doh-url', url);

  /// Writes the response headers to this file (`-D`).
  CurlCmd dumpHeader(String filename) => pair('-D', filename);

  /// The EGD socket to seed randomness from (`--egd-file`).
  CurlCmd egdFile(String file) => pair('--egd-file', file);

  /// The crypto engine to use (`--engine`).
  CurlCmd engine(String name) => pair('--engine', name);

  /// Sends an `If-None-Match` built from the ETag in this file (`--etag-compare`).
  CurlCmd etagCompare(String file) => pair('--etag-compare', file);

  /// Saves the response ETag into this file (`--etag-save`).
  CurlCmd etagSave(String file) => pair('--etag-save', file);

  /// How long to wait for a `100 Continue` (`--expect100-timeout`).
  CurlCmd expect100Timeout(String seconds) => pair('--expect100-timeout', seconds);

  /// Turns an HTTP error status into a non-zero exit, printing nothing (`-f`).
  ///
  /// Without it curl reports success for a 500, which is how silent failures get into scripts.
  CurlCmd failFast() => token('-f');

  /// Stops at the first failing transfer of several (`--fail-early`).
  CurlCmd failEarly() => token('--fail-early');

  /// Fails on an HTTP error but still writes the body (`--fail-with-body`).
  CurlCmd failWithBody() => token('--fail-with-body');

  /// Turns TLS False Start on (`--false-start`).
  CurlCmd falseStart() => token('--false-start');

  /// Adds a multipart field, `@file` to attach a file (`-F`).
  CurlCmd form(String value) => pair('-F', value);

  /// Escapes the form field names with backslashes (`--form-escape`).
  CurlCmd formEscape() => token('--form-escape');

  /// Adds a multipart field whose value is taken literally (`--form-string`).
  CurlCmd formString(String value) => pair('--form-string', value);

  /// The FTP account string (`--ftp-account`).
  CurlCmd ftpAccount(String data) => pair('--ftp-account', data);

  /// The command to send instead of `USER` (`--ftp-alternative-to-user`).
  CurlCmd ftpAlternativeToUser(String command) => pair('--ftp-alternative-to-user', command);

  /// Creates the remote directories if they are missing (`--ftp-create-dirs`).
  CurlCmd ftpCreateDirs() => token('--ftp-create-dirs');

  /// How to reach the target directory: `multicwd`, `nocwd` or `singlecwd` (`--ftp-method`).
  CurlCmd ftpMethod(String method) => pair('--ftp-method', method);

  /// Uses passive mode (`--ftp-pasv`).
  CurlCmd ftpPasv() => token('--ftp-pasv');

  /// Uses active mode from this address (`-P`).
  CurlCmd ftpPort(String address) => pair('-P', address);

  /// Sends `PRET` before `PASV` (`--ftp-pret`).
  CurlCmd ftpPret() => token('--ftp-pret');

  /// Ignores the address `PASV` returns and reuses the control one (`--ftp-skip-pasv-ip`).
  CurlCmd ftpSkipPasvIp() => token('--ftp-skip-pasv-ip');

  /// Clears the command channel after authenticating (`--ftp-ssl-ccc`).
  CurlCmd ftpSslCcc() => token('--ftp-ssl-ccc');

  /// Which CCC mode: `active` or `passive` (`--ftp-ssl-ccc-mode`).
  CurlCmd ftpSslCccMode(String mode) => pair('--ftp-ssl-ccc-mode', mode);

  /// Requires TLS to log in, then transfers in the clear (`--ftp-ssl-control`).
  CurlCmd ftpSslControl() => token('--ftp-ssl-control');

  /// Moves the [data] into the query string and sends a GET (`-G`).
  CurlCmd getRequest() => token('-G');

  /// Stops treating `{}` and `[]` in the URL as globs (`-g`).
  CurlCmd globoff() => token('-g');

  /// How long IPv6 gets before IPv4 is tried (`--happy-eyeballs-timeout-ms`).
  CurlCmd happyEyeballsTimeoutMs(String ms) => pair('--happy-eyeballs-timeout-ms', ms);

  /// The client address to put in the PROXY header (`--haproxy-clientip`).
  CurlCmd haproxyClientip(String ip) => pair('--haproxy-clientip', ip);

  /// Sends a HAProxy PROXY v1 header first (`--haproxy-protocol`).
  CurlCmd haproxyProtocol() => token('--haproxy-protocol');

  /// Sends HEAD, so headers only (`-I`).
  CurlCmd head() => token('-I');

  /// Adds a request header, `@file` to read several (`-H`).
  ///
  /// A header with no value after the colon removes one curl would have sent.
  CurlCmd header(String value) => pair('-H', value);

  /// Prints the help for a category (`-h`).
  CurlCmd help(String category) => pair('-h', category);

  /// The MD5 the SSH host key must match (`--hostpubmd5`).
  CurlCmd hostpubmd5(String value) => pair('--hostpubmd5', value);

  /// The SHA-256 the SSH host key must match (`--hostpubsha256`).
  CurlCmd hostpubsha256(String value) => pair('--hostpubsha256', value);

  /// Turns HSTS on, cached in this file (`--hsts`).
  CurlCmd hsts(String filename) => pair('--hsts', filename);

  /// Accepts an HTTP/0.9 response (`--http0.9`).
  CurlCmd http09() => token('--http0.9');

  /// Speaks HTTP/1.0 (`--http1.0`).
  CurlCmd http10() => token('--http1.0');

  /// Speaks HTTP/1.1 (`--http1.1`).
  CurlCmd http11() => token('--http1.1');

  /// Speaks HTTP/2 (`--http2`).
  CurlCmd http2() => token('--http2');

  /// Speaks HTTP/2 without the HTTP/1.1 upgrade dance (`--http2-prior-knowledge`).
  CurlCmd http2PriorKnowledge() => token('--http2-prior-knowledge');

  /// Speaks HTTP/3 (`--http3`). Absent from most stock builds, which refuse the flag outright.
  CurlCmd http3() => token('--http3');

  /// Speaks HTTP/3 and nothing else (`--http3-only`).
  CurlCmd http3Only() => token('--http3-only');

  /// Ignores the `Content-Length` header (`--ignore-content-length`).
  CurlCmd ignoreContentLength() => token('--ignore-content-length');

  /// Prints the response headers before the body (`-i`).
  CurlCmd include() => token('-i');

  /// Skips certificate verification entirely (`-k`). For a self-signed dev server, nothing more.
  CurlCmd insecure() => token('-k');

  /// The interface or address to go out from (`--interface`).
  CurlCmd networkInterface(String name) => pair('--interface', name);

  /// The gateway for `ipfs://` URLs (`--ipfs-gateway`).
  CurlCmd ipfsGateway(String url) => pair('--ipfs-gateway', url);

  /// Resolves names to IPv4 only (`-4`).
  CurlCmd ipv4() => token('-4');

  /// Resolves names to IPv6 only (`-6`).
  CurlCmd ipv6() => token('-6');

  /// POSTs JSON, setting both content type and accept headers (`--json`).
  CurlCmd json(String data) => pair('--json', data);

  /// Drops the session cookies read from the cookie file (`-j`).
  CurlCmd junkSessionCookies() => token('-j');

  /// How long between TCP keepalive probes (`--keepalive-time`).
  CurlCmd keepaliveTime(String seconds) => pair('--keepalive-time', seconds);

  /// The private key file (`--key`).
  CurlCmd key(String value) => pair('--key', value);

  /// The private key type: `DER`, `PEM` or `ENG` (`--key-type`).
  CurlCmd keyType(String type) => pair('--key-type', type);

  /// Turns Kerberos on at this security level (`--krb`).
  CurlCmd krb(String level) => pair('--krb', level);

  /// Writes the equivalent libcurl C program to this file (`--libcurl`).
  CurlCmd libcurl(String file) => pair('--libcurl', file);

  /// Caps the transfer speed (`--limit-rate`).
  CurlCmd limitRate(String speed) => pair('--limit-rate', speed);

  /// Lists names only, for FTP and the like (`-l`).
  CurlCmd listOnly() => token('-l');

  /// The local port range to bind (`--local-port`).
  CurlCmd localPort(String range) => pair('--local-port', range);

  /// Follows redirects (`-L`).
  CurlCmd location() => token('-L');

  /// Follows them and keeps sending the credentials to the new host (`--location-trusted`).
  ///
  /// Which means handing your token to whoever the redirect points at.
  CurlCmd locationTrusted() => token('--location-trusted');

  /// Protocol-specific login options (`--login-options`).
  CurlCmd loginOptions(String options) => pair('--login-options', options);

  /// The originator address for SMTP (`--mail-auth`).
  CurlCmd mailAuth(String address) => pair('--mail-auth', address);

  /// The SMTP sender (`--mail-from`).
  CurlCmd mailFrom(String address) => pair('--mail-from', address);

  /// An SMTP recipient (`--mail-rcpt`). Repeatable.
  CurlCmd mailRcpt(String address) => pair('--mail-rcpt', address);

  /// Lets a `RCPT TO` fail without failing the send (`--mail-rcpt-allowfails`).
  CurlCmd mailRcptAllowfails() => token('--mail-rcpt-allowfails');

  /// Prints the full manual (`-M`).
  CurlCmd manual() => token('-M');

  /// Refuses a download larger than this (`--max-filesize`).
  CurlCmd maxFilesize(String bytes) => pair('--max-filesize', bytes);

  /// How many redirects to follow (`--max-redirs`).
  CurlCmd maxRedirs(String count) => pair('--max-redirs', count);

  /// The ceiling on the whole transfer, in seconds (`-m`).
  ///
  /// The one that saves an automated run from hanging forever on a stalled connection.
  CurlCmd maxTime(String seconds) => pair('-m', seconds);

  /// Reads the URL as a metalink XML file (`--metalink`).
  CurlCmd metalink() => token('--metalink');

  /// Uses SPNEGO authentication (`--negotiate`).
  CurlCmd negotiate() => token('--negotiate');

  /// Takes the credentials from `.netrc` (`-n`).
  CurlCmd netrc() => token('-n');

  /// Reads the credentials from this netrc file (`--netrc-file`).
  CurlCmd netrcFile(String filename) => pair('--netrc-file', filename);

  /// Uses `.netrc` if it is there, the URL otherwise (`--netrc-optional`).
  CurlCmd netrcOptional() => token('--netrc-optional');

  /// Starts a fresh set of options for the next URL (`--next`).
  CurlCmd next() => token('--next');

  /// Turns the ALPN TLS extension off (`--no-alpn`).
  CurlCmd noAlpn() => token('--no-alpn');

  /// Stops buffering the output stream (`-N`).
  CurlCmd noBuffer() => token('-N');

  /// Leaves an existing output file alone (`--no-clobber`).
  CurlCmd noClobber() => token('--no-clobber');

  /// Turns TCP keepalive off (`--no-keepalive`).
  CurlCmd noKeepalive() => token('--no-keepalive');

  /// Turns the NPN TLS extension off (`--no-npn`).
  CurlCmd noNpn() => token('--no-npn');

  /// Hides the progress meter but keeps the errors (`--no-progress-meter`).
  CurlCmd noProgressMeter() => token('--no-progress-meter');

  /// Stops reusing the TLS session id (`--no-sessionid`).
  CurlCmd noSessionid() => token('--no-sessionid');

  /// The hosts that should bypass the proxy (`--noproxy`).
  CurlCmd noproxy(String list) => pair('--noproxy', list);

  /// Uses NTLM authentication (`--ntlm`).
  CurlCmd ntlm() => token('--ntlm');

  /// Uses NTLM through winbind (`--ntlm-wb`).
  CurlCmd ntlmWb() => token('--ntlm-wb');

  /// The OAuth 2 bearer token (`--oauth2-bearer`).
  CurlCmd oauth2Bearer(String value) => pair('--oauth2-bearer', value);

  /// Writes the body to this file rather than stdout (`-o`).
  CurlCmd outputFile(String file) => pair('-o', file);

  /// The directory the output files go in (`--output-dir`).
  CurlCmd outputDir(String dir) => pair('--output-dir', dir);

  /// Transfers several URLs at once (`-Z`).
  CurlCmd parallel() => token('-Z');

  /// Opens new connections rather than waiting to multiplex (`--parallel-immediate`).
  CurlCmd parallelImmediate() => token('--parallel-immediate');

  /// How many parallel transfers at most (`--parallel-max`).
  CurlCmd parallelMax(String count) => pair('--parallel-max', count);

  /// The passphrase of the private key (`--pass`).
  CurlCmd passPhrase(String phrase) => pair('--pass', phrase);

  /// Leaves `..` and `.` in the path alone (`--path-as-is`).
  CurlCmd pathAsIs() => token('--path-as-is');

  /// Pins the peer public key, by file or hash (`--pinnedpubkey`).
  CurlCmd pinnedpubkey(String hashes) => pair('--pinnedpubkey', hashes);

  /// Keeps POSTing after a 301 instead of switching to GET (`--post301`).
  CurlCmd post301() => token('--post301');

  /// Keeps POSTing after a 302 (`--post302`).
  CurlCmd post302() => token('--post302');

  /// Keeps POSTing after a 303 (`--post303`).
  CurlCmd post303() => token('--post303');

  /// A SOCKS proxy to go through before the HTTP one (`--preproxy`).
  CurlCmd preproxy(String host) => pair('--preproxy', host);

  /// Shows the progress as a bar instead of a table (`-#`).
  CurlCmd progressBar() => token('-#');

  /// Which protocols are allowed (`--proto`).
  CurlCmd proto(String protocols) => pair('--proto', protocols);

  /// The protocol to assume for a URL with no scheme (`--proto-default`).
  CurlCmd protoDefault(String protocol) => pair('--proto-default', protocol);

  /// Which protocols are allowed after a redirect (`--proto-redir`).
  CurlCmd protoRedir(String protocols) => pair('--proto-redir', protocols);

  /// The proxy to go through (`-x`).
  CurlCmd proxy(String host) => pair('-x', host);

  /// Lets curl pick the proxy authentication method (`--proxy-anyauth`).
  CurlCmd proxyAnyauth() => token('--proxy-anyauth');

  /// Basic authentication against the proxy (`--proxy-basic`).
  CurlCmd proxyBasic() => token('--proxy-basic');

  /// Takes the proxy CA certificates from the OS store (`--proxy-ca-native`).
  CurlCmd proxyCaNative() => token('--proxy-ca-native');

  /// The CA bundle for the proxy (`--proxy-cacert`).
  CurlCmd proxyCacert(String file) => pair('--proxy-cacert', file);

  /// A CA directory for the proxy (`--proxy-capath`).
  CurlCmd proxyCapath(String dir) => pair('--proxy-capath', dir);

  /// The client certificate for the proxy (`--proxy-cert`).
  CurlCmd proxyCert(String cert) => pair('--proxy-cert', cert);

  /// Its type (`--proxy-cert-type`).
  CurlCmd proxyCertType(String type) => pair('--proxy-cert-type', type);

  /// The cipher list for the proxy connection (`--proxy-ciphers`).
  CurlCmd proxyCiphers(String list) => pair('--proxy-ciphers', list);

  /// The CRL for the proxy (`--proxy-crlfile`).
  CurlCmd proxyCrlfile(String file) => pair('--proxy-crlfile', file);

  /// Digest authentication against the proxy (`--proxy-digest`).
  CurlCmd proxyDigest() => token('--proxy-digest');

  /// A header for the proxy only (`--proxy-header`).
  CurlCmd proxyHeader(String value) => pair('--proxy-header', value);

  /// Speaks HTTP/2 to an HTTPS proxy (`--proxy-http2`).
  CurlCmd proxyHttp2() => token('--proxy-http2');

  /// Skips verification of the HTTPS proxy certificate (`--proxy-insecure`).
  CurlCmd proxyInsecure() => token('--proxy-insecure');

  /// The private key for the proxy (`--proxy-key`).
  CurlCmd proxyKey(String value) => pair('--proxy-key', value);

  /// Its type (`--proxy-key-type`).
  CurlCmd proxyKeyType(String type) => pair('--proxy-key-type', type);

  /// SPNEGO against the proxy (`--proxy-negotiate`).
  CurlCmd proxyNegotiate() => token('--proxy-negotiate');

  /// NTLM against the proxy (`--proxy-ntlm`).
  CurlCmd proxyNtlm() => token('--proxy-ntlm');

  /// The passphrase of the proxy private key (`--proxy-pass`).
  CurlCmd proxyPass(String phrase) => pair('--proxy-pass', phrase);

  /// Pins the proxy public key (`--proxy-pinnedpubkey`).
  CurlCmd proxyPinnedpubkey(String hashes) => pair('--proxy-pinnedpubkey', hashes);

  /// The SPNEGO service name of the proxy (`--proxy-service-name`).
  CurlCmd proxyServiceName(String name) => pair('--proxy-service-name', name);

  /// Allows the BEAST workaround for the proxy (`--proxy-ssl-allow-beast`).
  CurlCmd proxySslAllowBeast() => token('--proxy-ssl-allow-beast');

  /// Picks a client certificate automatically for the proxy (`--proxy-ssl-auto-client-cert`).
  CurlCmd proxySslAutoClientCert() => token('--proxy-ssl-auto-client-cert');

  /// The TLS 1.3 suites for the proxy (`--proxy-tls13-ciphers`).
  CurlCmd proxyTls13Ciphers(String list) => pair('--proxy-tls13-ciphers', list);

  /// The TLS authentication type for the proxy (`--proxy-tlsauthtype`).
  CurlCmd proxyTlsauthtype(String type) => pair('--proxy-tlsauthtype', type);

  /// The TLS password for the proxy (`--proxy-tlspassword`).
  CurlCmd proxyTlspassword(String value) => pair('--proxy-tlspassword', value);

  /// The TLS username for the proxy (`--proxy-tlsuser`).
  CurlCmd proxyTlsuser(String name) => pair('--proxy-tlsuser', name);

  /// Requires TLSv1 for the proxy (`--proxy-tlsv1`).
  CurlCmd proxyTlsv1() => token('--proxy-tlsv1');

  /// The proxy credentials, `user:password` (`-U`).
  CurlCmd proxyUser(String value) => pair('-U', value);

  /// An HTTP/1.0 proxy (`--proxy1.0`).
  CurlCmd proxy10(String host) => pair('--proxy1.0', host);

  /// Tunnels through the HTTP proxy with `CONNECT` (`-p`).
  CurlCmd proxytunnel() => token('-p');

  /// The SSH public key file (`--pubkey`).
  CurlCmd pubkey(String value) => pair('--pubkey', value);

  /// A command to send before the transfer, for FTP and SFTP (`-Q`).
  CurlCmd quote(String command) => pair('-Q', command);

  /// The file to read randomness from (`--random-file`).
  CurlCmd randomFile(String file) => pair('--random-file', file);

  /// Fetches only this byte range (`-r`).
  CurlCmd range(String value) => pair('-r', value);

  /// How many requests per unit of time, for serial transfers (`--rate`).
  CurlCmd rate(String value) => pair('--rate', value);

  /// Turns off HTTP transfer decoding (`--raw`).
  CurlCmd raw() => token('--raw');

  /// The `Referer` header (`-e`).
  CurlCmd referer(String url) => pair('-e', url);

  /// Names the file from `Content-Disposition` rather than the URL (`-J`).
  CurlCmd remoteHeaderName() => token('-J');

  /// Saves to a file named after the remote one (`-O`).
  CurlCmd remoteName() => token('-O');

  /// Applies [remoteName] to every URL given (`--remote-name-all`).
  CurlCmd remoteNameAll() => token('--remote-name-all');

  /// Stamps the local file with the remote timestamp (`-R`).
  CurlCmd remoteTime() => token('-R');

  /// Deletes the output file when the transfer fails (`--remove-on-error`).
  CurlCmd removeOnError() => token('--remove-on-error');

  /// The HTTP method (`-X`).
  CurlCmd request(String method) => pair('-X', method);

  /// The request target to send instead of the URL path (`--request-target`).
  CurlCmd requestTarget(String path) => pair('--request-target', path);

  /// Pins a host and port to an address, bypassing DNS (`--resolve`).
  ///
  /// The clean way to test a vhost before its DNS exists.
  CurlCmd resolve(String value) => pair('--resolve', value);

  /// Retries this many times on a transient failure (`--retry`).
  CurlCmd retry(String count) => pair('--retry', count);

  /// Retries on any error, not just the transient ones (`--retry-all-errors`).
  CurlCmd retryAllErrors() => token('--retry-all-errors');

  /// Counts a refused connection as retryable (`--retry-connrefused`).
  ///
  /// What you want while waiting for a service to come up.
  CurlCmd retryConnrefused() => token('--retry-connrefused');

  /// How long between retries (`--retry-delay`).
  CurlCmd retryDelay(String seconds) => pair('--retry-delay', seconds);

  /// Stops retrying after this long (`--retry-max-time`).
  CurlCmd retryMaxTime(String seconds) => pair('--retry-max-time', seconds);

  /// The authorisation identity for SASL PLAIN (`--sasl-authzid`).
  CurlCmd saslAuthzid(String identity) => pair('--sasl-authzid', identity);

  /// Sends the initial SASL response immediately (`--sasl-ir`).
  CurlCmd saslIr() => token('--sasl-ir');

  /// The SPNEGO service name (`--service-name`).
  CurlCmd serviceName(String name) => pair('--service-name', name);

  /// Prints the error message even under [silent] (`-S`).
  CurlCmd showError() => token('-S');

  /// Hides the progress meter and the error messages (`-s`).
  CurlCmd silent() => token('-s');

  /// A SOCKS4 proxy (`--socks4`).
  CurlCmd socks4(String host) => pair('--socks4', host);

  /// A SOCKS4a proxy (`--socks4a`).
  CurlCmd socks4a(String host) => pair('--socks4a', host);

  /// A SOCKS5 proxy, resolving names locally (`--socks5`).
  CurlCmd socks5(String host) => pair('--socks5', host);

  /// Username and password authentication for SOCKS5 (`--socks5-basic`).
  CurlCmd socks5Basic() => token('--socks5-basic');

  /// GSS-API authentication for SOCKS5 (`--socks5-gssapi`).
  CurlCmd socks5Gssapi() => token('--socks5-gssapi');

  /// The NEC-compatible GSS-API variant (`--socks5-gssapi-nec`).
  CurlCmd socks5GssapiNec() => token('--socks5-gssapi-nec');

  /// The SOCKS5 GSS-API service name (`--socks5-gssapi-service`).
  CurlCmd socks5GssapiService(String name) => pair('--socks5-gssapi-service', name);

  /// A SOCKS5 proxy that resolves the name itself (`--socks5-hostname`).
  CurlCmd socks5Hostname(String host) => pair('--socks5-hostname', host);

  /// The floor below which a transfer counts as stalled (`-Y`).
  CurlCmd speedLimit(String speed) => pair('-Y', speed);

  /// How long it may stay below [speedLimit] before curl gives up (`-y`).
  CurlCmd speedTime(String seconds) => pair('-y', seconds);

  /// Tries TLS but carries on without it (`--ssl`).
  CurlCmd ssl() => token('--ssl');

  /// Allows the BEAST workaround (`--ssl-allow-beast`).
  CurlCmd sslAllowBeast() => token('--ssl-allow-beast');

  /// Picks a client certificate automatically, Schannel only (`--ssl-auto-client-cert`).
  CurlCmd sslAutoClientCert() => token('--ssl-auto-client-cert');

  /// Skips the revocation checks, Schannel only (`--ssl-no-revoke`).
  CurlCmd sslNoRevoke() => token('--ssl-no-revoke');

  /// Requires TLS and fails without it (`--ssl-reqd`).
  CurlCmd sslReqd() => token('--ssl-reqd');

  /// Tolerates a certificate with no CRL distribution point (`--ssl-revoke-best-effort`).
  CurlCmd sslRevokeBestEffort() => token('--ssl-revoke-best-effort');

  /// SSLv2 (`-2`). Broken for twenty years; most builds refuse.
  CurlCmd sslv2() => token('-2');

  /// SSLv3 (`-3`). Broken since POODLE.
  CurlCmd sslv3() => token('-3');

  /// Redirects the messages to this file (`--stderr`).
  CurlCmd stderrFile(String file) => pair('--stderr', file);

  /// Colours the printed HTTP headers (`--styled-output`).
  CurlCmd styledOutput() => token('--styled-output');

  /// Hides the headers of the proxy `CONNECT` response (`--suppress-connect-headers`).
  CurlCmd suppressConnectHeaders() => token('--suppress-connect-headers');

  /// Uses TCP Fast Open (`--tcp-fastopen`).
  CurlCmd tcpFastopen() => token('--tcp-fastopen');

  /// Sets `TCP_NODELAY` (`--tcp-nodelay`).
  CurlCmd tcpNodelay() => token('--tcp-nodelay');

  /// A telnet option, `opt=val` (`-t`).
  CurlCmd telnetOption(String value) => pair('-t', value);

  /// The TFTP block size (`--tftp-blksize`).
  CurlCmd tftpBlksize(String value) => pair('--tftp-blksize', value);

  /// Sends no TFTP options at all (`--tftp-no-options`).
  CurlCmd tftpNoOptions() => token('--tftp-no-options');

  /// Transfers only if the remote file is newer or older than this (`-z`).
  CurlCmd timeCond(String time) => pair('-z', time);

  /// The highest TLS version to accept (`--tls-max`).
  CurlCmd tlsMax(String version) => pair('--tls-max', version);

  /// The TLS 1.3 cipher suites (`--tls13-ciphers`).
  CurlCmd tls13Ciphers(String list) => pair('--tls13-ciphers', list);

  /// The TLS authentication type (`--tlsauthtype`).
  CurlCmd tlsauthtype(String type) => pair('--tlsauthtype', type);

  /// The TLS password (`--tlspassword`).
  CurlCmd tlspassword(String value) => pair('--tlspassword', value);

  /// The TLS username (`--tlsuser`).
  CurlCmd tlsuser(String name) => pair('--tlsuser', name);

  /// Requires TLSv1.0 or better (`-1`).
  CurlCmd tlsv1() => token('-1');

  /// Requires TLSv1.0 or better (`--tlsv1.0`).
  CurlCmd tlsv10() => token('--tlsv1.0');

  /// Requires TLSv1.1 or better (`--tlsv1.1`).
  CurlCmd tlsv11() => token('--tlsv1.1');

  /// Requires TLSv1.2 or better (`--tlsv1.2`).
  CurlCmd tlsv12() => token('--tlsv1.2');

  /// Requires TLSv1.3 (`--tlsv1.3`).
  CurlCmd tlsv13() => token('--tlsv1.3');

  /// Asks for a compressed transfer encoding (`--tr-encoding`).
  CurlCmd trEncoding() => token('--tr-encoding');

  /// Writes a full hex trace to this file (`--trace`).
  CurlCmd trace(String file) => pair('--trace', file);

  /// The same trace without the hex columns (`--trace-ascii`).
  CurlCmd traceAscii(String file) => pair('--trace-ascii', file);

  /// What to include in the trace (`--trace-config`).
  CurlCmd traceConfig(String value) => pair('--trace-config', value);

  /// Adds transfer and connection ids to the verbose output (`--trace-ids`).
  CurlCmd traceIds() => token('--trace-ids');

  /// Timestamps every trace line (`--trace-time`).
  CurlCmd traceTime() => token('--trace-time');

  /// Connects through this Unix socket (`--unix-socket`).
  ///
  /// How you talk to a Docker daemon without opening a port.
  CurlCmd unixSocket(String path) => pair('--unix-socket', path);

  /// Uploads this local file, with PUT over HTTP (`-T`).
  CurlCmd uploadFile(String file) => pair('-T', file);

  /// The URL, spelled as an option (`--url`).
  CurlCmd urlOption(String value) => pair('--url', value);

  /// Appends this to the query string (`--url-query`).
  CurlCmd urlQuery(String data) => pair('--url-query', data);

  /// Transfers in ASCII mode (`-B`).
  CurlCmd useAscii() => token('-B');

  /// The credentials, `user:password` (`-u`).
  CurlCmd user(String value) => pair('-u', value);

  /// The `User-Agent` header (`-A`).
  CurlCmd userAgent(String name) => pair('-A', name);

  /// Defines a variable for [writeOut] (`--variable`).
  CurlCmd variable(String value) => pair('--variable', value);

  /// Narrates the connection and the headers on stderr (`-v`).
  CurlCmd verbose() => token('-v');

  /// Prints the version and the features compiled in (`-V`).
  CurlCmd version() => token('-V');

  /// Prints this format string once the transfer is done (`-w`).
  ///
  /// `%{http_code}` is the usual reason: the status without parsing the headers.
  CurlCmd writeOut(String format) => pair('-w', format);

  /// Stores the source URL in the extended attributes of the file (`--xattr`).
  CurlCmd xattr() => token('--xattr');

  /// The URL. Comes last by convention, and repeats for several transfers.
  CurlCmd url(String value) => token(value);
}

/// `curl`, ready to take its first option.
// ignore: non_constant_identifier_names
CurlCmd get Curl => CurlCmd();
