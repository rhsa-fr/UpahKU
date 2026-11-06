import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/theme/typography.dart';
import 'design_system.dart';

/// The fixed app header used across every Stitch screen:
/// logo + brand + "Mode Offline Aktif" pill on the left, subtitle below,
/// circular account avatar on the right.
class DsAppHeader extends StatelessWidget implements PreferredSizeWidget {
  const DsAppHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onAvatarTap,
    this.trailing,
    this.showOfflinePill = true,
    this.logoAsset,
    this.bottom,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onAvatarTap;
  final Widget? trailing;
  final bool showOfflinePill;
  final String? logoAsset;
  final PreferredSizeWidget? bottom;

  static const double height = 64;

  @override
  Size get preferredSize => Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme s = theme.colorScheme;

    final Widget logo = ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Image.asset(
        logoAsset ??
            (theme.brightness == Brightness.dark
                ? 'assets/images/logo_mark_dark.png'
                : 'assets/images/logo_mark.png'),
        height: 34,
        width: 34,
        fit: BoxFit.cover,
      ),
    );

    return AppBar(
      toolbarHeight: height,
      backgroundColor: s.surface.withValues(alpha: 0.86),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: AppSpacing.margin,
      title: Row(
        children: [
          logo,
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleMd.copyWith(
                          color: s.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (showOfflinePill) ...[
                      const SizedBox(width: 6),
                      const DsPill(
                        label: 'Mode Offline Aktif',
                        tone: DsTone.secondary,
                        dot: true,
                        dense: true,
                      ),
                    ],
                  ],
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
        ],
      ),
      actions: [
        if (trailing != null) trailing!,
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm, right: AppSpacing.md),
          child: Material(
            color: s.primary,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onAvatarTap,
              child: SizedBox(
                width: 34,
                height: 34,
                child: Icon(Icons.person_rounded, size: 19, color: s.onPrimary),
              ),
            ),
          ),
        ),
      ],
      bottom: bottom,
    );
  }
}

/// Page body scaffold: flat surface background + 16px gutters, matching Stitch
/// `px-margin` sections stacked with 8–12px gaps.
class DsPage extends StatelessWidget {
  const DsPage({
    super.key,
    required this.slivers,
    this.header,
    this.floatingActionButton,
    this.refresh,
  });

  final List<Widget> slivers;
  final PreferredSizeWidget? header;
  final Widget? floatingActionButton;
  final Future<void> Function()? refresh;

  @override
  Widget build(BuildContext context) {
    final Widget body = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 110),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.margin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _withGaps(slivers),
                ),
              ),
            ]),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: header,
      floatingActionButton: floatingActionButton,
      body: refresh == null
          ? SafeArea(top: header == null, bottom: false, child: body)
          : RefreshIndicator(
              onRefresh: refresh!,
              child: body,
            ),
    );
  }

  static List<Widget> _withGaps(List<Widget> items) {
    final List<Widget> out = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) out.add(const SizedBox(height: AppSpacing.md));
      out.add(items[i]);
    }
    return out;
  }
}
