// ignore: lines_longer_than_80_chars
// ignore_for_file: prefer_asserts_with_message, use_setters_to_change_properties, document_ignores

import 'dart:math' as math;

import 'package:dropbox_colors/dropbox_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class DropboxColorPalette extends StatefulWidget {
  const DropboxColorPalette({
    required this.cardWidthFactor,
    required this.colors,
    super.key,
  }) : assert(cardWidthFactor >= 0 && cardWidthFactor < 1),
       assert(colors.length > 1);

  /// The fraction of the total available width to use for each card.
  ///
  /// Must be in range [0, 1). For example, if set to 0.5, each card will have
  /// a width equal to half the screen width.
  final double cardWidthFactor;

  /// The list of [DropboxColor]s to display.
  final List<DropboxColor> colors;

  @override
  State<DropboxColorPalette> createState() => _DropboxColorPaletteState();
}

class _DropboxColorPaletteState extends State<DropboxColorPalette> {
  final _mousePointer = _MousePointer();

  @override
  void dispose() {
    _mousePointer.dispose();
    super.dispose();
  }

  void _updateMousePointer(Offset position) {
    _mousePointer.position = position;
  }

  void _resetMousePointer(Offset _) {
    _mousePointer.position = _MousePointer.outside;
  }

  @override
  Widget build(BuildContext context) {
    return _ColorPalette(
      cardWidthFactor: widget.cardWidthFactor,
      onMousePointerEnter: _updateMousePointer,
      onMousePointerMove: _updateMousePointer,
      onMousePointerExit: _resetMousePointer,
      children: [
        for (final color in widget.colors)
          _ColorCard(mousePointer: _mousePointer, color: color),
      ],
    );
  }
}

class _MousePointer extends ChangeNotifier {
  _MousePointer();

  /// A value corresponding to the position outside of the bounds.
  static const outside = Offset(-1, -1);

  Offset _position = outside;

  /// The current position of the mouse pointer.
  ///
  /// Reported in local coordinates.
  Offset get position => _position;

  set position(Offset value) {
    if (value == _position) {
      return;
    }
    _position = value;
    notifyListeners();
  }
}

class _ColorCard extends StatefulWidget {
  const _ColorCard({required this.mousePointer, required this.color});

  final _MousePointer mousePointer;

  final DropboxColor color;

  @override
  State<_ColorCard> createState() => _ColorCardState();
}

class _ColorCardState extends State<_ColorCard> {
  final ValueNotifier<String> _label = ValueNotifier('');

  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  final _transformation = ValueNotifier<(Offset, double)>((Offset.zero, 0));

  Future<void>? _copyDelayFuture;

