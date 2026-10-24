import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

Future<bool?> showConfirmRedeemRewardBottomSheet({
  required BuildContext context,
  required String rewardName,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => ConfirmRedeemRewardBottomSheet(
      rewardName: rewardName,
    ),
  );
}

class ConfirmRedeemRewardBottomSheet extends StatelessWidget {
  final String rewardName;

  const ConfirmRedeemRewardBottomSheet({
    super.key,
    required this.rewardName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.scaffoldColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Confirmation Redeem",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            UIHelper.verticalSpace(16.h),
            Text.rich(
              TextSpan(
                text: "Are you sure you want to redeem ",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 13.sp,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: rewardName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColorSecond,
                    ),
                  ),
                  const TextSpan(
                    text:
                        ". Please ensure that an employee is present upon claiming this reward. This reward will be added to your inventory after confirmation.",
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            UIHelper.verticalSpace(24.h),
            Divider(
              color: Colors.white.withValues(alpha: 0.1),
              thickness: 1.h,
              height: 1.h,
            ),
            UIHelper.verticalSpace(24.h),
            Row(
              children: [
                Expanded(
                  child: CustomGradientButton(
                    onPressed: () => Navigator.pop(context, false),
                    title: "Cancel",
                    height: 48.h,
                    borderRadius: BorderRadius.circular(100.r),
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.white],
                    ),
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: AppColors.c262824,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                  ),
                ),
                UIHelper.horizontalSpace(16.w),
                Expanded(
                  child: CustomGradientButton(
                    onPressed: () => Navigator.pop(context, true),
                    title: "Confirm",
                    height: 48.h,
                    borderRadius: BorderRadius.circular(100.r),
                    textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: AppColors.c262824,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                  ),
                ),
              ],
            ),
            UIHelper.verticalSpace(8.h),
          ],
        ),
      ),
    );
  }
}
