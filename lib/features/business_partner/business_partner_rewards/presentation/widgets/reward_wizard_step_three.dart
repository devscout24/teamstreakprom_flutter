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
import 'package:flutter/gestures.dart';

class RewardWizardStepThree extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final String? categoryName;
  final String? subcategoryName;
  final TextEditingController startDateController;
  final TextEditingController startTimeController;
  final TextEditingController endDateController;
  final TextEditingController endTimeController;
  final TextEditingController pointsController;
  final TextEditingController quantityController;
  final List<String> rewardPhotoPaths;
  final bool agreedToTerms;
  final bool isLoading;
  final Function(bool) onAgreedToTermsChanged;
  final VoidCallback onEdit;
  final VoidCallback onPost;

  const RewardWizardStepThree({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    this.categoryName,
    this.subcategoryName,
    required this.startDateController,
    required this.startTimeController,
    required this.endDateController,
    required this.endTimeController,
    required this.pointsController,
    required this.quantityController,
    required this.rewardPhotoPaths,
    required this.agreedToTerms,
    this.isLoading = false,
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
                    : "Reward Title",
                style: TextFontStyle.textStyle16cFFFFFFSFPro590.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              if ((categoryName != null && categoryName!.isNotEmpty) ||
                  (subcategoryName != null && subcategoryName!.isNotEmpty)) ...[
                UIHelper.verticalSpace(8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    if (categoryName != null && categoryName!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cF28F31.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppColors.cF28F31.withValues(alpha: 0.5),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 12.sp,
                              color: AppColors.cF28F31,
                            ),
                            UIHelper.horizontalSpace(4.w),
                            Text(
                              categoryName!,
                              style: TextFontStyle.textStyle12cFFFFFFSFPro590
                                  .copyWith(
                                    color: AppColors.cF28F31,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    if (subcategoryName != null && subcategoryName!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          subcategoryName!,
                          style: TextFontStyle.textStyle12cFFFFFFSFPro590
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: 11.sp,
                              ),
                        ),
                      ),
                  ],
                ),
              ],
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
                    : "No description provided",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: AppColors.cBCBCBB,
                  fontSize: 12.sp,
                  height: 1.5,
                ),
              ),
              UIHelper.verticalSpace(16.h),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              UIHelper.verticalSpace(16.h),

              // Date & Time Details
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Date",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11.sp,
                              ),
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          startDateController.text.isNotEmpty
                              ? "${startDateController.text}${startTimeController.text.isNotEmpty ? ' • ${startTimeController.text}' : ''}"
                              : "Not specified",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End Date",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11.sp,
                              ),
                        ),
                        UIHelper.verticalSpace(4.h),
                        Text(
                          endDateController.text.isNotEmpty
                              ? "${endDateController.text}${endTimeController.text.isNotEmpty ? ' • ${endTimeController.text}' : ''}"
                              : "Not specified",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(12.h),

              // Points & Quantity
              Row(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.stars,
                        color: const Color(0xFFFCA311),
                        size: 15.sp,
                      ),
                      UIHelper.horizontalSpace(4.w),
                      Text(
                        "${pointsController.text.isNotEmpty ? pointsController.text : '0'} points",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                              color: const Color(0xFFFCA311),
                            ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 14.sp,
                      ),
                      UIHelper.horizontalSpace(4.w),
                      Text(
                        "${quantityController.text.isNotEmpty ? quantityController.text : '0'} reward remaining",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              UIHelper.verticalSpace(16.h),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              UIHelper.verticalSpace(16.h),

              // Photos section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rewardPhotoPaths.length > 1
                        ? "Reward Photos"
                        : "Reward Photo",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(color: Colors.white.withValues(alpha: 0.5)),
                  ),
                  if (rewardPhotoPaths.length > 1)
                    Text(
                      "${rewardPhotoPaths.length} photos selected",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            color: AppColors.cF28F31,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                ],
              ),
              UIHelper.verticalSpace(12.h),
              if (rewardPhotoPaths.length > 1)
                SizedBox(
                  height: 120.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: rewardPhotoPaths.length,
                    separatorBuilder: (_, __) => UIHelper.horizontalSpace(10.w),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          File(rewardPhotoPaths[index]),
                          height: 120.h,
                          width: 140.w,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                )
              else
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
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              UIHelper.verticalSpace(16.h),

              // Location box
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.cF28F31,
                    size: 16.sp,
                  ),
                  UIHelper.horizontalSpace(8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locationController.text.isNotEmpty
                              ? locationController.text
                              : "Physical store location",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                        ),
                        UIHelper.verticalSpace(2.h),
                        Text(
                          "This reward can be collected from this physical store location.",
                          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11.sp,
                              ),
                        ),
                      ],
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
                if (!agreedToTerms) {
                  showDialog(
                    context: context,
                    builder: (context) => _TermsAndConditionsDialog(
                      onAgreed: () {
                        Navigator.pop(context);
                        onAgreedToTermsChanged(true);
                      },
                    ),
                  );
                } else {
                  onAgreedToTermsChanged(false);
                }
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
                            color: AppColors.cF28F31,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) => _TermsAndConditionsDialog(
                          //     onAgreed: () {
                          //       Navigator.pop(context);
                          //       onAgreedToTermsChanged(true);
                          //     },
                          //   ),
                          // );
                        },
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
          onPressed: agreedToTerms && !isLoading ? onPost : null,
          height: 52.h,
          gradient: agreedToTerms
              ? null
              : LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.2),
                  ],
                ),
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  "Post Reward",
                  style: TextFontStyle.textStyle16c000000SFPro590.copyWith(
                    fontWeight: FontWeight.w700,
                    color: agreedToTerms
                        ? const Color(0xFF1B1C1A)
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
        ),
        UIHelper.verticalSpace(16.h),
      ],
    );
  }
}