  @override
  void initState() {
    super.initState();
    widget.mousePointer.addListener(_maybeUpdateTransformation);
    _label.value = widget.color.label;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _maybeUpdateTransformation();
    });
  }

  @override
  void didUpdateWidget(_ColorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mousePointer != widget.mousePointer) {
      oldWidget.mousePointer.removeListener(_maybeUpdateTransformation);
      widget.mousePointer.addListener(_maybeUpdateTransformation);
      _maybeUpdateTransformation();
    }
    if (oldWidget.color != widget.color) {
      _label.value = widget.color.label;
    }
  }

  @override
  void dispose() {
    widget.mousePointer.removeListener(_maybeUpdateTransformation);
    _label.dispose();
    _isHovered.dispose();
    _transformation.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_copyDelayFuture != null) {
      return;
    }

    Clipboard.setData(ClipboardData(text: widget.color.colorCode)).ignore();

    _label.value = 'Copied!';

    _copyDelayFuture = Future<void>.delayed(const Duration(seconds: 2));
    await _copyDelayFuture;

    _copyDelayFuture = null;
    _label.value = widget.color.label;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _transformation,
      builder: (context, transformation, child) {
        return _AnimatedColorCardTransformation(
          fractionalTranslation: transformation.$1,
          angle: transformation.$2,
          child: child!,
        );
      },
      child: MouseRegion(
        onEnter: (_) => _isHovered.value = true,
        onExit: (_) => _isHovered.value = false,
        child: GestureDetector(
          onTap: _onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color.color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SizedBox(
              height: 226,
              width: 202,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ValueListenableBuilder(
                    valueListenable: _isHovered,
                    builder: (context, isHovered, child) {
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 150),
                        opacity: isHovered ? 1 : 0,
                        curve: Curves.easeInOut,
                        child: child,
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: _label,
                            builder: (context, label, child) {
                              return Text(
                                label,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 24 / 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  color: widget.color.labelColor,
                                ),
                              );
                            },
                          ),
                        ),
                        Text(
                          widget.color.colorCode,
                          style: TextStyle(
                            fontSize: 12,
                            height: 24 / 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            color: widget.color.labelColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _maybeUpdateTransformation() {
    if (!context.mounted) {
      return;
    }

    final renderObject = context.findRenderObject();

    if (renderObject == null) {
      return;
    }

    final parentData = renderObject.parentData! as _ColorPaletteParentData;

    _transformation.value = _calculateTransformation(
      parentData: parentData,
      pointerPosition: widget.mousePointer.position,
    );
  }

  (Offset, double) _calculateTransformation({
    required _ColorPaletteParentData parentData,
    required Offset pointerPosition,
  }) {
    if (pointerPosition == _MousePointer.outside) {
      return (Offset.zero, 0);
    }

    final index = parentData.index;
    final gap = parentData.gap;
    final width = parentData.width;
    final cardCount = parentData.cardCount;

    final left = index * gap;
    final right = left + width;
    final zeroPointAt = gap / 2;

    final x = pointerPosition.dx
        .remap(
          fromLow: left + zeroPointAt * 2 - width,
          fromHigh: right,
          toLow: -1,
          toHigh: 1,
        )
        .clamp(-1, index == cardCount - 1 ? 0 : 1);
    final y = (x >= 0 && x <= 1) ? _f(x - 1, 2) : _f(_f(-x - 1, 3), 2);

    const maxOffset = -0.5;
    final maxAngle = (cardCount <= 5 ? -0.75 : -1.5) * math.pi / 180;

    return (Offset(0, y * maxOffset), y * maxAngle);
  }

  double _f(double x, double a) {
    return (1 - math.cos(math.pi * math.pow(x, a))) / 2;
  }
}

class _AnimatedColorCardTransformation extends ImplicitlyAnimatedWidget {
  const _AnimatedColorCardTransformation({
    required this.fractionalTranslation,
    required this.angle,
    required this.child,
  }) : super(
         curve: const Cubic(0.15, 0.5, 0.05, 1),
         duration: const Duration(milliseconds: 400),
       );

  /// The translation to apply to the card, scaled to the card's size.
  ///
  /// For example, an [Offset] with a `dy` of 0.25 will result in a vertical
  /// translation of one quarter the height of the card.
  final Offset fractionalTranslation;

  /// The angle to apply to the card.
  ///
  /// Expressed in radians.
  final double angle;

  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<_AnimatedColorCardTransformation>
  createState() => _AnimatedSlideState();
}

class _AnimatedSlideState
    extends ImplicitlyAnimatedWidgetState<_AnimatedColorCardTransformation> {
  Tween<Offset>? _translation;
  late Animation<Offset> _translationAnimation;
  Tween<double>? _angle;
  late Animation<double> _angleAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _translation =
        visitor(
              _translation,
              widget.fractionalTranslation,
              (dynamic value) => Tween<Offset>(begin: value as Offset),
            )
            as Tween<Offset>?;
    _angle =
        visitor(
              _angle,
              widget.angle,
              (dynamic value) => Tween<double>(begin: value as double),
            )
            as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _translationAnimation = animation.drive(_translation!);
    _angleAnimation = animation.drive(_angle!);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _translationAnimation,
      child: MatrixTransition(
        animation: _angleAnimation,
        onTransform: _computeRotation,
        child: widget.child,
      ),
    );
  }

  // Computes a rotation matrix for an angle in radians, attempting to keep
  // rotations at integral values for angles of 0, π/2, π, 3π/2.
  static Matrix4 _computeRotation(double radians) {
    assert(
      radians.isFinite,
      'Cannot compute the rotation matrix for a non-finite angle: $radians',
    );
    if (radians == 0.0) {
      return Matrix4.identity();
    }
    final sin = math.sin(radians);
    if (sin == 1.0) {
      return _createZRotation(1, 0);
    }
    if (sin == -1.0) {
      return _createZRotation(-1, 0);
    }
    final cos = math.cos(radians);
    if (cos == -1.0) {
      return _createZRotation(0, -1);
    }
    return _createZRotation(sin, cos);
  }

  static Matrix4 _createZRotation(double sin, double cos) {
    final result = Matrix4.zero();
    result.storage[0] = cos;
    result.storage[1] = sin;
    result.storage[4] = -sin;
    result.storage[5] = cos;
    result.storage[10] = 1.0;
    result.storage[15] = 1.0;
    return result;
  }
}

