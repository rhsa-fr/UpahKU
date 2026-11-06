import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';

/// Shared building blocks that reproduce the Google Stitch "UpahKu" screens
/// in Flutter. Everything reads from the ambient [ThemeData] so light/dark
/// both work without extra branching.

enum DsTone { neutral, primary, secondary, success, warning, danger, info }

extension DsToneColors on DsTone {
  Color bg(ColorScheme s) {
    switch (this) {
      case DsTone.neutral:
        return s.surfaceContainerHigh;
      case DsTone.primary:
        return s.primaryContainer;
      case DsTone.secondary:
        return s.secondaryContainer;
      case DsTone.success:
        return AppColors.successSoft;
      case DsTone.warning:
        return AppColors.warningSoft;
      case DsTone.danger:
        return AppColors.dangerSoft;
      case DsTone.info:
        return AppColors.infoSoft;
    }
  }

  Color fg(ColorScheme s) {
    switch (this) {
      case DsTone.neutral:
        return s.onSurfaceVariant;
      case DsTone.primary:
        return s.onPrimaryContainer;
      case DsTone.secondary:
        return s.onSecondaryContainer;
      case DsTone.success:
        return AppColors.onSuccessSoft;
      case DsTone.warning:
        return AppColors.onWarningSoft;
      case DsTone.danger:
        return AppColors.onDangerSoft;
      case DsTone.info:
        return AppColors.onInfoSoft;
    }
  }

  Color accent(ColorScheme s) {
    switch (this) {
      case DsTone.neutral:
        return s.outline;
      case DsTone.primary:
        return s.primary;
      case DsTone.secondary:
        return s.onSecondaryContainer;
      case DsTone.success:
        return AppColors.success;
      case DsTone.warning:
        return AppColors.warning;
      case DsTone.danger:
        return AppColors.danger;
      case DsTone.info:
        return AppColors.info;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card surfaces
// ─────────────────────────────────────────────────────────────────────────────

/// Elevated white card, radius 16, ambient shadow — the Stitch `article` card.
class DsCard extends StatelessWidget {
  const DsCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.card,
    this.onTap,
    this.color,
    this.borderRadius = AppRadius.lg,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget content = Padding(padding: padding, child: child);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: AppShadows.forBrightness(theme.brightness),
      ),
      child: onTap == null
          ? content
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(borderRadius),
                child: content,
              ),
            ),
    );
  }
}

