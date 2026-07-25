import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import '../../auth/widget/custom_selector_field.dart';
import '../../auth/widget/document_upload_widget.dart';

class WizardStepTwo extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController startTimeController;
  final TextEditingController endDateController;
  final TextEditingController endTimeController;
  final TextEditingController priceController;
  final TextEditingController capacityController;
  final List<String> eventPhotoPaths;
  final VoidCallback onAddPhotos;
  final ValueChanged<int> onRemovePhoto;
  final String? selectedAgeRestriction;
  final VoidCallback onAgeRestrictionTap;
  final VoidCallback onContinue;

  const WizardStepTwo({
    super.key,
    required this.startDateController,
    required this.startTimeController,
    required this.endDateController,
    required this.endTimeController,
    required this.priceController,
    required this.capacityController,
    required this.eventPhotoPaths,
    required this.onAddPhotos,
    required this.onRemovePhoto,
    required this.selectedAgeRestriction,
    required this.onAgeRestrictionTap,
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

        // Start Date and Time Row
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Start Date & Time"),
                  _buildDateField(
                    context,
                    controller: startDateController,
                    hint: "DD/MM/YYYY",
                  ),
                ],
              ),
            ),
            UIHelper.horizontalSpace(12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(" "),
                  _buildTimeField(
                    context,
                    controller: startTimeController,
                    hint: "Set time",
                  ),
                ],
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(16),

        // End Date and Time Row
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("End Date & Time"),
                  _buildDateField(
                    context,
                    controller: endDateController,
                    hint: "DD/MM/YYYY",
                  ),
                ],
              ),
            ),
            UIHelper.horizontalSpace(12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(" "),
                  _buildTimeField(
                    context,
                    controller: endTimeController,
                    hint: "Set time",
                  ),
                ],
              ),
            ),
          ],
        ),
        UIHelper.verticalSpace(16),

        // Ticket Price
        _buildLabel("Ticket Price"),
        _buildTextField(
          controller: priceController,
          hint: "e.g. 50",
          keyboardType: TextInputType.number,
        ),
        UIHelper.verticalSpace(16),

        // People Capacity
        _buildLabel("People Capacity"),
        _buildTextField(
          controller: capacityController,
          hint: "e.g. 200",
          keyboardType: TextInputType.number,
        ),
        UIHelper.verticalSpace(16),

        // Event Photos Upload
        DocumentUploadWidget(
          label: "Event Photos",
          fileName: eventPhotoPaths.isNotEmpty
              ? "${eventPhotoPaths.length} photos selected"
              : null,
          onTap: onAddPhotos,
          onRemove: () => onRemovePhoto(-1), // special flag to remove all
        ),

        // Multiple Local File Image Previews Row
        if (eventPhotoPaths.isNotEmpty) ...[
          UIHelper.verticalSpace(12),
          SizedBox(
            height: 70.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: eventPhotoPaths.length,
              separatorBuilder: (context, index) =>
                  UIHelper.horizontalSpace(10),
              itemBuilder: (context, index) {
                final path = eventPhotoPaths[index];
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

        // Age Restriction dropdown
        _buildLabel("Age Restriction"),
        CustomSelectorField(
          value: selectedAgeRestriction,
          hintText: "Select restriction",
          onTap: onAgeRestrictionTap,
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

  Widget _buildDateField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
  }) {
    return _buildGradientInputWrapper(
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (date != null) {
            controller.text = "${date.day}/${date.month}/${date.year}";
          }
        },
        style: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 14.sp,
          color: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Required";
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
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildTimeField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
  }) {
    return _buildGradientInputWrapper(
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () async {
          final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            controller.text = time.format(context);
          }
        },
        style: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 14.sp,
          color: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Required";
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
          prefixIcon: Icon(
            Icons.access_time_rounded,
            color: Colors.white.withValues(alpha: 0.4),
            size: 16.w,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 16.h,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildGradientInputWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          colors: [Color(0x77F28F31), Color(0x7772E84F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(1.2.w),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E222B),
          borderRadius: BorderRadius.circular(11.r),
        ),
        child: child,
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
