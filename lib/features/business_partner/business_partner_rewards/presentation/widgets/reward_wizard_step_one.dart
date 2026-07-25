import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../common_widgets/custom_textform_field.dart';
import '../../../../../common_widgets/custom_gradient_button.dart';

class RewardWizardStepOne extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final VoidCallback onNextStep;

  const RewardWizardStepOne({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    required this.onNextStep,
  });

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.cE9EAE9,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reward Details",
          style: TextFontStyle.textStyle16cFFFFFFSFPro590.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        UIHelper.verticalSpace(8.h),
        Text(
          "Create an exclusive reward to encourage more ticket purchases.",
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: AppColors.cBCBCBB,
            fontSize: 13.sp,
            height: 1.4,
          ),
        ),
        UIHelper.verticalSpace(24.h),

        // Reward Title
        _buildLabel("Reward Title"),
        CustomTextFormField(
          controller: titleController,
          hintText: "Kimberly Gilbert",
        ),
        UIHelper.verticalSpace(20.h),

        // Reward Description
        _buildLabel("Reward Description"),
        CustomTextFormField(
          controller: descriptionController,
          hintText: "Tell attendees about this event ...",
          borderRadius: BorderRadius.circular(20.r),
          maxLines: 5,
        ),
        UIHelper.verticalSpace(20.h),

        // Reward Category
        _buildLabel("Reward Category"),
        DropdownButtonFormField<String>(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withValues(alpha: 0.4),
            size: 20.sp,
          ),
          dropdownColor: AppColors.c242A34,
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.cE9EAE9,
          ),
          hint: Text(
            "Choose Categories",
            style: TextStyle(
              fontFamily: "SF Pro",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.cB7B8BA,
            ),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.c242A34,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 18.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.r),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: .2),
                width: 1.w,
              ),
            ),
          ),
          items: ["Category 1", "Category 2"].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {},
        ),
        UIHelper.verticalSpace(20.h),

        // Reward Subcategory
        _buildLabel("Reward Subcategory"),
        DropdownButtonFormField<String>(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withValues(alpha: 0.4),
            size: 20.sp,
          ),
          dropdownColor: AppColors.c242A34,
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.cE9EAE9,
          ),
          hint: Text(
            "Choose Subcategories",
            style: TextStyle(
              fontFamily: "SF Pro",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.cB7B8BA,
            ),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.c242A34,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 18.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100.r),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: .2),
                width: 1.w,
              ),
            ),
          ),
          items: ["Subcategory 1", "Subcategory 2"].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (newValue) {},
        ),
        UIHelper.verticalSpace(20.h),

        // Location
        _buildLabel("Location"),
        CustomTextFormField(
          controller: locationController,
          hintText: "New York, US",
          prefixIcon: Icons.location_on_outlined,
        ),
        UIHelper.verticalSpace(32.h),

        // Continue Button
        CustomGradientButton(
          onPressed: onNextStep,
          title: "Continue",
          height: 50.h,
          textStyle: TextFontStyle.textStyle16c000000SFPro590.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B1C1A),
          ),
        ),
        UIHelper.verticalSpace(16.h),
      ],
    );
  }
}
