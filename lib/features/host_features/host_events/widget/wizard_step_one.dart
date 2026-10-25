import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import '../../auth/widget/custom_selector_field.dart';

class WizardStepOne extends StatelessWidget {
  final TextEditingController eventNameController;
  final TextEditingController eventDescController;
  final String? selectedCategory;
  final String? selectedSubcategory;
  final TextEditingController locationController;
  final VoidCallback onCategoryTap;
  final VoidCallback onSubcategoryTap;
  final VoidCallback? onLocationTap;
  final VoidCallback onContinue;
  final bool isLoadingCategories;
  final bool isLoadingSubcategories;
  final bool hasSubcategories;

  const WizardStepOne({
    super.key,
    required this.eventNameController,
    required this.eventDescController,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.locationController,
    required this.onCategoryTap,
    required this.onSubcategoryTap,
    this.onLocationTap,
    required this.onContinue,
    this.isLoadingCategories = false,
    this.isLoadingSubcategories = false,
    this.hasSubcategories = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Event Details",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        UIHelper.verticalSpace(8),
        Text(
          "Enter your event information. This information will be displayed to attendees all across our platform.",
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 14.sp,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        UIHelper.verticalSpace(24),

        // Event Name field
        _buildLabel("Event Name"),
        _buildTextField(
          controller: eventNameController,
          hint: "e.g. Rock and Riot Concert",
        ),
        UIHelper.verticalSpace(16),

        // Event Description field
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Text.rich(
            TextSpan(
              text: "Description ",
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text:
                      "(This information will be displayed to the public after this event has been posted.)",
                  style: TextStyle(
                    fontFamily: "SF Pro",
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildTextField(
          controller: eventDescController,
          hint: "Tell attendees about this event ...",
          maxLines: 4,
        ),
        UIHelper.verticalSpace(16),

        // Category dropdown selector
        _buildLabel("Category"),
        isLoadingCategories
            ? Container(
                height: 54.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E222B),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1.w,
                  ),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    color: AppColors.primaryColorFirst,
                    strokeWidth: 2,
                  ),
                ),
              )
            : CustomSelectorField(
                value: selectedCategory,
                hintText: "Choose Categories",
                onTap: onCategoryTap,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please select a category";
                  }
                  return null;
                },
              ),
        UIHelper.verticalSpace(16),

        // Subcategory dropdown selector
        _buildLabel("Subcategory"),
        isLoadingSubcategories
            ? Container(
                height: 54.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E222B),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                    width: 1.w,
                  ),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    color: AppColors.primaryColorFirst,
                    strokeWidth: 2,
                  ),
                ),
              )
            : CustomSelectorField(
                value: selectedSubcategory,
                hintText: "Choose Subcategories",
                onTap: onSubcategoryTap,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please select a subcategory";
                  }
                  return null;
                },
              ),
        UIHelper.verticalSpace(16),

        // Location text field
        _buildLabel("Location"),
        _buildTextField(
          controller: locationController,
          hint: "e.g. New York, US",
          readOnly: onLocationTap != null,
          onTap: onLocationTap,
          prefixIcon: Icon(
            Icons.location_on_outlined,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          suffixIcon: onLocationTap != null
              ? Icon(
                  Icons.map_outlined,
                  color: AppColors.primaryColorFirst,
                  size: 20.sp,
                )
              : null,
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
    Widget? suffixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
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
        suffixIcon: suffixIcon,
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
