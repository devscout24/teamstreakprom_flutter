import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import '../../auth/widget/custom_selector_field.dart';

class WizardStepOne extends StatelessWidget {
  final TextEditingController eventNameController;
  final TextEditingController eventDescController;
  final String? selectedCategory;
  final String? selectedSubcategory;
  final TextEditingController locationController;
  final VoidCallback onCategoryTap;
  final VoidCallback onSubcategoryTap;
  final VoidCallback onContinue;

  const WizardStepOne({
    super.key,
    required this.eventNameController,
    required this.eventDescController,
    required this.selectedCategory,
    required this.selectedSubcategory,
    required this.locationController,
    required this.onCategoryTap,
    required this.onSubcategoryTap,
    required this.onContinue,
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
          "Enter your event information to help attendees discover and join your event.",
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
        _buildLabel("Event Description"),
        _buildTextField(
          controller: eventDescController,
          hint: "Tell attendees about this event ...",
          maxLines: 4,
        ),
        UIHelper.verticalSpace(16),

        // Category dropdown selector
        _buildLabel("Event Category"),
        CustomSelectorField(
          value: selectedCategory,
          hintText: "Choose Categories",
          onTap: onCategoryTap,
        ),
        UIHelper.verticalSpace(16),

        // Subcategory dropdown selector
        _buildLabel("Event Subcategory"),
        CustomSelectorField(
          value: selectedSubcategory,
          hintText: "Choose Subcategories",
          onTap: onSubcategoryTap,
        ),
        UIHelper.verticalSpace(16),

        // Location text field
        _buildLabel("Location"),
        _buildTextField(
          controller: locationController,
          hint: "e.g. New York, US",
          prefixIcon: Icon(Icons.location_on_outlined, color: Colors.white.withValues(alpha: 0.4)),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: maxLines > 1 ? 14.h : 16.h),
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
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Colors.redAccent,
            width: 1.w,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFF28F31),
              Color(0xFF72E84F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          "Continue",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