/// Recessed panel used to group fields inside a card (`surface-container-low`).
class DsInset extends StatelessWidget {
  const DsInset({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.sm + 4),
    this.borderRadius = AppRadius.sm,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: s.surfaceContainerLow,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}

/// Section wrapper: uppercase eyebrow label + optional trailing action.
class DsSectionHeader extends StatelessWidget {
  const DsSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.margin,
      AppSpacing.lg,
      AppSpacing.margin,
      AppSpacing.sm,
    ),
  });

  final String title;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: s.primary),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: AppTypography.labelMd.copyWith(
                color: s.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pills / badges / avatars
// ─────────────────────────────────────────────────────────────────────────────

class DsPill extends StatelessWidget {
  const DsPill({
    super.key,
    required this.label,
    this.tone = DsTone.neutral,
    this.icon,
    this.dot = false,
    this.dense = false,
  });

  final String label;
  final DsTone tone;
  final IconData? icon;
  final bool dot;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 6 : 10,
        vertical: dense ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: tone.bg(s),
        borderRadius: AppRadius.rPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: tone.accent(s), shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          if (icon != null) ...[
            Icon(icon, size: dense ? 12 : 14, color: tone.fg(s)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.labelMd.copyWith(
              color: tone.fg(s),
              fontSize: dense ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

class DsAvatar extends StatelessWidget {
  const DsAvatar({super.key, required this.initials, this.size = 44, this.image});

  final String initials;
  final double size;
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: s.primaryContainer.withValues(alpha: 0.35),
      ),
      alignment: Alignment.center,
      child: image ??
          Text(
            initials,
            style: AppTypography.labelMd.copyWith(
              color: s.primary,
              fontSize: size * 0.34,
              fontWeight: FontWeight.w700,
            ),
          ),
    );
  }
}

/// Derives "BS" from "Budi Santoso".
String initialsOf(String name) {
  final List<String> parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
}

// ─────────────────────────────────────────────────────────────────────────────
// Stats
// ─────────────────────────────────────────────────────────────────────────────

/// One cell of the Stitch bento grid: label on top, value below.
class DsStatTile extends StatelessWidget {
  const DsStatTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.valueColor,
  });

  final String label;
  final String value;
  final String? unit;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return DsInset(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMd.copyWith(color: s.outline),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: AppTypography.titleMd.copyWith(
                    color: valueColor ?? s.onSurface,
                    fontWeight: FontWeight.w700,
                    fontFeatures: AppTypography.tabular,
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 3),
                  Text(
                    unit!,
                    style: AppTypography.labelMd.copyWith(color: s.outline),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact counters row: icon + label + big number, tinted by status.
class DsCounterChip extends StatelessWidget {
  const DsCounterChip({
    super.key,
    required this.label,
    required this.value,
    required this.tone,
    this.icon,
  });

  final String label;
  final int value;
  final DsTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: tone.bg(s),
        borderRadius: AppRadius.rMd,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: tone.fg(s)),
            const SizedBox(height: 2),
          ],
          Text(
            '$value',
            style: AppTypography.titleMd.copyWith(
              color: tone.fg(s),
              fontWeight: FontWeight.w700,
              fontFeatures: AppTypography.tabular,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMd.copyWith(color: tone.fg(s)),
          ),
        ],
      ),
    );
  }
}

/// Large money readout with caption, tinted by [tone].
class DsMoneyTile extends StatelessWidget {
  const DsMoneyTile({
    super.key,
    required this.label,
    required this.amount,
    this.tone = DsTone.primary,
    this.icon,
  });

  final String label;
  final String amount;
  final DsTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return DsInset(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: tone.accent(s)),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            amount,
            style: AppTypography.titleMd.copyWith(
              color: tone.accent(s),
              fontWeight: FontWeight.w700,
              fontFeatures: AppTypography.tabular,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Inputs / controls
// ─────────────────────────────────────────────────────────────────────────────

/// 48px rounded-12 white search field matching the Stitch search bar.
class DsSearchField extends StatelessWidget {
  const DsSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Cari...',
    this.onFilterTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTypography.bodyMd,
              decoration: InputDecoration(
                hintText: hintText,
                isDense: true,
                filled: true,
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, _) => value.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            controller.clear();
                            onChanged('');
                          },
                        ),
                ),
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: AppSpacing.sm),
          DsIconButton(icon: Icons.tune_rounded, onTap: onFilterTap!),
        ],
      ],
    );
  }
}

/// 48×48 white rounded-12 square button.
class DsIconButton extends StatelessWidget {
  const DsIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 48,
    this.iconSize = 20,
    this.color,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final Widget button = Material(
      color: s.surfaceContainerLowest,
      borderRadius: AppRadius.rMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMd,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: AppRadius.rMd,
            boxShadow: AppShadows.level1,
          ),
          child: Icon(icon, size: iconSize, color: color ?? s.primary),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

/// −/+ stepper used for lembur hours (0.5 increments).
class DsStepper extends StatelessWidget {
  const DsStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 0.5,
    this.min = 0,
    this.max = 12,
    this.suffix = 'Jam',
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double step;
  final double min;
  final double max;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    final String text =
        value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(1);

