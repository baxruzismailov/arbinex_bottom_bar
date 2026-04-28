import 'dart:math' as math;

import 'package:flutter/material.dart';

class BottomActionBarItem {
  const BottomActionBarItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.activeLabelStyle,
    this.inactiveLabelStyle,
    this.iconSize = 24,
    this.semanticLabel,
    this.labelMaxLines = 1,
    this.labelSoftWrap = false,
    this.labelOverflow = TextOverflow.ellipsis,
    this.labelTextAlign = TextAlign.center,
  });

  final Widget icon;
  final String label;
  final Widget? activeIcon;
  final VoidCallback? onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final TextStyle? activeLabelStyle;
  final TextStyle? inactiveLabelStyle;
  final double iconSize;
  final String? semanticLabel;
  final int labelMaxLines;
  final bool labelSoftWrap;
  final TextOverflow labelOverflow;
  final TextAlign labelTextAlign;
}

class BottomActionBarCenterItem {
  const BottomActionBarCenterItem({
    required this.child,
    this.size = 68,
    this.top = -8,
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFE5E7FF),
    this.borderWidth = 1,
    this.padding = EdgeInsets.zero,
    this.semanticLabel,
    this.boxShadow = const [
      BoxShadow(
        color: Color(0x22000000),
        blurRadius: 28,
        offset: Offset(0, 12),
      ),
    ],
  });

  final Widget child;
  final double size;
  final double top;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final String? semanticLabel;
  final List<BoxShadow> boxShadow;
}

class ArbinexBottomBar extends StatefulWidget {
  const ArbinexBottomBar({
    super.key,
    required this.items,
    this.currentIndex,
    this.initialActiveIndex = 0,
    this.onTap,
    this.centerAction,
    this.height = 72,
    this.horizontalPadding = 12,
    this.itemVerticalPadding = const EdgeInsets.fromLTRB(8, 8, 8, 10),
    this.backgroundColor = const Color(0xFF252525),
    this.activeColor = Colors.white,
    this.inactiveColor = const Color(0xFF8F8F8F),
    this.labelStyle,
    this.activeLabelStyle,
    this.shadow = const [
      BoxShadow(
        color: Color(0x22000000),
        blurRadius: 24,
        offset: Offset(0, -6),
      ),
    ],
    this.showTopBorder = false,
    this.topBorderColor = const Color(0x14000000),
    this.notchMargin = 10,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(28)),
    this.itemSpacing = 4,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.useSafeArea = true,
    this.notchDepth = 28,
    this.reserveBottomGap = 0,
  }) : assert(
         items.length == 2 || items.length == 4,
         'ArbinexBottomBar supports 2 or 4 items when centerAction is separate.',
       ),
       assert(
         currentIndex == null ||
             (currentIndex >= 0 && currentIndex < items.length),
         'currentIndex must match an item index.',
       ),
       assert(
         initialActiveIndex >= 0 && initialActiveIndex < items.length,
         'initialActiveIndex must match an item index.',
       );

  final List<BottomActionBarItem> items;
  final int? currentIndex;
  final int initialActiveIndex;
  final ValueChanged<int>? onTap;
  final BottomActionBarCenterItem? centerAction;
  final double height;
  final double horizontalPadding;
  final EdgeInsets itemVerticalPadding;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle? labelStyle;
  final TextStyle? activeLabelStyle;
  final List<BoxShadow> shadow;
  final bool showTopBorder;
  final Color topBorderColor;
  final double notchMargin;
  final BorderRadius borderRadius;
  final double itemSpacing;
  final MainAxisAlignment mainAxisAlignment;
  final bool useSafeArea;
  final double notchDepth;
  final double reserveBottomGap;

  @override
  State<ArbinexBottomBar> createState() => _ArbinexBottomBarState();
}

