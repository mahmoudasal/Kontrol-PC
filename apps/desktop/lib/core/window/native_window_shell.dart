import 'package:flutter/painting.dart';
import 'package:window_manager/window_manager.dart';

import 'window_shell.dart';

/// [WindowShell] backed by window_manager's native `Window`.
class NativeWindowShell implements WindowShell {
  NativeWindowShell(this._window);

  /// The window this Flutter engine runs in.
  factory NativeWindowShell.current() {
    final window = WindowManager.instance.getCurrent();
    if (window == null) throw StateError('No native window for this app.');
    return NativeWindowShell(window);
  }

  static const Size contentSize = Size(820, 560);
  static const Color background = Color(0xFF0B0C0E);

  final Window _window;

  @override
  void configure() {
    _window
      ..title = 'Kontrol Server'
      ..titleBarStyle = TitleBarStyle.hidden
      ..backgroundColor = background.toNative()
      ..isResizable = false
      ..isMaximizable = false
      ..contentSize = contentSize.toNative()
      ..center();
  }

  @override
  void startDragging() => _window.startDragging();

  @override
  void minimize() => _window.minimize();

  @override
  void close() => _window.close();

  @override
  void show() {
    _window
      ..show()
      ..focus();
  }
}
