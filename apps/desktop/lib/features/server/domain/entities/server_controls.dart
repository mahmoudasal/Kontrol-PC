/// User-facing switches that gate remote control.
class ServerControls {
  /// Phones stay connected but their input is ignored.
  final bool paused;

  /// First-time phones need an explicit Allow on this PC.
  final bool requireApproval;

  const ServerControls({required this.paused, required this.requireApproval});

  ServerControls copyWith({bool? paused, bool? requireApproval}) {
    return ServerControls(
      paused: paused ?? this.paused,
      requireApproval: requireApproval ?? this.requireApproval,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ServerControls &&
      other.paused == paused &&
      other.requireApproval == requireApproval;

  @override
  int get hashCode => Object.hash(paused, requireApproval);
}
