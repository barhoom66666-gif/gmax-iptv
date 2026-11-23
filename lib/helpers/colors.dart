part of 'helpers.dart';

const Color kColorPrimary = Color(0xFFD5B055);
const Color kColorPrimaryDark = Color(0xFF9A711C);

const Color kColorFocus = Color(0xFFE5C158);

const Color kBackgroundScaffold = Color(0xFF0A0D12);

const Color kColorBack = Color(0xFF141E27); //800
const Color kColorBackDark = Color(0xFF090C10); //900

const Color kColorCardLight = Color(0xFF23303A); //700
const Color kColorCardDark = Color(0xFF1B252D); //600
const Color kColorCardDarkness = Color(0xFF0D1217);

const Color kColorHint = Color(0xFF27343F); //500
const Color kColorHintGrey = Color(0xFF8A949E); //400
const Color kColorFontLight = Color(0xFFF2F4F6); //100

const Color kColorOffer = Color(0xFFE5C158);

BoxDecoration kDecorBackground = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF090C10),
      Color(0xFF18222B),
      Color(0xFF231B0E),
      Color(0xFF0B0F14),
    ],
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
