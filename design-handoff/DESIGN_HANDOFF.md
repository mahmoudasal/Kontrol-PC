# Kontrol — design handoff for Claude Code

Put this file and the `design/` folder at the root of the Flutter repo.
Add one line to `CLAUDE.md`: `UI spec: see DESIGN_HANDOFF.md and design/project/.`

## How to read `design/project/*.dc.html`

- Each file is one screen (artboard). The **inline `style="…"` values are the spec**: sizes, paddings, radii, colors, font sizes.
- Ignore `support.js`, `<x-dc>`, `<helmet>`, `<sc-if>`, `<sc-for>`: that's the design tool's runtime, not app code.
- The `<script type="text/x-dc">` block at the bottom holds **theme tokens and state variants** (`renderVals()`): dark/light palettes, status chip variants, PIN states, etc.
- Tiny files that only contain `<dc-import name="X" prop="…">` are **variants** of screen X (e.g. `Home-Light` = `Main` with `theme="light"`).
- `canvas.json` lists every screen with its title.
- Units: CSS px = Flutter logical px (dp). Phone frame is 390×844.

## Screen map → suggested routes

| Design file | Screen | Route / widget |
|---|---|---|
| Onboarding (+ -Install, -Connect) | 3-slide onboarding, `step` 1–3 | `/onboarding` (PageView) |
| Devices (+ -Empty) | LAN discovery list, empty state | `/devices` |
| Pair (+ Pair-PIN) | QR scanner / 6-digit PIN; states enter·pairing·failed·success | `/pair` |
| Main (+ Home-Light) | Home remotes grid; `status` connected·reconnecting·offline | `/` |
| Touchpad (+ -Light, -Sheet, -Landscape) | Trackpad, scroll strip, click buttons, keyboard sheet | `/touchpad` |
| Keyboard | Live text, modifiers, arrows, F-keys, shortcuts | `/keyboard` |
| Media | Transport, volume, fullscreen | `/media` |
| Power (+ Power-Hold) | Lock/Sleep instant; Restart/Log off/Shutdown hold-to-confirm; timer | `/power` |
| Presentation | Prev/Next, black screen, laser (gyro) | `/presentation` |
| Settings | Grouped settings list | `/settings` |
| Server-Main / Server-Tray / Server-Approval | Windows desktop server | separate Flutter desktop app |
| States | Reconnecting, lost, not found, Wi-Fi off, camera denied, skeleton | shared widgets |
| Components | Tokens + component reference | `lib/theme/` + `lib/widgets/` |
| Icons | 3 app-icon concepts (SVG inline) | pick one → `flutter_launcher_icons` |

## Tokens

### Dark (default)
| Token | Hex |
|---|---|
| bg | `#0B0C0E` |
| surface | `#15171B` (touchpad pad `#121418`, sheet `#181B20`) |
| surface2 | `#1E2127` |
| border | `#262A31` |
| text | `#F2F4F7` |
| text2 | `#A3AAB6` |
| text3 | `#8A919E` |
| accent | `#4C8DFF` (teal alt `#2DD4BF`) |
| onAccent | `#05101F` — dark text on accent; white fails AA |
| accentSoft | accent @ 12% · accentText `#8DB6FF` |
| success | dot `#3DDC97`, text `#5BE3A8`, bg @ 12% |
| warning | dot `#F5B544`, text `#F7C66B`, bg @ 14% |
| danger | `#FF6B5E`, text `#FF8A80` / `#FFB3AC`, bg @ 10% |

### Light
bg `#F4F5F7` · surface `#FFFFFF` · surface2 `#EBEDF1` · border `#DCE0E6` · text `#0E1116` · text2 `#4A5260` · text3 `#5F6775` · accent `#1F5FD6` (teal `#0B7A70`) · onAccent `#FFFFFF` · success text `#0B6E44` · warning text `#7A4A00`

### Type
Inter (Latin), IBM Plex Sans Arabic (RTL), JetBrains Mono (IPs, PINs, F-keys, shortcuts).
Display 30/700 · Screen title 28/700 · Tile title 22/600 · Heading 17/600 · Body 15–16/400–500 · Caption 13 · Section label 12/600 uppercase, letter-spacing 0.06em.

### Shape & spacing
Radius: 10–12 keys · 14 buttons/icon buttons · 20 tiles/cards · 22–26 hero tiles/sheets · 999 chips/switches.
Screen padding 16–20 horizontal; gaps 8 / 10 / 12 / 20.

## Component → Flutter

| Design | Flutter |
|---|---|
| Remote tile | `InkWell` in `Material` with `RoundedRectangleBorder(20)`; long-press → `ReorderableGridView` |
| Status chip | custom `StatusChip(status)`: label + dot shape (filled / arc / ring) — never color only |
| Primary / secondary button | `FilledButton` / `OutlinedButton`, min height 48–56 |
| Icon button | `IconButton.filledTonal`, 48×48 |
| Modifier toggle | custom `ModifierKey` with off / held / locked (lock glyph + outline) |
| Key button | custom `KeyButton`, min 44×44 |
| Switch | `Switch` themed with accent |
| Segmented | `SegmentedButton` |
| Slider | `Slider` with custom `SliderTheme` (track 6–10, thumb 22–26) |
| Hold-to-confirm | `GestureDetector` long-press + `AnimationController` (1.5 s) filling the tile |
| Keyboard sheet | `showModalBottomSheet` / `DraggableScrollableSheet` |
| Snackbar | `SnackBar` light-on-dark |

Icons in designs are Lucide-style strokes → use `lucide_icons` or Material Symbols Rounded.

## Rules to keep
- Touch targets ≥ 48 dp. Thumb-reachable primary actions at the bottom.
- Connection status visible on every remote screen.
- Status never by color alone (label + dot shape).
- Restart / Shutdown / Log off use hold-to-confirm; dialog only as accessibility fallback.
- No fake status bar; respect `SafeArea`.
- Landscape: Touchpad (and Keyboard) via `OrientationBuilder`.
- RTL: all layouts with `EdgeInsetsDirectional` / `AlignmentDirectional`.

## Placeholders
`[download URL]`, `[x.y.z]` version. PC names, IPs and port 7531 are sample data.

## Starter prompt for Claude Code
> Read DESIGN_HANDOFF.md and design/project/. Create `lib/theme/kontrol_theme.dart` (dark + light `ThemeData`, Material 3, tokens above) and shared widgets (StatusChip, RemoteTile, KeyButton, ModifierKey, HoldToConfirmButton). Then build Home (Main.dc.html) and Touchpad (Touchpad.dc.html) pixel-close to the designs with go_router. Use mock connection state for now.
