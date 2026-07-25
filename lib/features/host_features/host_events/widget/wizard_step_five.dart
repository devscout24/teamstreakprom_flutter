import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import '../../auth/widget/document_upload_widget.dart';

class WizardStepFive extends StatelessWidget {
  final List<Map<String, dynamic>> rewards;
  final ValueChanged<int> onRemoveReward;
  final TextEditingController rewardTitleController;
  final TextEditingController rewardDescController;
  final List<String> rewardPhotoPaths;
  final VoidCallback onAddPhotos;
  final ValueChanged<int> onRemovePhoto;
  final TextEditingController rewardQuantityController;
  final VoidCallback onAddReward;
  final VoidCallback onContinue;

  const WizardStepFive({
    super.key,
    required this.rewards,
    required this.onRemoveReward,
    required this.rewardTitleController,
    required this.rewardDescController,
    required this.rewardPhotoPaths,
    required this.onAddPhotos,
    required this.onRemovePhoto,
    required this.rewardQuantityController,
    required this.onAddReward,
    required this.onContinue,
  });

  Widget _buildRewardImage(
    dynamic rewardImage, {
    required double width,
    required double height,
  }) {
    if (rewardImage is List && rewardImage.isNotEmpty) {
      return Image.file(
        File(rewardImage[0]),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: AppColors.c242A34,
          child: Icon(
            Icons.broken_image,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      );
    } else if (rewardImage is String && rewardImage.startsWith("http")) {
      return Image.network(
        rewardImage,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: AppColors.c242A34,
        child: Icon(
          Icons.card_giftcard,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Reward",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        UIHelper.verticalSpace(8),
        Text(
          "Create an exclusive reward to encourage more ticket purchases.",
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 14.sp,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        UIHelper.verticalSpace(24),

        // Uploaded Reward Cards List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rewards.length,
          separatorBuilder: (context, index) => UIHelper.verticalSpace(16),
          itemBuilder: (context, index) {
            final reward = rewards[index];
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1E222B),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: _buildRewardImage(
                      reward["image"],
                      width: 80.w,
                      height: 60.h,
                    ),
                  ),
                  UIHelper.horizontalSpace(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward["title"],
                          style: TextStyle(
                            fontFamily: "SF Pro Rounded",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        UIHelper.verticalSpace(4),
                        Text(
                          reward["desc"],
                          style: TextStyle(
                            fontFamily: "SF Pro",
                            fontSize: 11.sp,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        UIHelper.verticalSpace(6),
                        Text(
                          "Available in ${reward['qty']}pcs",
                          style: TextStyle(
                            fontFamily: "SF Pro",
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColorSecond,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onRemoveReward(index),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.redAccent,
                        size: 16.w,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        UIHelper.verticalSpace(24),

        // Reward Title
        _buildLabel("Reward Title"),
        _buildTextField(
          controller: rewardTitleController,
          hint: "e.g. Free Adidas Shoes",
        ),
        UIHelper.verticalSpace(16),

        // Reward Description
        _buildLabel("Reward Description"),
        _buildTextField(
          controller: rewardDescController,
          hint: "Tell attendees about this event ...",
          maxLines: 4,
        ),
        UIHelper.verticalSpace(16),

        // Reward Photo Upload
        DocumentUploadWidget(
          label: "Reward Photo",
          fileName: rewardPhotoPaths.isNotEmpty
              ? "${rewardPhotoPaths.length} photos selected"
              : null,
          onTap: onAddPhotos,
          onRemove: () => onRemovePhoto(-1),
        ),

        // Horizontal Selected Reward Photos Previews
        if (rewardPhotoPaths.isNotEmpty) ...[
          UIHelper.verticalSpace(12),
          SizedBox(
            height: 70.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: rewardPhotoPaths.length,
              separatorBuilder: (context, index) =>
                  UIHelper.horizontalSpace(10),
              itemBuilder: (context, index) {
                final path = rewardPhotoPaths[index];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 1.w,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11.r),
                        child: Image.file(
                          File(path),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: AppColors.c242A34,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  size: 20.w,
                                ),
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6.h,
                      right: -6.w,
                      child: GestureDetector(
                        onTap: () => onRemovePhoto(index),
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 10.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
        UIHelper.verticalSpace(16),

        // Reward Quantity
        _buildLabel("Reward Quantity"),
        _buildTextField(
          controller: rewardQuantityController,
          hint: "e.g. 200",
          keyboardType: TextInputType.number,
        ),
        UIHelper.verticalSpace(20),

        // Add Another Reward Outline Button
        GestureDetector(
          onTap: onAddReward,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.primaryColorFirst,
                width: 1.5.w,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.primaryColorFirst, size: 18.w),
                UIHelper.horizontalSpace(4),
                Text(
                  "Add Another Reward",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColorFirst,
                  ),
                ),
              ],
            ),
          ),
        ),
        UIHelper.verticalSpace(30),

        // Continue Button
        _buildContinueButton(onContinue),
        UIHelper.verticalSpace(30),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: "SF Pro Rounded",
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    Widget? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: "SF Pro",
        fontSize: 14.sp,
        color: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 14.sp,
          color: Colors.white.withValues(alpha: 0.3),
        ),
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: const Color(0xFF1E222B),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: maxLines > 1 ? 14.h : 16.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.primaryColorFirst,
            width: 1.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: Colors.redAccent, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildContinueButton(VoidCallback onPressed) {
    return CustomGradientButton(
      onPressed: onPressed,
      title: "Continue",
      borderRadius: BorderRadius.circular(16.r),
    );
  }
}
