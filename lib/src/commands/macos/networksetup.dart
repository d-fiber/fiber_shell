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

/// `networksetup`, the network preferences tool. macOS only, and the writable
/// counterpart of [ScutilCmd]: this one changes the configuration, that one
/// reports the state it produces.
///
/// ```dart
/// final ShellResult services = await Networksetup.listAllNetworkServices().output();
/// await Networksetup.setDnsServers('Wi-Fi').arg('1.1.1.1').asRoot().execute();
/// ```
///
/// Almost everything is addressed by **network service name** (`Wi-Fi`,
/// `Ethernet`, `Thunderbolt Bridge`) rather than by interface. The names are
/// localised and users rename them, so read them from [listAllNetworkServices]
/// rather than hard-coding one. A service that is disabled comes back with a `*`
/// in front of it, which is not part of the name.
///
/// [setDnsServers] with `Empty` clears the list and hands DNS back to DHCP;
/// there is no separate clear verb.
///
/// Anything that writes wants `asRoot()`.
class NetworksetupCmd extends CommandBuilder<NetworksetupCmd> {
  @override
  final String executable = 'networksetup';

  /// Lists the network services, in the order they are tried (`-listallnetworkservices`).
  NetworksetupCmd listAllNetworkServices() => token('-listallnetworkservices');

  /// Lists the hardware ports and their interfaces (`-listallhardwareports`).
  NetworksetupCmd listAllHardwarePorts() => token('-listallhardwareports');

  /// Prints that order with its indices (`-listnetworkserviceorder`).
  NetworksetupCmd listNetworkServiceOrder() => token('-listnetworkserviceorder');

  /// Prints the configuration of a service (`-getinfo`).
  NetworksetupCmd getInfo(String service) => pair('-getinfo', service);

  /// Prints the DNS servers of a service (`-getdnsservers`).
  ///
  /// Says "There aren't any" when DHCP is providing them, rather than listing
  /// what DHCP gave. [ScutilCmd.dns] for that.
  NetworksetupCmd getDnsServers(String service) => pair('-getdnsservers', service);

  /// Sets them; `Empty` hands DNS back to DHCP (`-setdnsservers`).
  NetworksetupCmd setDnsServers(String service) => pair('-setdnsservers', service);

  /// Prints the search domains (`-getsearchdomains`).
  NetworksetupCmd getSearchDomains(String service) => pair('-getsearchdomains', service);

  /// Sets them (`-setsearchdomains`).
  NetworksetupCmd setSearchDomains(String service) => pair('-setsearchdomains', service);

  /// Switches a service to DHCP (`-setdhcp`).
  NetworksetupCmd setDhcp(String service) => pair('-setdhcp', service);

  /// Gives it a static address, mask and router (`-setmanual`).
  NetworksetupCmd setManual(String service) => pair('-setmanual', service);

  /// Turns a service on or off (`-setnetworkserviceenabled`).
  NetworksetupCmd setNetworkServiceEnabled(String service) => pair('-setnetworkserviceenabled', service);

  /// Asks whether it is on (`-getnetworkserviceenabled`).
  NetworksetupCmd getNetworkServiceEnabled(String service) => pair('-getnetworkserviceenabled', service);

  /// Prints the MAC address of a hardware port (`-getmacaddress`).
  NetworksetupCmd getMacAddress(String port) => pair('-getmacaddress', port);

  /// Prints the machine name (`-getcomputername`).
  NetworksetupCmd getComputerName() => token('-getcomputername');

  /// Sets it (`-setcomputername`).
  NetworksetupCmd setComputerName(String name) => pair('-setcomputername', name);

  /// Prints the HTTP proxy of a service (`-getwebproxy`).
  NetworksetupCmd getWebProxy(String service) => pair('-getwebproxy', service);

  /// Sets it (`-setwebproxy`).
  NetworksetupCmd setWebProxy(String service) => pair('-setwebproxy', service);

