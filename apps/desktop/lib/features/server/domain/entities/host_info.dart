/// How phones reach this PC on the LAN.
class HostInfo {
  final String pcName;
  final String address;
  final int port;

  /// Adapter name ("Wi-Fi", "Ethernet") until SSID lookup lands.
  final String? networkName;

  const HostInfo({
    required this.pcName,
    required this.address,
    required this.port,
    this.networkName,
  });

  @override
  bool operator ==(Object other) =>
      other is HostInfo &&
      other.pcName == pcName &&
      other.address == address &&
      other.port == port &&
      other.networkName == networkName;

  @override
  int get hashCode => Object.hash(pcName, address, port, networkName);
}
