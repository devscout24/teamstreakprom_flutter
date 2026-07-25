import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../common_widgets/custom_gradient_button.dart';

class ClaimFilterTabs extends StatelessWidget {
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const ClaimFilterTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ["All", "Pending", "Redeemed"];
    final double h = 48.h;
    final double r = 100.r;

    return Container(
      height: h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.c242A34,
        borderRadius: BorderRadius.circular(r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tabs.map((tab) {
          final isSelected = tab == selectedTab;
          final br = BorderRadius.circular(r - 4);
          final textStyle = TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            fontFamily: 'SF Pro',
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? AppColors.c262824 : Colors.white,
          );

          return Expanded(
            child: CustomGradientButton(
              onPressed: () => onTabSelected(tab),
              height: h - 8,
              borderRadius: br,
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF28F31),
                        Color(0xFF72E84F),
                      ],
                    )
                  : const LinearGradient(
                      colors: [Colors.transparent, Colors.transparent],
                    ),
              child: isSelected
                  ? Text(tab, style: textStyle)
                  : ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF28F31),
                          Color(0xFF72E84F),
                        ],
                      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: Text(tab, style: textStyle),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