@Deprecated('Use ArbinexBottomBar instead.')
class CustomBottomActionBar extends ArbinexBottomBar {
  const CustomBottomActionBar({
    super.key,
    required super.items,
    super.currentIndex,
    super.initialActiveIndex,
    super.onTap,
    super.centerAction,
    super.height,
    super.horizontalPadding,
    super.itemVerticalPadding,
    super.backgroundColor,
    super.activeColor,
    super.inactiveColor,
    super.labelStyle,
    super.activeLabelStyle,
    super.shadow,
    super.showTopBorder,
    super.topBorderColor,
    super.notchMargin,
    super.borderRadius,
    super.itemSpacing,
    super.mainAxisAlignment,
    super.useSafeArea,
    super.notchDepth,
    super.reserveBottomGap,
  });
}

class _ArbinexBottomBarState extends State<ArbinexBottomBar> {
  late int _internalIndex;

  bool get _isControlled => widget.currentIndex != null;

  int get _selectedIndex => widget.currentIndex ?? _internalIndex;

  @override
  void initState() {
    super.initState();
    _internalIndex = widget.initialActiveIndex;
  }

  @override
  void didUpdateWidget(covariant ArbinexBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_isControlled &&
        oldWidget.initialActiveIndex != widget.initialActiveIndex &&
        oldWidget.initialActiveIndex == _internalIndex) {
      _internalIndex = widget.initialActiveIndex;
    }
  }

  void _handleTap(int index) {
    widget.items[index].onTap?.call();

    if (!_isControlled) {
      setState(() => _internalIndex = index);
    }

    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final centerAction = widget.centerAction;
    final safeBottom = widget.useSafeArea
        ? MediaQuery.paddingOf(context).bottom
        : 0.0;
    final leftItems = widget.items.sublist(0, widget.items.length ~/ 2);
    final rightItems = widget.items.sublist(widget.items.length ~/ 2);
    final reservedCenterWidth = centerAction == null
        ? 0.0
        : centerAction.size + (widget.notchMargin * 2);
    final buttonLift = centerAction == null
        ? 0.0
        : math.max(0, centerAction.size / 2 - centerAction.top.abs());
    final totalHeight =
        widget.height + safeBottom + widget.reserveBottomGap + buttonLift;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(boxShadow: widget.shadow),
              child: CustomPaint(
                painter: _BottomBarPainter(
                  color: widget.backgroundColor,
                  hasCenterAction: centerAction != null,
                  notchRadius: centerAction == null
                      ? 0
                      : (centerAction.size / 2) + widget.notchMargin,
                  notchDepth: widget.notchDepth,
                  topBorderColor: widget.showTopBorder
                      ? widget.topBorderColor
                      : null,
                  borderRadius: widget.borderRadius,
                ),
                child: SizedBox(
                  height: widget.height + safeBottom + widget.reserveBottomGap,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      widget.horizontalPadding,
                      0,
                      widget.horizontalPadding,
                      safeBottom + widget.reserveBottomGap,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildItems(leftItems, 0)),
                        if (centerAction != null)
                          SizedBox(width: reservedCenterWidth),
                        Expanded(
                          child: _buildItems(rightItems, leftItems.length),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (centerAction != null)
            Positioned(
              top: 0,
              child: Transform.translate(
                offset: Offset(0, centerAction.top),
                child: _CenterActionContainer(action: centerAction),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItems(List<BottomActionBarItem> barItems, int startIndex) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: List.generate(barItems.length, (index) {
        final itemIndex = startIndex + index;
        final isSelected = itemIndex == _selectedIndex;
        final item = barItems[index];

        return Expanded(
          child: _BarItemButton(
            item: item,
            isSelected: isSelected,
            activeColor: item.activeColor ?? widget.activeColor,
            inactiveColor: item.inactiveColor ?? widget.inactiveColor,
            labelStyle: item.inactiveLabelStyle ?? widget.labelStyle,
            activeLabelStyle: item.activeLabelStyle ?? widget.activeLabelStyle,
            itemSpacing: widget.itemSpacing,
            itemVerticalPadding: widget.itemVerticalPadding,
            onTap: () => _handleTap(itemIndex),
          ),
        );
      }),
    );
  }
}

class _BarItemButton extends StatelessWidget {
  const _BarItemButton({
    required this.item,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
    required this.labelStyle,
    required this.activeLabelStyle,
    required this.itemSpacing,
    required this.itemVerticalPadding,
    required this.onTap,
  });

  final BottomActionBarItem item;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle? labelStyle;
  final TextStyle? activeLabelStyle;
  final double itemSpacing;
  final EdgeInsets itemVerticalPadding;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = TextStyle(
      fontSize: 11,
      height: 1,
      fontWeight: FontWeight.w500,
      color: inactiveColor,
    );
    final defaultActiveLabelStyle = defaultLabelStyle.copyWith(
      color: activeColor,
      fontWeight: FontWeight.w600,
    );

    return Semantics(
      button: true,
      label: item.semanticLabel ?? item.label,
      selected: isSelected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: itemVerticalPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconTheme(
                data: IconThemeData(
                  color: isSelected ? activeColor : inactiveColor,
                  size: item.iconSize,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                  child: isSelected && item.activeIcon != null
                      ? item.activeIcon!
                      : item.icon,
                ),
              ),
              SizedBox(height: itemSpacing),
              Flexible(
                child: Text(
                  item.label,
                  textAlign: item.labelTextAlign,
                  maxLines: item.labelMaxLines,
                  softWrap: item.labelSoftWrap,
                  overflow: item.labelOverflow,
                  style: isSelected
                      ? (activeLabelStyle ?? defaultActiveLabelStyle)
                      : (labelStyle ?? defaultLabelStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterActionContainer extends StatelessWidget {
  const _CenterActionContainer({required this.action});

  final BottomActionBarCenterItem action;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: action.semanticLabel,
      child: Container(
        width: action.size,
        height: action.size,
        padding: action.padding,
        decoration: BoxDecoration(
          color: action.backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: action.borderColor,
            width: action.borderWidth,
          ),
          boxShadow: action.boxShadow,
        ),
        child: Center(child: action.child),
      ),
    );
  }
}

class _BottomBarPainter extends CustomPainter {
  const _BottomBarPainter({
    required this.color,
    required this.hasCenterAction,
    required this.notchRadius,
    required this.notchDepth,
    required this.topBorderColor,
    required this.borderRadius,
  });

  final Color color;
  final bool hasCenterAction;
  final double notchRadius;
  final double notchDepth;
  final Color? topBorderColor;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);
    final paint = Paint()..color = color;
    canvas.drawPath(path, paint);

    if (topBorderColor != null) {
      final borderPaint = Paint()
        ..color = topBorderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawPath(path, borderPaint);
    }
  }

  Path _buildPath(Size size) {
    if (!hasCenterAction) {
      return Path()..addRRect(borderRadius.toRRect(Offset.zero & size));
    }

    final path = Path();
    final centerX = size.width / 2;
    final leftTopRadius = borderRadius.topLeft.x;
    final rightTopRadius = borderRadius.topRight.x;
    final leftNotchStart = centerX - notchRadius - 22;
    final rightNotchEnd = centerX + notchRadius + 22;

    path.moveTo(0, leftTopRadius);
    path.quadraticBezierTo(0, 0, leftTopRadius, 0);
    path.lineTo(leftNotchStart, 0);

    path.cubicTo(
      centerX - notchRadius + 10,
      0,
      centerX - notchRadius + 4,
      notchDepth,
      centerX,
      notchDepth,
    );
    path.cubicTo(
      centerX + notchRadius - 4,
      notchDepth,
      centerX + notchRadius - 10,
      0,
      rightNotchEnd,
      0,
    );

    path.lineTo(size.width - rightTopRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, rightTopRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant _BottomBarPainter oldDelegate) {
    return color != oldDelegate.color ||
        hasCenterAction != oldDelegate.hasCenterAction ||
        notchRadius != oldDelegate.notchRadius ||
        notchDepth != oldDelegate.notchDepth ||
        topBorderColor != oldDelegate.topBorderColor ||
        borderRadius != oldDelegate.borderRadius;
  }
}