    Widget round(String glyph, VoidCallback? onTap) {
      return Material(
        color: s.surfaceContainerLow,
        borderRadius: AppRadius.rSm,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.rSm,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(
              glyph == '-' ? Icons.remove_rounded : Icons.add_rounded,
              size: 18,
              color: onTap == null ? s.outlineVariant : s.onSurface,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        round('-', value <= min ? null : () => onChanged((value - step).clamp(min, max))),
        SizedBox(
          width: 76,
          child: Text(
            '$text $suffix',
            textAlign: TextAlign.center,
            style: AppTypography.titleMd.copyWith(
              color: s.onSurface,
              fontWeight: FontWeight.w700,
              fontFeatures: AppTypography.tabular,
            ),
          ),
        ),
        round('+', value >= max ? null : () => onChanged((value + step).clamp(min, max))),
      ],
    );
  }
}

/// Horizontally scrollable filter chips with a filled active state.
class DsChipBar extends StatelessWidget {
  const DsChipBar({super.key, required this.labels, required this.selectedIndex, required this.onSelected});

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final bool active = i == selectedIndex;
          return Material(
            color: active ? s.primary : s.surfaceContainerHigh,
            borderRadius: AppRadius.rPill,
            child: InkWell(
              onTap: () => onSelected(i),
              borderRadius: AppRadius.rPill,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                  child: Text(
                    labels[i],
                    style: AppTypography.labelMd.copyWith(
                      color: active ? s.onPrimary : s.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty / loading
// ─────────────────────────────────────────────────────────────────────────────

class DsEmptyState extends StatelessWidget {
  const DsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: s.surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: s.outline),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.titleMd.copyWith(color: s.onSurface),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd.copyWith(color: s.onSurfaceVariant),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class DsLoading extends StatelessWidget {
  const DsLoading({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.6, color: s.primary),
          ),
          if (label != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(label!, style: AppTypography.bodyMd.copyWith(color: s.outline)),
          ],
        ],
      ),
    );
  }
}

class DsErrorView extends StatelessWidget {
  const DsErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return DsEmptyState(
      icon: Icons.error_outline_rounded,
      title: 'Terjadi kesalahan',
      subtitle: message,
      action: onRetry == null
          ? null
          : OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba lagi'),
            ),
    );
  }
}

/// Label/value row used by payroll breakdowns (Stitch "payroll breakdown card").
class DsDetailRow extends StatelessWidget {
  const DsDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasize = false,
    this.valueColor,
    this.prefixIcon,
  });

  final String label;
  final String value;
  final bool emphasize;
  final Color? valueColor;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, size: 16, color: s.outline),
            const SizedBox(width: 6),
          ],
          Expanded(
            child: Text(
              label,
              maxLines: 2,
              style: emphasize
                  ? AppTypography.titleMd.copyWith(color: s.onSurface)
                  : AppTypography.bodyMd.copyWith(color: s.onSurfaceVariant),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            value,
            style: (emphasize ? AppTypography.titleMd : AppTypography.bodyMd).copyWith(
              color: valueColor ?? s.onSurface,
              fontWeight: FontWeight.w700,
              fontFeatures: AppTypography.tabular,
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin divider matching Stitch's 1px row separators.
class DsDivider extends StatelessWidget {
  const DsDivider({super.key, this.indent = 0});

  final double indent;

  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        thickness: 1,
        indent: indent,
        color: Theme.of(context).colorScheme.outlineVariant,
      );
}

/// Icon + title + subtitle row used for settings / action lists.
class DsActionTile extends StatelessWidget {
  const DsActionTile({
    super.key,
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final DsTone tone;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme s = Theme.of(context).colorScheme;
    return Material(
      color: s.surfaceContainerLow,
      borderRadius: AppRadius.rMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rMd,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: tone.bg(s), borderRadius: AppRadius.rSm),
                child: Icon(icon, size: 20, color: tone.fg(s)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMd.copyWith(
                        color: s.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.labelMd.copyWith(color: s.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: s.outline),
            ],
          ),
        ),
      ),
    );
  }
}
