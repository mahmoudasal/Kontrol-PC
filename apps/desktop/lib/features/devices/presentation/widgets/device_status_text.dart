import '../../domain/entities/paired_device.dart';

/// "Connected now · Android" / "Last seen 3 days ago · iOS".
String deviceStatusText(PairedDevice device, DateTime now) {
  final platform = switch (device.platform) {
    DevicePlatform.android => 'Android',
    DevicePlatform.ios => 'iOS',
  };
  final presence = switch (device.presence) {
    DeviceConnected() => 'Connected now',
    DeviceLastSeen(:final at) => 'Last seen ${_ago(now.difference(at))}',
  };
  return '$presence · $platform';
}

String _ago(Duration d) {
  if (d.inMinutes < 1) return 'just now';
  if (d.inHours < 1) return _plural(d.inMinutes, 'minute');
  if (d.inDays < 1) return _plural(d.inHours, 'hour');
  if (d.inDays == 1) return 'yesterday';
  return _plural(d.inDays, 'day');
}

String _plural(int n, String unit) => '$n $unit${n == 1 ? '' : 's'} ago';