class _TermsAndConditionsDialog extends StatefulWidget {
  final VoidCallback onAgreed;
  const _TermsAndConditionsDialog({required this.onAgreed});

  @override
  State<_TermsAndConditionsDialog> createState() =>
      _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<_TermsAndConditionsDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        if (!_isScrolledToBottom) {
          setState(() {
            _isScrolledToBottom = true;
          });
        }
      }
    });
    // Check if content is smaller than screen initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent <= 0) {
        setState(() {
          _isScrolledToBottom = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Terms and Conditions",
                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            UIHelper.verticalSpace(16),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(
                    "Welcome to Team Streak Promo!\n\n"
                    "These terms and conditions outline the rules and regulations for the use of our app.\n\n"
                    "By accessing this app we assume you accept these terms and conditions. Do not continue to use the app if you do not agree to take all of the terms and conditions stated on this page.\n\n"
                    "1. Introduction\n"
                    "By using our app you accept these terms and conditions in full; accordingly, if you disagree with these terms and conditions or any part of these terms and conditions, you must not use our app.\n\n"
                    "2. License to use app\n"
                    "Unless otherwise stated, we or our licensors own the intellectual property rights in the app and material on the app. Subject to the license below, all these intellectual property rights are reserved.\n\n"
                    "3. Acceptable use\n"
                    "You must not use our app in any way that causes, or may cause, damage to the app or impairment of the availability or accessibility of the app; or in any way which is unlawful, illegal, fraudulent or harmful, or in connection with any unlawful, illegal, fraudulent or harmful purpose or activity.\n\n"
                    "4. Restricted access\n"
                    "Access to certain areas of our app is restricted. We reserve the right to restrict access to other areas of our app, or indeed our whole app, at our discretion.\n\n"
                    "5. User content\n"
                    "In these terms and conditions, “your user content” means material (including without limitation text, images, audio material, video material and audio-visual material) that you submit to our app, for whatever purpose.\n\n"
                    "6. Limited warranties\n"
                    "We do not warrant the completeness or accuracy of the information published on this app; nor do we commit to ensuring that the app remains available or that the material on the app is kept up-to-date.\n\n"
                    "7. Breaches of these terms and conditions\n"
                    "Without prejudice to our other rights under these terms and conditions, if you breach these terms and conditions in any way, we may take such action as we deem appropriate to deal with the breach, including suspending your access to the app, prohibiting you from accessing the app.\n\n"
                    "8. Variation\n"
                    "We may revise these terms and conditions from time to time. Revised terms and conditions will apply to the use of our app from the date of the publication of the revised terms and conditions on our app.\n\n"
                    "9. Assignment\n"
                    "We may transfer, sub-contract or otherwise deal with our rights and/or obligations under these terms and conditions without notifying you or obtaining your consent.\n\n"
                    "10. Severability\n"
                    "If a provision of these terms and conditions is determined by any court or other competent authority to be unlawful and/or unenforceable, the other provisions will continue in effect.\n\n"
                    "Please scroll to the bottom to agree to the terms.",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ),
              ),
            ),
            UIHelper.verticalSpace(16),
            Opacity(
              opacity: _isScrolledToBottom ? 1.0 : 0.5,
              child: CustomGradientButton(
                onPressed: _isScrolledToBottom ? widget.onAgreed : null,
                child: Text(
                  "I have read and agree",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.textStyle16c000000SFPro590.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.c262824,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
