import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kontrol_desktop/features/server/data/datasources/host_info_data_source.dart';

/// Real address semantics; only the interface metadata is faked.
class _Addr implements InterfaceAddress {
  _Addr(String ip) : _inner = InternetAddress(ip);

  final InternetAddress _inner;

  @override
  String get address => _inner.address;

  @override
  InternetAddressType get type => _inner.type;

  @override
  bool get isLoopback => _inner.isLoopback;

  @override
  bool get isLinkLocal => _inner.isLinkLocal;

  @override
  int get prefixLength => 24;

  @override
  InternetAddress? get broadcast => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Iface implements NetworkInterface {
  _Iface(this.name, List<String> ips) : addresses = ips.map(_Addr.new).toList();

  @override
  final String name;

  @override
  final List<InterfaceAddress> addresses;

  @override
  int get index => 0;
}

HostInfoDataSource _source(List<NetworkInterface> ifaces) => HostInfoDataSource(
  listInterfaces: () async => ifaces,
  hostname: () => 'LIVING-ROOM-PC',
  port: 7531,
);

void main() {
  test('returns hostname, address, port and adapter name', () async {
    final info = await _source([
      _Iface('Wi-Fi', ['192.168.1.24']),
    ]).getHostInfo();
    expect(info.pcName, 'LIVING-ROOM-PC');
    expect(info.address, '192.168.1.24');
    expect(info.port, 7531);
    expect(info.networkName, 'Wi-Fi');
  });

  test('skips virtual adapters', () async {
    final info = await _source([
      _Iface('vEthernet (WSL)', ['172.20.0.1']),
      _Iface('Ethernet', ['10.0.0.5']),
    ]).getHostInfo();
    expect(info.networkName, 'Ethernet');
  });

  test('prefers a private address over a public one', () async {
    final info = await _source([
      _Iface('Cellular', ['100.64.3.2']),
      _Iface('Wi-Fi', ['192.168.0.9']),
    ]).getHostInfo();
    expect(info.address, '192.168.0.9');
  });

  test('skips link-local addresses', () async {
    final info = await _source([
      _Iface('Wi-Fi', ['169.254.10.1', '10.1.2.3']),
    ]).getHostInfo();
    expect(info.address, '10.1.2.3');
  });

  test('falls back to a public address when no private one exists', () async {
    final info = await _source([
      _Iface('Ethernet', ['100.64.3.2']),
    ]).getHostInfo();
    expect(info.address, '100.64.3.2');
  });

  test('throws StateError when no usable interface exists', () {
    expect(_source([]).getHostInfo(), throwsStateError);
  });
}
