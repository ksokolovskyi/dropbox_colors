import 'package:dropbox_colors/dropbox_color.dart';
import 'package:dropbox_colors/dropbox_color_palette.dart';
import 'package:flutter/material.dart';

class DropboxColorsPage extends StatelessWidget {
  const DropboxColorsPage({super.key});

  static const _kHorizontalPadding = 120.0;
  static const _kVerticalPadding = 64.0;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.sizeOf(context);

    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.symmetric(horizontal: _kHorizontalPadding),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: _kVerticalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _Line.vertical(),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 1920,
                  minHeight: windowSize.height - 2 * _kVerticalPadding,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const _Line.horizontal(),
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 8.5,
                          child: _Line.horizontal(),
                        ),
                        Text(
                          'We have three distinct\n'
                          'color categories:',
                          style: TextStyle(
                            fontSize: 42,
                            height: 48 / 42,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w700,
                            color: DropboxColors.graphite.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 76),
                    const _PaletteLabel(label: 'Core Colors'),
                    const SizedBox(height: 16),
                    DropboxColorPalette(
                      cardWidthFactor: 2 / 3,
                      colors: const [
                        DropboxColors.blue,
                        DropboxColors.coconut,
                        DropboxColors.graphite,
                      ],
                    ),
                    const _Line.horizontal(),
                    const SizedBox(height: 76),
                    const _PaletteLabel(label: 'Accent Colors'),
                    const SizedBox(height: 16),
                    DropboxColorPalette(
                      cardWidthFactor: 1 / 4,
                      colors: const [
                        DropboxColors.azalea,
                        DropboxColors.pink,
                        DropboxColors.crimson,
                        DropboxColors.sunset,
                        DropboxColors.rust,
                        DropboxColors.tangerine,
                        DropboxColors.gold,
                        DropboxColors.vividVargas,
                        DropboxColors.canopy,
                        DropboxColors.lime,
                        DropboxColors.ocean,
                        DropboxColors.zen,
                        DropboxColors.navy,
                        DropboxColors.cloud,
                        DropboxColors.plum,
                        DropboxColors.orchid,
                      ],
                    ),
                    const _Line.horizontal(),
                    const SizedBox(height: 76),
                    const _PaletteLabel(label: 'Greys'),
                    const SizedBox(height: 16),
                    DropboxColorPalette(
                      cardWidthFactor: 1 / 4,
                      colors: const [
                        DropboxColors.grey1000,
                        DropboxColors.grey950,
                        DropboxColors.grey900,
                        DropboxColors.grey850,
                        DropboxColors.grey800,
                        DropboxColors.grey750,
                        DropboxColors.grey700,
                        DropboxColors.grey650,
                        DropboxColors.grey600,
                        DropboxColors.grey550,
                        DropboxColors.grey500,
                        DropboxColors.grey450,
                        DropboxColors.grey400,
                        DropboxColors.grey350,
                        DropboxColors.grey300,
                        DropboxColors.grey250,
                        DropboxColors.grey200,
                        DropboxColors.grey150,
                        DropboxColors.grey100,
                        DropboxColors.grey50,
                      ],
                    ),
                    const _Line.horizontal(),
                  ],
                ),
              ),
            ),
            const _Line.vertical(),
          ],
        ),
      ),
    );
  }
}

class _PaletteLabel extends StatelessWidget {
  const _PaletteLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: DropboxColors.grey600.color,
      ),
    );
  }
}

class _Line extends SingleChildRenderObjectWidget {
  const _Line.horizontal() : this._(axis: Axis.horizontal);

  const _Line.vertical() : this._(axis: Axis.vertical);

  const _Line._({required this.axis});

  final Axis axis;

  @override
  _RenderLine createRenderObject(BuildContext context) {
    return _RenderLine(
      axis: axis,
      windowSize: MediaQuery.sizeOf(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderLine renderObject,
  ) {
    renderObject
      ..axis = axis
      ..windowSize = MediaQuery.sizeOf(context);
  }
}

class _RenderLine extends RenderBox {
  _RenderLine({
    required Axis axis,
    required Size windowSize,
  }) : _axis = axis,
       _windowSize = windowSize;

  static const _kLineThickness = 1.0;

  Axis get axis => _axis;
  Axis _axis;
  set axis(Axis value) {
    if (_axis == value) {
      return;
    }
    _axis = value;
    markNeedsPaint();
  }

  Size get windowSize => _windowSize;
  Size _windowSize;
  set windowSize(Size value) {
    if (_windowSize == value) {
      return;
    }
    _windowSize = value;
    markNeedsPaint();
  }

  @override
  double computeMinIntrinsicHeight(double width) => _kLineThickness;

  @override
  double computeMaxIntrinsicHeight(double width) => _kLineThickness;

  @override
  void performLayout() {
    size = constraints.constrain(const Size(_kLineThickness, _kLineThickness));
  }

  @override
  @protected
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.constrain(const Size(_kLineThickness, _kLineThickness));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0x665F9DFF);

    switch (axis) {
      case Axis.horizontal:
        context.canvas.drawLine(
          Offset(0, offset.dy + _kLineThickness / 2),
          Offset(windowSize.width, offset.dy + _kLineThickness / 2),
          paint,
        );
      case Axis.vertical:
        context.canvas.drawLine(
          Offset(offset.dx + _kLineThickness / 2, 0),
          Offset(offset.dx + _kLineThickness / 2, windowSize.height),
          paint,
        );
    }
  }
}