  /// Turns it on or off without forgetting it (`-setwebproxystate`).
  NetworksetupCmd setWebProxyState(String service) => pair('-setwebproxystate', service);

  /// Prints the HTTPS proxy (`-getsecurewebproxy`).
  NetworksetupCmd getSecureWebProxy(String service) => pair('-getsecurewebproxy', service);

  /// Sets it (`-setsecurewebproxy`).
  NetworksetupCmd setSecureWebProxy(String service) => pair('-setsecurewebproxy', service);

  /// Turns it on or off (`-setsecurewebproxystate`).
  NetworksetupCmd setSecureWebProxyState(String service) => pair('-setsecurewebproxystate', service);

  /// Prints the SOCKS proxy (`-getsocksfirewallproxy`).
  NetworksetupCmd getSocksProxy(String service) => pair('-getsocksfirewallproxy', service);

  /// Sets it (`-setsocksfirewallproxy`).
  NetworksetupCmd setSocksProxy(String service) => pair('-setsocksfirewallproxy', service);

  /// Prints the domains that bypass the proxy (`-getproxybypassdomains`).
  NetworksetupCmd getProxyBypassDomains(String service) => pair('-getproxybypassdomains', service);

  /// Sets them (`-setproxybypassdomains`).
  NetworksetupCmd setProxyBypassDomains(String service) => pair('-setproxybypassdomains', service);

  /// Prints the automatic proxy configuration URL (`-getautoproxyurl`).
  NetworksetupCmd getAutoProxyUrl(String service) => pair('-getautoproxyurl', service);

  /// Sets it (`-setautoproxyurl`).
  NetworksetupCmd setAutoProxyUrl(String service) => pair('-setautoproxyurl', service);

  /// Prints the MTU of an interface (`-getMTU`).
  NetworksetupCmd getMtu(String device) => pair('-getMTU', device);

  /// Sets it (`-setMTU`).
  NetworksetupCmd setMtu(String device) => pair('-setMTU', device);

  /// Prints the Wi-Fi network in use (`-getairportnetwork`).
  NetworksetupCmd getAirportNetwork(String device) => pair('-getairportnetwork', device);

  /// Joins one (`-setairportnetwork`).
  NetworksetupCmd setAirportNetwork(String device) => pair('-setairportnetwork', device);

  /// Asks whether the Wi-Fi radio is on (`-getairportpower`).
  NetworksetupCmd getAirportPower(String device) => pair('-getairportpower', device);

  /// Turns it on or off (`-setairportpower`).
  NetworksetupCmd setAirportPower(String device) => pair('-setairportpower', device);

  /// Creates a network service (`-createnetworkservice`).
  NetworksetupCmd createNetworkService(String name) => pair('-createnetworkservice', name);

  /// Removes one (`-removenetworkservice`).
  NetworksetupCmd removeNetworkService(String name) => pair('-removenetworkservice', name);

  /// Reorders them (`-ordernetworkservices`).
  NetworksetupCmd orderNetworkServices() => token('-ordernetworkservices');

  /// Lists the network locations (`-listlocations`).
  NetworksetupCmd listLocations() => token('-listlocations');

  /// Prints the one in use (`-getcurrentlocation`).
  NetworksetupCmd getCurrentLocation() => token('-getcurrentlocation');

  /// Switches to another (`-switchtolocation`).
  NetworksetupCmd switchToLocation(String name) => pair('-switchtolocation', name);

  /// Prints every verb this build understands (`-printcommands`).
  NetworksetupCmd printCommands() => token('-printcommands');

  /// Prints the version (`-version`).
  NetworksetupCmd version() => token('-version');

  /// Prints the usage summary (`-help`).
  NetworksetupCmd help() => token('-help');

  /// Adds a bare argument: an address, a server, a state.
  NetworksetupCmd arg(String value) => token(value);
}

// ignore: non_constant_identifier_names
NetworksetupCmd get Networksetup => NetworksetupCmd();
