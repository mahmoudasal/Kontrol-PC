import 'package:flutter/material.dart';
import 'package:kontrol_ui/kontrol_ui.dart';

/// 40×24 pill switch from the Server design (Material's Switch is 52×32).
class CompactSwitch extends StatelessWidget {
  const CompactSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  static const _duration = Duration(milliseconds: 150);

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final onChanged = this.onChanged;
    return Semantics(
      label: semanticLabel,
      toggled: value,
      enabled: onChanged != null,
      onTap: onChanged == null ? null : () => onChanged(!value),
      excludeSemantics: true,
      child: MouseRegion(
        cursor: onChanged == null
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onChanged == null ? null : () => onChanged(!value),
          child: AnimatedContainer(
            duration: _duration,
            width: 40,
            height: 24,
            // The 1px off-state border adds padding; keep the thumb 20×20.
            padding: EdgeInsets.all(value ? 2 : 1),
            decoration: BoxDecoration(
              color: value ? c.accent : c.surface2,
              borderRadius: BorderRadius.circular(KontrolRadii.pill),
              border: value ? null : Border.all(color: c.borderStrong),
            ),
            child: AnimatedAlign(
              duration: _duration,
              alignment: value
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: value ? c.onAccent : c.text2,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
