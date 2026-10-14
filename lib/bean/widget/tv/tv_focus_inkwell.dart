import 'package:flutter/material.dart';
import 'package:kazumi/bean/widget/tv/tv_focus_highlight.dart';
import 'package:kazumi/utils/device.dart';

/// Drop-in [InkWell] replacement that adds television focus feedback.
///
/// On phones and desktops it behaves exactly like [InkWell]. On televisions the
/// focused surface grows and gains an outline, because a remote control has no
/// pointer and the focus ring is the only cursor the viewer has.
class TvFocusInkWell extends StatefulWidget {
  const TvFocusInkWell({
    super.key,
    this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.focusScale = 1.04,
    this.focusBorderWidth = 2,
    this.autofocus = false,
    this.canRequestFocus,
    this.onFocusChange,
    this.focusNode,
    this.onTapUp,
    this.mouseCursor,
  });

  /// Wrapped content. Optional, mirroring [InkWell]: a childless ink well is
  /// used as a full-card tap target, in which case the focus outline expands to
  /// the available space.
  final Widget? child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Corner radius of the ink splash and of the focus outline.
  final BorderRadius? borderRadius;

  /// Scale applied to the wrapped surface while focused.
  final double focusScale;

  /// Outline thickness while focused.
  final double focusBorderWidth;

  /// Requests focus for this control once its scope is built.
  final bool autofocus;

  final bool? canRequestFocus;

  /// Called with the focus state in addition to driving the highlight.
  final ValueChanged<bool>? onFocusChange;

  /// Optional externally owned focus node, forwarded to the inner [InkWell].
  final FocusNode? focusNode;

  final GestureTapUpCallback? onTapUp;

  final MouseCursor? mouseCursor;

  @override
  State<TvFocusInkWell> createState() => _TvFocusInkWellState();
}

class _TvFocusInkWellState extends State<TvFocusInkWell> {
  bool _focused = false;

  void _handleFocusChange(bool hasFocus) {
    widget.onFocusChange?.call(hasFocus);
    // Phones never show the television treatment, so skip the rebuild.
    if (!isTelevision() || _focused == hasFocus) {
      return;
    }
    setState(() => _focused = hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ??
        const BorderRadius.all(Radius.circular(12));
    return InkWell(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      borderRadius: widget.borderRadius,
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus ?? true,
      onFocusChange: _handleFocusChange,
      focusNode: widget.focusNode,
      onTapUp: widget.onTapUp,
      mouseCursor: widget.mouseCursor,
      child: TvFocusHighlight(
        focused: _focused,
        borderRadius: radius,
        scale: widget.focusScale,
        borderWidth: widget.focusBorderWidth,
        child: widget.child ?? const SizedBox.expand(),
      ),
    );
  }
}
