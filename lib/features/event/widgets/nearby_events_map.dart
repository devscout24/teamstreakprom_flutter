import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/assets.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';

class NearbyEventsMap extends StatelessWidget {
  const NearbyEventsMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nearby Events",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Action for View Map
                },
                child: Text(
                  "View Map",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.cFFFFFF,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.cFFFFFF,
                      ),
                ),
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            height: 230.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1.w,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      Assets.images.mapEvent.path,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      Assets.images.mapIndicator.path,
                      width: 44.w,
                      height: 44.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
