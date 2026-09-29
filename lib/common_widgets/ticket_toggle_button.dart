import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';
import 'custom_gradient_button.dart';

/// A pair or group of labelled toggle tabs (e.g. "Upcoming" / "Past Ticket" / "Cancel").
/// The selected tab uses [CustomGradientButton] with the primary gradient;
/// the unselected tab uses [CustomGradientButton] with a transparent/no-op style.
class TicketToggleButton extends StatelessWidget {
  const TicketToggleButton({
    super.key,
    this.leftLabel,
    this.rightLabel,
    this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.padding,
    this.spacing,
  });

  final String? leftLabel;
  final String? rightLabel;
  final List<String>? tabs;

  /// Index of the selected tab
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  List<String> get _labels {
    if (tabs != null && tabs!.isNotEmpty) return tabs!;
    return [leftLabel ?? '', rightLabel ?? ''];
  }

  @override
  Widget build(BuildContext context) {
    final double h = height ?? 48.h;
    final double r = borderRadius ?? 100.r;
    final labels = _labels;

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
          for (int i = 0; i < labels.length; i++) ...[
            if (i > 0 && spacing != null) SizedBox(width: spacing),
            _TabItem(
              label: labels[i],
              isSelected: selectedIndex == i,
              tabRadius: r - 4,
              tabHeight: h - 8,
              fontSize: labels.length > 2 ? 12.5.sp : 14.sp,
              onTap: () => onChanged(i),
            ),
          ],
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
    this.fontSize,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final double tabRadius;
  final double tabHeight;
  final double? fontSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(tabRadius);
    final textStyle = TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
      fontFamily: 'SF Pro',
      fontSize: fontSize ?? 14.sp,
      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
      color: isSelected ? AppColors.c262824 : Colors.white,
    );

    return Expanded(
      child: CustomGradientButton(
        onPressed: onTap,
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
        child: isSelected
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    label,
                    style: textStyle,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF28F31),
                    Color(0xFF72E84F),
                  ],
                ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      label,
                      style: textStyle,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
