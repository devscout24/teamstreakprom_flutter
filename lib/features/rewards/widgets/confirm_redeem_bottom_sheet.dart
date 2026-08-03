import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import '../../../constants/text_font_style.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../common_widgets/custom_gradient_button.dart';

class ConfirmRedeemBottomSheet extends StatefulWidget {
  const ConfirmRedeemBottomSheet({super.key});

  @override
  State<ConfirmRedeemBottomSheet> createState() =>
      _ConfirmRedeemBottomSheetState();
}

class _ConfirmRedeemBottomSheetState extends State<ConfirmRedeemBottomSheet> {
  int _step =
      0; // 0 = Reward Verification, 1 = Confirmation Redeem, 2 = Code Box
  int _verificationMethod = 0; // 0 = 4-digit code, 1 = Quick Swipe

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.c171A20, // Dark background color
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
          if (_step == 0)
            _buildRewardVerification()
          else if (_step == 1)
            _buildConfirmationRedeem()
          else
            _buildCodeConfirm(),
        ],
      ),
    );
  }

  Widget _buildRewardVerification() {
    return Column(
      children: [
        Text(
          "Reward Verification",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        UIHelper.verticalSpace(24.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.w,
            ),
          ),
          child: Column(
            children: [
              Text(
                "Verification Method",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              UIHelper.verticalSpace(16.h),
              _buildVerificationOption(
                index: 0,
                title: "Require 4-digit Code",
                description: "Employees must enter a a-digit code to redeem.",
              ),
              UIHelper.verticalSpace(12.h),
              _buildVerificationOption(
                index: 1,
                title: "Quick Swipe Confirmation",
                description:
                    "Customers will be able to swipe to claim a reward. The customer will then show the employee the redeemed reward making for a quick and easy hand off.",
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(24.h),
        CustomGradientButton(
          onPressed: () {
            setState(() {
              _step = 1;
            });
          },
          child: Text(
            "Confirm",
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
        ),
        UIHelper.verticalSpace(16.h),
      ],
    );
  }

  Widget _buildVerificationOption({
    required int index,
    required String title,
    required String description,
  }) {
    final isSelected = _verificationMethod == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _verificationMethod = index;
        });
      },
      child: GradientContainer(
        padding: EdgeInsets.all(16.w),
        border: Border.all(
          color: isSelected ? const Color(0xFF72E84F) : Colors.transparent,
          width: 1.w,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: isSelected ? AppColors.c72E84F : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                        ),
                  ),
                  UIHelper.verticalSpace(8.h),
                  Text(
                    description,
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13.sp,

                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
            UIHelper.horizontalSpace(12.w),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF72E84F) : Colors.white,
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF72E84F),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationRedeem() {
    return Column(
      children: [
        Text(
          "Confirmation Redeem",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        UIHelper.verticalSpace(16.h),
        Text(
          "Please ensure an employee is present before\nredeeming this reward.",
          textAlign: TextAlign.center,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),
        UIHelper.verticalSpace(32.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                  ),
                ),
              ),
            ),
            UIHelper.horizontalSpace(16.w),
            Expanded(
              child: CustomGradientButton(
                onPressed: () {
                  if (_verificationMethod == 0) {
                    setState(() {
                      _step = 2;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Confirm",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                ),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(16.h),
      ],
    );
  }

  Widget _buildCodeConfirm() {
    return Column(
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
          "Customers will receive a 4 digit code. They will then\ngive this code to the employees to enter to verify the\nreward before a customer can redeem the reward.\nThis allows for a more secure way of redeeming\nrewards.",
          textAlign: TextAlign.center,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12.sp,
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
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
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
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(16.h),
      ],
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
