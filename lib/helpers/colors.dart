part of 'helpers.dart';

const Color kColorPrimary = Color(0xff006e5b);
const Color kColorPrimaryDark = Color(0xff006e5b);

const Color kColorFocus = Color(0xff006e5b);

const Color kBackgroundScaffold = Color(0xFF161514);

const Color kColorBack = Color(0xFF171A1D); //800
const Color kColorBackDark = Color(0xFF131518); //900

const Color kColorCardLight = Color(0xFF1D2024); //700
const Color kColorCardDark = Color(0xFF23272B); //600
const Color kColorCardDarkness = Color(0xFF100E15);

const Color kColorHint = Color(0xFF272B30); //500
const Color kColorHintGrey = Color(0xFF686B6E); //400
const Color kColorFontLight = Color(0xFFE9EAEA); //100

const Color kColorOffer = Color(0xff00b294);

BoxDecoration kDecorBackground = const BoxDecoration(
  gradient: LinearGradient(
    colors: [kColorBackDark, kColorBack],
  ),
);

BoxDecoration kDecorColors = const BoxDecoration(
  gradient: LinearGradient(
    colors: [kColorPrimary, kColorPrimaryDark],
  ),
);

BoxDecoration kDecorIconCircle = const BoxDecoration(
  shape: BoxShape.circle,
  gradient: LinearGradient(
    colors: [kColorPrimaryDark, kColorPrimary],
  ),
);

/*
const Color kColorPrimary = Color(0xFFEF233C);
const Color kColorPrimaryDark = Color(0xFFB31A2D);

const Color kColorFocus = Color(0xFFD72036);

const Color kColorBack = Color(0xFF131518);
const Color kColorBackDark = Color(0xFF171A1D);

const Color kColorCardLight = Color(0xFF272B30);
const Color kColorCardDark = Color(0xFF1D2024);
const Color kColorCardDarkness = Color(0xFF131518);
 */
