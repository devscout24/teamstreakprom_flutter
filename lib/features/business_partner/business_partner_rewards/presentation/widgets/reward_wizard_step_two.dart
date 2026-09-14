import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../common_widgets/custom_gradient_button.dart';
import '../../../../../common_widgets/app_network_image.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/document_upload_widget.dart';

class RewardWizardStepTwo extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController startTimeController;
  final TextEditingController endDateController;
  final TextEditingController endTimeController;
  final TextEditingController pointsController;
  final TextEditingController quantityController;
  final List<String> rewardPhotoPaths;
  final VoidCallback onAddPhotos;
  final Function(int) onRemovePhoto;
  final VoidCallback onNextStep;

  const RewardWizardStepTwo({
    super.key,
    required this.startDateController,
    required this.startTimeController,
    required this.endDateController,
    required this.endTimeController,
    required this.pointsController,
    required this.quantityController,
    required this.rewardPhotoPaths,
    required this.onAddPhotos,
    required this.onRemovePhoto,
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
      validator: (value) => value == null || value.isEmpty ? "Required" : null,
      style: TextStyle(
        fontFamily: "SF Pro",
        fontSize: 14.sp,
        color: Colors.white,
      ),
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
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
        style: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 14.sp,
          color: Colors.white,
        ),
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
          if (time != null && context.mounted) {
            controller.text = time.format(context);
          }
        },
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
        style: TextStyle(
          fontFamily: "SF Pro",
          fontSize: 14.sp,
          color: Colors.white,
        ),
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

        // Reward Points
        _buildLabel("Reward Points"),
        _buildTextField(
          controller: pointsController,
          hint: "242 pts",
          keyboardType: TextInputType.number,
        ),
        UIHelper.verticalSpace(16),

        // Reward Quantity
        _buildLabel("Reward Quantity"),
        _buildTextField(
          controller: quantityController,
          hint: "e.g.200",
          keyboardType: TextInputType.number,
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

        // Multiple Local File Image Previews Row
        UIHelper.verticalSpace(12),
        SizedBox(
          height: 52.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            separatorBuilder: (context, index) => UIHelper.horizontalSpace(8),
            itemBuilder: (context, index) {
              final bool hasPhoto = index < rewardPhotoPaths.length;
              final String? path = hasPhoto ? rewardPhotoPaths[index] : null;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF242721),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                        width: 1.w,
                      ),
                    ),
                    child: hasPhoto && path != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(7.r),
                            child: path.startsWith('http')
                                ? AppNetworkImage(
                                    imageUrl: path,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(path),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: AppColors.c242A34,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.white
                                                    .withValues(alpha: 0.5),
                                                size: 20.w,
                                              ),
                                            ),
                                  ),
                          )
                        : null,
                  ),
                  if (hasPhoto)
                    Positioned(
                      top: -4.h,
                      right: -4.w,
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
                            size: 10.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        UIHelper.verticalSpace(30),

        // Continue Button
        _buildContinueButton(onNextStep),
        UIHelper.verticalSpace(30),
      ],
    );
  }
}
