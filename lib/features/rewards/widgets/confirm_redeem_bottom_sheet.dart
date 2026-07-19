import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';

class ConfirmRedeemBottomSheet extends StatelessWidget {
  const ConfirmRedeemBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.c171A20, // Dark background color from screenshot
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Confirm Redeem",
            style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          UIHelper.verticalSpace(16.h),
          Text(
            "Share this code with the employee at the store to\nredeem your reward.",
            textAlign: TextAlign.center,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
          UIHelper.verticalSpace(24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.c1B1F26,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                Text(
                  "Your Verification Code",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13.sp,
                      ),
                ),
                UIHelper.verticalSpace(16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCodeBox("6"),
                    UIHelper.horizontalSpace(12.w),
                    _buildCodeBox("8"),
                    UIHelper.horizontalSpace(12.w),
                    _buildCodeBox("9"),
                    UIHelper.horizontalSpace(12.w),
                    _buildCodeBox("1"),
                  ],
                ),
              ],
            ),
          ),
          UIHelper.verticalSpace(24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white.withValues(alpha: 0.8),
                size: 18.sp,
              ),
              UIHelper.horizontalSpace(10.w),
              Expanded(
                child: Text(
                  "Please ensure an employee is present before redeeming this reward.",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(32.h),
        ],
      ),
    );
  }

  Widget _buildCodeBox(String code) {
    return Container(
      width: 52.w,
      height: 60.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF262A34),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        code,
        style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
