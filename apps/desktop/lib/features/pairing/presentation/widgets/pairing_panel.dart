import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kontrol_ui/kontrol_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../cubit/pairing_cubit.dart';
import '../cubit/pairing_state.dart';
import 'qr_code_view.dart';

/// QR code beside the PIN and its countdown.
class PairingPanel extends StatelessWidget {
  const PairingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: KontrolSpacing.s16,
      children: [
        BlocSelector<PairingCubit, PairingState, String?>(
          selector: (state) => switch (state) {
            PairingReady(:final code) => code.qrPayload,
            _ => null,
          },
          builder: (context, payload) => QrCodeView(payload: payload),
        ),
        const Expanded(child: _PinColumn()),
      ],
    );
  }
}

class _PinColumn extends StatelessWidget {
  const _PinColumn();

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: KontrolSpacing.s6,
      children: [
        Text(
          'OR ENTER PIN',
          style: KontrolTypography.sectionLabel.copyWith(color: c.text3),
        ),
        BlocSelector<PairingCubit, PairingState, String?>(
          selector: (state) => switch (state) {
            PairingReady(:final code) => code.pin,
            _ => null,
          },
          builder: (context, pin) => _Pin(pin: pin),
        ),
        const _CountdownRow(),
      ],
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.pin});

  final String? pin;

  @override
  Widget build(BuildContext context) {
    final pin = this.pin;
    final text = pin == null
        ? '––– –––'
        : '${pin.substring(0, 3)} ${pin.substring(3)}';
    return Semantics(
      label: pin == null ? 'PIN loading' : 'PIN ${pin.split('').join(' ')}',
      excludeSemantics: true,
      child: Text(
        text,
        style: KontrolTypography.monoDisplay.copyWith(
          color: context.kColors.text,
        ),
      ),
    );
  }
}

class _CountdownRow extends StatelessWidget {
  const _CountdownRow();

  @override
  Widget build(BuildContext context) {
    final c = context.kColors;
    final style = KontrolTypography.caption.copyWith(
      color: c.text3,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return Row(
      spacing: KontrolSpacing.s4,
      children: [
        Flexible(
          child: BlocBuilder<PairingCubit, PairingState>(
            builder: (context, state) => Text(
              switch (state) {
                PairingLoading() => 'Creating a code…',
                PairingReady(:final remaining) =>
                  'New code in ${formatCountdown(remaining)}',
                PairingFailed(:final message) => message,
              },
              style: state is PairingFailed
                  ? style.copyWith(color: c.dangerText)
                  : style,
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.read<PairingCubit>().regenerate(),
          tooltip: 'New code now',
          iconSize: 14,
          color: c.accentText,
          style: IconButton.styleFrom(
            fixedSize: const Size.square(28),
            minimumSize: const Size.square(28),
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(KontrolRadii.r8),
            ),
          ),
          icon: const Icon(LucideIcons.refreshCcw),
        ),
      ],
    );
  }
}

/// `m:ss`, rounding up so the label never shows 0:00 while still valid.
String formatCountdown(Duration remaining) {
  final seconds = (remaining.inMilliseconds / 1000).ceil();
  final m = seconds ~/ 60;
  final s = (seconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}
