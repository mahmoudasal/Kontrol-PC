/// All onboarding strings. Move to ARB files when localization lands.
abstract final class OnboardingCopy {
  static const brand = 'Kontrol';
  static const skip = 'Skip';
  static const next = 'Next';
  static const findMyPc = 'Find my PC';
  static const scanQrInstead = 'Scan QR code instead';

  static String stepLabel(int page, int count) => 'Step ${page + 1} of $count';

  // Slide 1
  static const welcomeTitle = 'Your phone is now the remote.';
  static const welcomeBody =
      'Move the mouse, type, play media and put your PC to sleep '
      '— over your home Wi-Fi. No cables, no account.';

  // Slide 2
  static const installTitle = 'Install Kontrol Server on your PC.';
  static const installBody = 'Free and open source. Windows 10 and 11.';
  static const copyLink = 'Copy link';
  static const shareLink = 'Share link to PC';
  static const linkCopied = 'Link copied';
  static const copyFailed = "Couldn't copy the link.";
  static const shareFailed = "Couldn't open the share sheet.";

  // Slide 3
  static const connectTitle = 'Find your PC on this Wi-Fi.';
  static const networkCardTitle = 'Next, allow local network access';
  static const networkCardBody =
      'Kontrol only talks to devices on your Wi-Fi. '
      'Nothing goes to the internet.';

  static const saveFailed =
      "Couldn't save your progress. You may see this intro again.";
}