class _ColorPalette extends MultiChildRenderObjectWidget {
  const _ColorPalette({
    required this.cardWidthFactor,
    required super.children,
    required this.onMousePointerEnter,
    required this.onMousePointerMove,
    required this.onMousePointerExit,
  }) : assert(cardWidthFactor >= 0 && cardWidthFactor < 1),
       assert(children.length > 0);

  /// The fraction of the total available width to use for each card.
  ///
  /// Must be in range [0, 1). For example, if set to 0.5, each card will have
  /// a width equal to half the screen width.
  final double cardWidthFactor;

  /// Triggered when a mouse pointer has entered this widget.
  final ValueChanged<Offset> onMousePointerEnter;

  /// Triggered when a pointer moves into a position within this widget.
  final ValueChanged<Offset> onMousePointerMove;

  /// Triggered when a mouse pointer has exited this widget.
  final ValueChanged<Offset> onMousePointerExit;

  @override
  _RenderColorPalette createRenderObject(BuildContext context) {
    return _RenderColorPalette(
      cardWidthFactor: cardWidthFactor,
      onMousePointerEnter: onMousePointerEnter,
      onMousePointerMove: onMousePointerMove,
      onMousePointerExit: onMousePointerExit,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderColorPalette renderObject,
  ) {
    renderObject
      ..cardWidthFactor = cardWidthFactor
      ..onMousePointerEnter = onMousePointerEnter
      ..onMousePointerMove = onMousePointerMove
      ..onMousePointerExit = onMousePointerExit;
  }
}

class _RenderColorPalette extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ColorPaletteParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ColorPaletteParentData>
    implements MouseTrackerAnnotation {
  _RenderColorPalette({
    required double cardWidthFactor,
    required ValueChanged<Offset> onMousePointerEnter,
    required ValueChanged<Offset> onMousePointerMove,
    required ValueChanged<Offset> onMousePointerExit,
    List<RenderBox>? children,
  }) : _cardWidthFactor = cardWidthFactor,
       _onMousePointerEnter = onMousePointerEnter,
       _onMousePointerMove = onMousePointerMove,
       _onMousePointerExit = onMousePointerExit {
    addAll(children);
  }

  static const _kPaletteHeight = 70.0;
  static const _kPaletteMinIntrinsicWidth = 990.0;
  static const _kCardHeight = 200.0;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ColorPaletteParentData) {
      child.parentData = _ColorPaletteParentData();
    }
  }

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    _onMousePointerExit(Offset.zero);
    super.dispose();
  }

  final _clipRectLayer = LayerHandle<ClipRectLayer>();

  /// [Rect] which describes this render object bounds.
  Rect _boundingRect = Rect.zero;

  @override
  bool get isRepaintBoundary => true;

  double get cardWidthFactor => _cardWidthFactor;
  double _cardWidthFactor;
  set cardWidthFactor(double value) {
    if (_cardWidthFactor == value) {
      return;
    }
    _cardWidthFactor = value;
    markNeedsLayout();
  }

  ValueChanged<Offset> get onMousePointerEnter => _onMousePointerEnter;
  ValueChanged<Offset> _onMousePointerEnter;
  set onMousePointerEnter(ValueChanged<Offset> value) {
    if (_onMousePointerEnter == value) {
      return;
    }
    _onMousePointerEnter = value;
  }

  ValueChanged<Offset> get onMousePointerMove => _onMousePointerMove;
  ValueChanged<Offset> _onMousePointerMove;
  set onMousePointerMove(ValueChanged<Offset> value) {
    if (_onMousePointerMove == value) {
      return;
    }
    _onMousePointerMove = value;
  }

  ValueChanged<Offset> get onMousePointerExit => _onMousePointerExit;
  ValueChanged<Offset> _onMousePointerExit;
  set onMousePointerExit(ValueChanged<Offset> value) {
    if (_onMousePointerExit == value) {
      return;
    }
    _onMousePointerExit = value;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _kPaletteMinIntrinsicWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return computeMinIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _kPaletteHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  Size _computeSize({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    final size = Size(
      constraints.biggest.width,
      math.min(_kPaletteHeight, constraints.biggest.height),
    );

    final cardConstraints = constraints.tighten(
      width: size.width * cardWidthFactor,
      height: _kCardHeight,
    );

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as _ColorPaletteParentData;
      layoutChild(child, cardConstraints);
      child = childParentData.nextSibling;
    }

    return size;
  }

  @override
  void performLayout() {
    final constraints = this.constraints;

    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );

    final cardCount = childCount;
    final cardWidth = size.width * cardWidthFactor;
    final cardGap = (size.width - cardWidth) / (cardCount - 1);

    _boundingRect = Rect.fromLTWH(
      -20,
      -_kCardHeight * 0.6,
      size.width + 40,
      size.height + _kCardHeight * 0.6,
    );

    var cardIndex = 0;

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as _ColorPaletteParentData
        ..offset = Offset(cardIndex * cardGap, 0)
        ..index = cardIndex
        ..gap = cardGap
        ..width = cardWidth
        ..cardCount = cardCount;
      assert(child.parentData == childParentData);

      child = childParentData.nextSibling;
      cardIndex += 1;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _clipRectLayer.layer = context.pushClipRect(
      needsCompositing,
      offset,
      _boundingRect,
      defaultPaint,
      oldLayer: _clipRectLayer.layer,
    );
  }

  @override
  Rect? describeApproximatePaintClip(RenderObject child) {
    return _boundingRect;
  }

  @override
  MouseCursor get cursor => MouseCursor.defer;

  @override
  bool get validForMouseTracker => true;

  @override
  PointerEnterEventListener? get onEnter => (event) {
    _onMousePointerEnter(event.localPosition);
  };

  @override
  PointerExitEventListener? get onExit => (event) {
    _onMousePointerExit(event.localPosition);
  };

  @override
  void handleEvent(PointerEvent event, HitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerHoverEvent || event is PointerMoveEvent) {
      _onMousePointerMove(event.localPosition);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_boundingRect.contains(position)) {
      if (hitTestChildren(result, position: position) ||
          hitTestSelf(position)) {
        result.add(BoxHitTestEntry(this, position));
        return true;
      }
    }
    return false;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  @override
  bool hitTestSelf(Offset position) {
    return size.contains(position);
  }
}

/// Parent data for use with [_RenderColorPalette].
class _ColorPaletteParentData extends ContainerBoxParentData<RenderBox> {
  /// The card's index.
  int index = -1;

  /// The gap between cards.
  double gap = 0;

  /// The card's width.
  double width = 0;

  /// The total number of cards.
  int cardCount = 0;

  @override
  String toString() {
    return 'index=$index; gap=$gap; width=$width; cardCount=$cardCount; '
        '${super.toString()}';
  }
}

extension _Remap on double {
  double remap({
    required double fromLow,
    required double fromHigh,
    required double toLow,
    required double toHigh,
  }) {
    return (this - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
  }
}
