import 'package:flutter/material.dart';

/// UpahKu design tokens — "Ledger Lapangan".
///
/// Satu sumber kebenaran untuk warna, spacing, radius, dan elevasi.
/// Semua layar memakai token ini; tidak ada hex ad-hoc di widget.
class AppColors {
  AppColors._();

  // ── Brand anchors ─────────────────────────────────────────────────────
  static const Color ink = Color(0xFF101826);
  static const Color paper = Color(0xFFF6F3EC);
  static const Color amber = Color(0xFFE3A72F);
  static const Color amberInk = Color(0xFF241A04);
  static const Color panel = Color(0xFF101826);
  static const Color panelDark = Color(0xFF151D28);

  static const Color brandTeal = Color(0xFF1F7A5A);
  static const Color brandMint = Color(0xFFE3A72F);
  static const Color brandNavy = Color(0xFF101826);

  // ── Light scheme ──────────────────────────────────────────────────────
  static const Color primaryLight = ink;
  static const Color onPrimaryLight = paper;
  static const Color primaryContainerLight = Color(0xFF1C2639);
  static const Color onPrimaryContainerLight = paper;
  static const Color primaryFixedLight = Color(0xFFDED7C8);
  static const Color primaryFixedDimLight = Color(0xFFCFC5B0);

  static const Color secondaryLight = amber;
  static const Color onSecondaryLight = amberInk;
  static const Color secondaryContainerLight = Color(0xFFFBEFD2);
  static const Color onSecondaryContainerLight = amberInk;
  static const Color secondaryFixedLight = Color(0xFFF7D98F);
  static const Color secondaryFixedDimLight = amber;

  static const Color tertiaryLight = Color(0xFF1F7A5A);
  static const Color onTertiaryLight = Color(0xFFFFFFFF);
  static const Color tertiaryContainerLight = Color(0xFFDFF1E9);
  static const Color onTertiaryContainerLight = Color(0xFF0B3B2C);
  static const Color tertiaryFixedLight = Color(0xFFC9EADF);
  static const Color tertiaryFixedDimLight = Color(0xFF8FD3BC);

  static const Color errorLight = Color(0xFFB23A2E);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFF7E1DE);
  static const Color onErrorContainerLight = Color(0xFF5C140D);

  static const Color backgroundLight = paper;
  static const Color onBackgroundLight = ink;
  static const Color surfaceLight = paper;
  static const Color onSurfaceLight = ink;
  static const Color surfaceDimLight = Color(0xFFE8E2D5);
  static const Color surfaceBrightLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFEDE8DC);
  static const Color onSurfaceVariantLight = Color(0xFF6E6656);
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowLight = Color(0xFFFBF9F4);
  static const Color surfaceContainerLight = Color(0xFFF1EDE3);
  static const Color surfaceContainerHighLight = Color(0xFFE8E2D5);
  static const Color surfaceContainerHighestLight = Color(0xFFDED7C8);
  static const Color outlineLight = Color(0xFF8C8474);
  static const Color outlineVariantLight = Color(0xFFE3DCCC);
  static const Color surfaceTintLight = ink;
  static const Color inverseSurfaceLight = ink;
  static const Color inverseOnSurfaceLight = paper;
  static const Color inversePrimaryLight = amber;

  // ── Dark scheme ───────────────────────────────────────────────────────
  static const Color primaryDark = Color(0xFFF2B93B);
  static const Color onPrimaryDark = Color(0xFF1A1204);
  static const Color primaryContainerDark = Color(0xFF3A2E12);
  static const Color onPrimaryContainerDark = Color(0xFFF2B93B);

  static const Color secondaryDark = Color(0xFFF2B93B);
  static const Color onSecondaryDark = Color(0xFF1A1204);
  static const Color secondaryContainerDark = Color(0xFF3A2E12);
  static const Color onSecondaryContainerDark = Color(0xFFF2B93B);

  static const Color tertiaryDark = Color(0xFF57C79B);
  static const Color onTertiaryDark = Color(0xFF062018);
  static const Color tertiaryContainerDark = Color(0xFF12362A);
  static const Color onTertiaryContainerDark = Color(0xFFA9E8D3);

  static const Color errorDark = Color(0xFFEE7A6C);
  static const Color onErrorDark = Color(0xFF2A0B08);
  static const Color errorContainerDark = Color(0xFF5A1D17);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  static const Color backgroundDark = Color(0xFF0D131C);
  static const Color onBackgroundDark = Color(0xFFEFE9DC);
  static const Color surfaceDark = Color(0xFF0D131C);
  static const Color onSurfaceDark = Color(0xFFEFE9DC);
  static const Color surfaceVariantDark = Color(0xFF232D3A);
  static const Color onSurfaceVariantDark = Color(0xFF98A1B0);
  static const Color surfaceContainerLowestDark = Color(0xFF0A0F16);
  static const Color surfaceContainerLowDark = Color(0xFF111823);
  static const Color surfaceContainerDark = Color(0xFF151D28);
  static const Color surfaceContainerHighDark = Color(0xFF1B2431);
  static const Color surfaceContainerHighestDark = Color(0xFF232D3A);
  static const Color outlineDark = Color(0xFF6C7684);
  static const Color outlineVariantDark = Color(0xFF28323F);
  static const Color inverseSurfaceDark = Color(0xFFEFE9DC);
  static const Color inverseOnSurfaceDark = Color(0xFF101826);
  static const Color inversePrimaryDark = Color(0xFF101826);

  // ── Semantic accents ──────────────────────────────────────────────────
  static const Color success = Color(0xFF1F7A5A);
  static const Color successSoft = Color(0xFFDFF1E9);
  static const Color onSuccessSoft = Color(0xFF0B3B2C);
  static const Color warning = Color(0xFFA9701A);
  static const Color warningSoft = Color(0xFFFBEBD2);
  static const Color onWarningSoft = Color(0xFF6B4900);
  static const Color danger = Color(0xFFB23A2E);
  static const Color dangerSoft = Color(0xFFF7E1DE);
  static const Color onDangerSoft = Color(0xFF5C140D);
  static const Color info = Color(0xFF2C5C8A);
  static const Color infoSoft = Color(0xFFE1ECF7);
  static const Color onInfoSoft = Color(0xFF12314D);
}

/// 8pt modular spacing scale.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Horizontal screen gutter.
  static const double margin = 16;

  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: margin);
  static const EdgeInsets card = EdgeInsets.all(md);
  static const EdgeInsets listGap = EdgeInsets.only(bottom: md);
}

/// Corner radii.
class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 14;
  static const double xl = 22;
  static const double pill = 9999;

  static const BorderRadius rSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius rMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius rLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius rXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius rPill = BorderRadius.all(Radius.circular(pill));
}

/// Soft ambient elevation. Borders carry most of the separation.
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> level1 = [
    BoxShadow(color: Color(0x0A101826), blurRadius: 2, offset: Offset(0, 1)),
    BoxShadow(color: Color(0x08101826), blurRadius: 10, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> level2 = [
    BoxShadow(color: Color(0x14101826), blurRadius: 28, offset: Offset(0, 12)),
    BoxShadow(color: Color(0x08101826), blurRadius: 6, offset: Offset(0, 2)),
  ];

  static List<BoxShadow> forBrightness(Brightness b) => b == Brightness.dark
      ? const [
          BoxShadow(color: Color(0x66000000), blurRadius: 4, offset: Offset(0, 1)),
          BoxShadow(color: Color(0x4D000000), blurRadius: 18, offset: Offset(0, 8)),
        ]
      : level1;
}
