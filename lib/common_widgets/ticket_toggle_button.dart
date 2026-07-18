import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import 'custom_gradient_button.dart';

/// A pair of labelled toggle tabs (e.g. "Upcoming" / "Past Ticket").
/// The selected tab uses [CustomGradientButton] with the primary gradient;
/// the unselected tab uses [CustomGradientButton] with a transparent/no-op style.
class TicketToggleButton extends StatelessWidget {
  const TicketToggleButton({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.selectedIndex,
    required this.onChanged,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
    this.spacing,
  });

  final String leftLabel;
  final String rightLabel;

  /// 0 = left selected, 1 = right selected
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final double h = height ?? 48.h;
    final double r = borderRadius ?? 100.r;
    return Container(
      height: h,
      padding: padding ?? EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.c1C2027,
        borderRadius: BorderRadius.circular(r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TabItem(
            label: leftLabel,
            isSelected: selectedIndex == 0,
            tabRadius: r - 4,
            tabHeight: h - 8,
            onTap: () => onChanged(0),
          ),
          if (spacing != null) SizedBox(width: spacing),
          _TabItem(
            label: rightLabel,
            isSelected: selectedIndex == 1,
            tabRadius: r - 4,
            tabHeight: h - 8,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.tabRadius,
    required this.tabHeight,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final double tabRadius;
  final double tabHeight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(tabRadius);
    return Expanded(
      child: CustomGradientButton(
        onPressed: onTap,
        title: label,
        height: tabHeight,
        borderRadius: br,
        gradient: isSelected
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF28F31), // primaryColorFirst
                  Color(0xFF72E84F), // primaryColorSecond
                ],
              )
            : const LinearGradient(
                colors: [Colors.transparent, Colors.transparent],
              ),
        textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
          fontFamily: 'SF Pro',
          fontSize: 14.sp,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          color: isSelected
              ? AppColors.c262824
              : Colors.white.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}
