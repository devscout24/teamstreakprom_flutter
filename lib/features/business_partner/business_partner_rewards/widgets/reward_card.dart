import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/app_network_image.dart';
import '../../../../common_widgets/gradient_container.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: GradientContainer(
        padding: EdgeInsets.all(12.w),
        color: AppColors.c242A34,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: AppNetworkImage(
                imageUrl:
                    "https://images.unsplash.com/photo-1459749411175-04bf5292ceea?q=80&w=600&auto=format&fit=crop",
                height: 140.h,
                width: double.infinity,
              ),
            ),
            UIHelper.verticalSpace(12.h),

            // Title & Active Tag
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Gala Galactica: New Year's",
                    style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.cE9EAE9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.c59B53E.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    "Active",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          fontSize: 10.sp,
                          color: AppColors.c59B53E,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpace(8.h),

            // Location & Date
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.cBCBCBB,
                  size: 14.sp,
                ),
                UIHelper.horizontalSpace(4.w),
                Expanded(
                  child: Text(
                    "Divine Art Festival",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(color: AppColors.cBCBCBB, fontSize: 12.sp),
                  ),
                ),
                Text(
                  "Exp: Sep 30, 2025",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12.sp,
                      ),
                ),
              ],
            ),
            UIHelper.verticalSpace(12.h),

            // Bottom Stats & Actions
            GradientContainer(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryColorSecond.withValues(alpha: .1),
                  AppColors.cFFFFFF.withValues(alpha: .3),
                ],
              ),
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "30",
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          "Claimed",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 40.h,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "200",
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          "Remaining",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 40.h,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          iconPath: 'assets/icons/delete_icon.png',
                          iconColor: const Color(0xFFC72C2C),
                          onTap: () {},
                        ),
                        _buildActionButton(
                          iconPath: 'assets/icons/edit_icon.png',
                          iconColor: const Color(0xFF1E211A),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String iconPath,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          iconPath,
          color: iconColor,
          width: 16.sp,
          height: 16.sp,
        ),
      ),
    );
  }
}
