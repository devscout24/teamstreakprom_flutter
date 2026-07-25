import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../common_widgets/gradient_container.dart';
import '../../../../../common_widgets/custom_gradient_button.dart';

class ClaimCard extends StatelessWidget {
  final String name;
  final String email;
  final String rewardName;
  final String date;
  final String status;
  final VoidCallback? onMarkAsRedeemed;

  const ClaimCard({
    super.key,
    required this.name,
    required this.email,
    required this.rewardName,
    required this.date,
    required this.status,
    this.onMarkAsRedeemed,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status.toLowerCase() == "pending";

    return GradientContainer(
      padding: EdgeInsets.all(16.w),
      borderRadius: BorderRadius.circular(16.r),
      color: AppColors.c242A34,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  color: Colors.grey,
                  // Replacing with AppNetworkImage later if needed
                  child: const Icon(Icons.person, color: Colors.white),
                ),
              ),
              UIHelper.horizontalSpace(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextFontStyle.textStyle16cFFFFFFSFPro590.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.cE9EAE9,
                        fontSize: 12.sp,
                      ),
                    ),
                    UIHelper.verticalSpace(4.h),
                    Text(
                      email,
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(color: AppColors.cADADAD, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFF5A3914)
                      : const Color(0xFF19401C),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  status,
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: isPending
                            ? const Color(0xFFF28F31)
                            : const Color(0xFF72E84F),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),
          Divider(
            color: Colors.white.withValues(alpha: 0.1),
            thickness: 1.h,
            height: 1.h,
          ),
          UIHelper.verticalSpace(16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  rewardName,
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.cE9EAE9,
                      ),
                ),
              ),
              Text(
                date,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: AppColors.cADADAD,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          if (isPending) ...[
            UIHelper.verticalSpace(20.h),
            CustomGradientButton(
              onPressed: onMarkAsRedeemed ?? () {},
              title: "Mark as Redeemed",
              height: 38.h,
              textStyle: TextFontStyle.textStyle16c000000SFPro590.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1B1C1A),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
