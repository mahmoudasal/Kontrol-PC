import 'package:flutter/material.dart';

/// Temporary stub for routes whose features do not exist yet.
///
/// Remove it when the /devices and /pair features land.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(title)));
  }
}
