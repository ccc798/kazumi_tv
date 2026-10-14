import 'package:flutter/material.dart';
import 'package:kazumi/utils/device.dart';

/// Television focus feedback for tappable surfaces.
///
/// A remote control has no pointer, so hover states never fire and the focus
/// ring is the only thing telling the viewer which card the D-pad is on. The
/// focused surface grows slightly and gains a colored outline.
///
/// Outside televisions this returns [child] unchanged, keeping the phone
/// experience untouched.
class TvFocusHighlight extends StatelessWidget {
  const TvFocusHighlight({
    super.key,
    required this.focused,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.scale = 1.04,
    this.borderWidth = 2,
  });

  /// Whether the wrapped control currently owns focus.
  final bool focused;

  final Widget child;

  /// Corner radius the outline follows. Should match the wrapped surface.
  final BorderRadius borderRadius;

  /// Scale applied while focused.
  final double scale;

  /// Outline thickness while focused.
  final double borderWidth;

  /// Duration shared by the scale and outline animations.
  static const Duration animationDuration = Duration(milliseconds: 160);

  @override
  Widget build(BuildContext context) {
    if (!isTelevision()) {
      return child;
    }

    final highlight = Theme.of(context).colorScheme.primary;

    return AnimatedScale(
      scale: focused ? scale : 1.0,
      duration: animationDuration,
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color: focused ? highlight : Colors.transparent,
            width: borderWidth,
          ),
        ),
        child: child,
      ),
    );
  }
}
