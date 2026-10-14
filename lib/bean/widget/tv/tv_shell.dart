import 'package:flutter/material.dart';
import 'package:kazumi/utils/device.dart';

/// Logical width the interface is laid out against on televisions.
///
/// Kazumi's layout is designed phone-first. A 1080p television usually reports
/// a device pixel ratio of 1.0, which leaves ~1920 logical pixels and makes
/// every card, font and control roughly half the intended physical size.
/// Re-laying the UI out against a narrower logical viewport (and scaling the
/// ratio up accordingly) keeps the rendering resolution while restoring
/// couch-distance legibility.
const double tvDesignWidth = 1280;

/// Bounds for the automatic television scale factor.
const double _minTvScale = 1.0;
const double _maxTvScale = 2.0;

/// Applies television-specific display tuning to its subtree.
///
/// On phones and desktops this is a no-op, so a single build serves every
/// form factor.
class TvShell extends StatelessWidget {
  const TvShell({super.key, required this.child});

  final Widget child;

  /// Scale factor applied to the logical viewport on televisions.
  ///
  /// Exposed for tests and for pages that need to reason about the effective
  /// logical size.
  static double scaleFor(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    if (width <= 0 || !isTelevision()) {
      return 1.0;
    }
    return (width / tvDesignWidth).clamp(_minTvScale, _maxTvScale);
  }

  @override
  Widget build(BuildContext context) {
    if (!isTelevision()) {
      return child;
    }

    final media = MediaQuery.of(context);
    final scale = scaleFor(context);
    final theme = Theme.of(context);

    // A remote control has no pointer: hover feedback never appears, so the
    // focus overlay has to carry the "you are here" signal on its own.
    final tvTheme = theme.copyWith(
      focusColor: theme.colorScheme.primary.withValues(alpha: 0.30),
      hoverColor: theme.colorScheme.primary.withValues(alpha: 0.18),
    );

    final tuned = scale == 1.0
        ? media
        : media.copyWith(
            size: media.size / scale,
            devicePixelRatio: media.devicePixelRatio * scale,
          );

    return Theme(
      data: tvTheme,
      child: MediaQuery(data: tuned, child: child),
    );
  }
}
