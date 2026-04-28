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
}

class BottomActionBarCenterItem {
  const BottomActionBarCenterItem({
    required this.child,
    this.size = 68,
    this.top = 0,
    this.backgroundColor = const Color(0xFF6C63FF),
    this.borderColor = Colors.white,
    this.borderWidth = 6,
    this.padding = EdgeInsets.zero,
    this.semanticLabel,
    this.boxShadow = const [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 22,
        offset: Offset(0, 10),
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

class CustomBottomActionBar extends StatefulWidget {
  const CustomBottomActionBar({
    super.key,
    required this.items,
    this.currentIndex,
    this.initialActiveIndex = 0,
    this.onTap,
    this.centerAction,
    this.height = 78,
    this.horizontalPadding = 18,
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
    this.notchMargin = 16,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(24)),
    this.itemSpacing = 4,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
  }) : assert(
         items.length == 2 || items.length == 4,
         'CustomBottomActionBar supports 2 or 4 items when centerAction is separate.',
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

  @override
  State<CustomBottomActionBar> createState() => _CustomBottomActionBarState();
}

class _CustomBottomActionBarState extends State<CustomBottomActionBar> {
  late int _internalIndex;

  bool get _isControlled => widget.currentIndex != null;

  int get _selectedIndex => widget.currentIndex ?? _internalIndex;

  @override
  void initState() {
    super.initState();
    _internalIndex = widget.initialActiveIndex;
  }

  @override
  void didUpdateWidget(covariant CustomBottomActionBar oldWidget) {
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
    final leftItems = widget.items.sublist(0, widget.items.length ~/ 2);
    final rightItems = widget.items.sublist(widget.items.length ~/ 2);
    final reservedCenterWidth = centerAction == null
        ? 0.0
        : centerAction.size + (widget.notchMargin * 2);

    return SizedBox(
      height: centerAction == null
          ? widget.height
          : widget.height + (centerAction.size / 2) + centerAction.top.abs(),
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
                  topBorderColor: widget.showTopBorder
                      ? widget.topBorderColor
                      : null,
                  borderRadius: widget.borderRadius,
                ),
                child: SizedBox(
                  height: widget.height,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.horizontalPadding,
                    ),
                    child: Row(
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
              top: centerAction.top,
              child: _CenterActionContainer(action: centerAction),
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
    required this.onTap,
  });

  final BottomActionBarItem item;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;
  final TextStyle? labelStyle;
  final TextStyle? activeLabelStyle;
  final double itemSpacing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final defaultLabelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: inactiveColor,
    );
    final defaultActiveLabelStyle = defaultLabelStyle.copyWith(
      color: activeColor,
      fontWeight: FontWeight.w700,
    );

    return Semantics(
      button: true,
      label: item.semanticLabel ?? item.label,
      selected: isSelected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isSelected
                    ? (activeLabelStyle ?? defaultActiveLabelStyle)
                    : (labelStyle ?? defaultLabelStyle),
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
    required this.topBorderColor,
    required this.borderRadius,
  });

  final Color color;
  final bool hasCenterAction;
  final double notchRadius;
  final Color? topBorderColor;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = _buildPath(size);

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

    path.moveTo(0, leftTopRadius);
    path.quadraticBezierTo(0, 0, leftTopRadius, 0);
    path.lineTo(centerX - notchRadius - 18, 0);
    path.cubicTo(
      centerX - notchRadius + 6,
      0,
      centerX - notchRadius + 4,
      24,
      centerX,
      24,
    );
    path.cubicTo(
      centerX + notchRadius - 4,
      24,
      centerX + notchRadius - 6,
      0,
      centerX + notchRadius + 18,
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
        topBorderColor != oldDelegate.topBorderColor ||
        borderRadius != oldDelegate.borderRadius;
  }
}
