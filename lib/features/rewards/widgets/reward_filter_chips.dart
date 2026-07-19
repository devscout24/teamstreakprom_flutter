import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';

class RewardFilterChips extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const RewardFilterChips({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ["All", "Marketplace", "Event"];
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.primaryColorSecond 
                      : const Color(0xFF1E222B),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  filters[index],
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                    color: isSelected ? const Color(0xFF181A20) : Colors.white,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
