import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../constants/text_font_style.dart';
import 'package:teamstreakpromo/common_widgets/custom_button.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import '../../../../../common_widgets/custom_gradient_button.dart';
import '../../../../../common_widgets/app_network_image.dart';

class RewardWizardStepThree extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController endDateController;
  final TextEditingController quantityController;
  final List<String> rewardPhotoPaths;
  final bool agreedToTerms;
  final Function(bool) onAgreedToTermsChanged;
  final VoidCallback onEdit;
  final VoidCallback onPost;

  const RewardWizardStepThree({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.endDateController,
    required this.quantityController,
    required this.rewardPhotoPaths,
    required this.agreedToTerms,
    required this.onAgreedToTermsChanged,
    required this.onEdit,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overview",
                    style: TextFontStyle.textStyle16cFFFFFFSFPro590.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  UIHelper.verticalSpace(8.h),
                  Text(
                    "Double-check your information before\nmaking your reward live.",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(
                          color: AppColors.cBCBCBB,
                          fontSize: 13.sp,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
            CustomButton(
              onPressed: onEdit,
              title: "Edit Info",
              backgroundColor: const Color(0xFFFFAA00),
              foregroundColor: Colors.black,
              width: 90.w,
              height: 36.h,
              borderRadius: BorderRadius.circular(100.r),
              padding: EdgeInsets.zero,
              textStyle: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        UIHelper.verticalSpace(24.h),

        Text(
          "Reward Information",
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.cE9EAE9,
          ),
        ),
        UIHelper.verticalSpace(12.h),

        // Reward Card Preview
        GradientContainer(
          padding: EdgeInsets.all(16.w),
          borderRadius: BorderRadius.circular(16.r),
          color: AppColors.c242A34,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleController.text.isNotEmpty
                    ? titleController.text
                    : "Adidas Court block Shoes",
                style: TextFontStyle.textStyle16cFFFFFFSFPro590.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              UIHelper.verticalSpace(12.h),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              UIHelper.verticalSpace(12.h),

              Text(
                "Reward Description",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                descriptionController.text.isNotEmpty
                    ? descriptionController.text
                    : "Experience unmatched comfort with NIKE Men's Sneakers. Crafted for durability, they feature a breathable upper and cushioned sole...",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: AppColors.cBCBCBB,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              UIHelper.verticalSpace(16.h),

              Row(
                children: [
                  Text(
                    "End Date : ",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(color: AppColors.cBCBCBB, fontSize: 12.sp),
                  ),
                  Text(
                    endDateController.text.isNotEmpty
                        ? endDateController.text
                        : "Aug 28, 2026",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 12.sp),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.stars, // Replace with appropriate icon
                    color: Colors.white,
                    size: 14.sp,
                  ),
                  UIHelper.horizontalSpace(4.w),
                  Text(
                    "${quantityController.text.isNotEmpty ? quantityController.text : '4'} reward remaining",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(fontWeight: FontWeight.w600, fontSize: 12.sp),
                  ),
                ],
              ),
              UIHelper.verticalSpace(16.h),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              UIHelper.verticalSpace(16.h),

              Text(
                "Reward Photo",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              UIHelper.verticalSpace(12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: rewardPhotoPaths.isNotEmpty
                    ? Image.file(
                        File(rewardPhotoPaths.first),
                        height: 160.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : AppNetworkImage(
                        imageUrl:
                            "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&q=80&w=800",
                        height: 160.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              UIHelper.verticalSpace(16.h),

              // Info box
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 16.sp,
                  ),
                  UIHelper.horizontalSpace(8.w),
                  Expanded(
                    child: Text(
                      "This reward can be collected from a physical store location.",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 11.sp,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        UIHelper.verticalSpace(24.h),

        // Terms and conditions checkbox
        Row(
          children: [
            GestureDetector(
              onTap: () {
                onAgreedToTermsChanged(!agreedToTerms);
              },
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: agreedToTerms
                      ? const Color(0xFFFFAA00)
                      : Colors.transparent,
                  border: Border.all(
                    color: agreedToTerms
                        ? const Color(0xFFFFAA00)
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: agreedToTerms
                    ? Icon(Icons.check, color: Colors.black, size: 16.sp)
                    : null,
              ),
            ),
            UIHelper.horizontalSpace(12.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: "I agree to all ",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(fontSize: 13.sp),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: const Color(0xFF72E84F), // Bright Green
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(32.h),

        // Post Reward Button
        CustomGradientButton(
          onPressed: agreedToTerms ? onPost : () {}, // Disable if not agreed
          title: "Post Reward",
          height: 52.h,
          gradient: agreedToTerms
              ? null
              : LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.2),
                  ],
                ),
          textStyle: TextFontStyle.textStyle16c000000SFPro590.copyWith(
            fontWeight: FontWeight.w700,
            color: agreedToTerms
                ? const Color(0xFF1B1C1A)
                : Colors.white.withValues(alpha: 0.5),
          ),
        ),
        UIHelper.verticalSpace(16.h),
      ],
    );
  }
}
