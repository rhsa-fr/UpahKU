import 'package:flutter/material.dart';

/// Type system "Ledger Lapangan".
///
/// Space Grotesk untuk display, IBM Plex Sans untuk body, IBM Plex Mono untuk
/// semua angka. Ketiganya dibundel offline di `assets/fonts`.
class AppTypography {
  AppTypography._();

  static const String displayFamily = 'SpaceGrotesk';
  static const String fontFamily = 'IBMPlexSans';
  static const String monoFamily = 'IBMPlexMono';

  static const TextStyle displayLg = TextStyle(
    fontFamily: displayFamily,
    fontSize: 34,
    height: 40 / 34,
    letterSpacing: -0.8,
    fontWeight: FontWeight.w700,
    fontVariations: <FontVariation>[FontVariation('wght', 700)],
  );

  static const TextStyle headlineLg = TextStyle(
    fontFamily: displayFamily,
    fontSize: 30,
    height: 36 / 30,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w600,
    fontVariations: <FontVariation>[FontVariation('wght', 600)],
  );

  static const TextStyle headlineLgMobile = TextStyle(
    fontFamily: displayFamily,
    fontSize: 24,
    height: 30 / 24,
    letterSpacing: -0.4,
    fontWeight: FontWeight.w600,
    fontVariations: <FontVariation>[FontVariation('wght', 600)],
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: displayFamily,
    fontSize: 20,
    height: 26 / 20,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
    fontVariations: <FontVariation>[FontVariation('wght', 600)],
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: displayFamily,
    fontSize: 17,
    height: 24 / 17,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    fontVariations: <FontVariation>[FontVariation('wght', 600)],
  );

  static const TextStyle currencyDisplay = TextStyle(
    fontFamily: monoFamily,
    fontSize: 32,
    height: 38 / 32,
    letterSpacing: -0.6,
    fontWeight: FontWeight.w600,
    fontFeatures: tabular,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    fontVariations: <FontVariation>[FontVariation('wght', 400)],
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    fontVariations: <FontVariation>[FontVariation('wght', 400)],
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    height: 18 / 13,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w600,
    fontVariations: <FontVariation>[FontVariation('wght', 600)],
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    height: 16 / 11,
    letterSpacing: 0.3,
    fontWeight: FontWeight.w600,
    fontVariations: <FontVariation>[FontVariation('wght', 600)],
  );

  /// Label teknis: uppercase, mono, lebar.
  static const TextStyle monoLabel = TextStyle(
    fontFamily: monoFamily,
    fontSize: 9.5,
    height: 14 / 9.5,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w500,
    fontFeatures: tabular,
  );

  /// Angka besar untuk hero/stat.
  static const TextStyle monoValue = TextStyle(
    fontFamily: monoFamily,
    fontSize: 22,
    height: 26 / 22,
    letterSpacing: -0.3,
    fontWeight: FontWeight.w600,
    fontFeatures: tabular,
  );

  /// Tabular figures so currency/timer readouts never jitter.
  static const List<FontFeature> tabular = <FontFeature>[FontFeature.tabularFigures()];
}
