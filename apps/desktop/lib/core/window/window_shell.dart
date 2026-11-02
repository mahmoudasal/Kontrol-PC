/// The app's own window. Presentation talks to this, never to a windowing
/// plugin directly, so other platforms and the tray can swap behavior.
abstract interface class WindowShell {
  /// Applies the frameless, fixed-size frame. Call once before `runApp`.
  void configure();

  /// Starts an OS move of the window from the current pointer press.
  void startDragging();

  void minimize();

  /// Interim: quits the app. Becomes hide-to-tray when the tray lands.
  void close();

  /// Shows and focuses the window (reserved for the tray).
  void show();
}
