import 'dart:io';

import '../../domain/entities/host_info.dart';

/// Lists the machine's network interfaces. Injected so selection is testable.
typedef InterfaceLister = Future<List<NetworkInterface>> Function();

Future<List<NetworkInterface>> listIpv4Interfaces() => NetworkInterface.list(
  type: InternetAddressType.IPv4,
  includeLoopback: false,
  includeLinkLocal: false,
);

class HostInfoDataSource {
  final InterfaceLister _listInterfaces;
  final String Function() _hostname;
  final int _port;

  HostInfoDataSource({
    required this._listInterfaces,
    required this._hostname,
    required this._port,
  });

  /// Virtual adapters (WSL, Hyper-V, VMs, VPNs) are rarely reachable from a
  /// phone on the same Wi-Fi.
  static const _virtualPrefixes = [
    'vethernet',
    'virtualbox',
    'vmware',
    'docker',
    'tailscale',
    'zerotier',
    'loopback',
  ];

  /// Throws [StateError] when no usable IPv4 address exists.
  Future<HostInfo> getHostInfo() async {
    final candidates = <(NetworkInterface, InternetAddress)>[
      for (final iface in await _listInterfaces())
        if (!_isVirtual(iface.name))
          for (final address in iface.addresses)
            if (address.type == InternetAddressType.IPv4 &&
                !address.isLoopback &&
                !address.isLinkLocal)
              (iface, address),
    ];
    if (candidates.isEmpty) throw StateError('No IPv4 network interface.');

    final (iface, address) = candidates.firstWhere(
      (c) => _isPrivate(c.$2.address),
      orElse: () => candidates.first,
    );
    return HostInfo(
      pcName: _hostname(),
      address: address.address,
      port: _port,
      networkName: iface.name,
    );
  }

  static bool _isVirtual(String name) {
    final lower = name.toLowerCase();
    return _virtualPrefixes.any(lower.startsWith);
  }

  static bool _isPrivate(String ip) {
    final parts = ip.split('.').map(int.tryParse).toList();
    if (parts.length != 4 || parts.contains(null)) return false;
    final a = parts[0]!, b = parts[1]!;
    return a == 10 ||
        (a == 172 && b >= 16 && b <= 31) ||
        (a == 192 && b == 168);
  }
}
