import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../common_widgets/custom_gradient_button.dart';
import '../../../../../common_widgets/app_network_image.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/document_upload_widget.dart';
import '../../../../../common_widgets/custom_toast.dart';

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

  DateTime _stripTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  DateTime? _parseDate(String text) {
    if (text.trim().isEmpty) return null;
    try {
      if (text.contains('/')) {
        final parts = text.trim().split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      } else if (text.contains('-')) {
        final parts = text.trim().split('-');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
    } catch (_) {}
    return null;
  }

  TimeOfDay? _parseTime(String text) {
    if (text.trim().isEmpty) return null;
    try {
      final clean = text.trim().toUpperCase();
      final isPM = clean.contains('PM');
      final isAM = clean.contains('AM');
      final digits = clean.replaceAll(RegExp(r'[^0-9:]'), '');
      final parts = digits.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        if (isPM && hour < 12) hour += 12;
        if (isAM && hour == 12) hour = 0;
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {}
    return null;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final today = _stripTime(DateTime.now());
    final parsedStart = _parseDate(startDateController.text);
    final parsedEnd = _parseDate(endDateController.text);

    DateTime firstDate = today;
    if (parsedStart != null && parsedStart.isBefore(today)) {
      firstDate = parsedStart;
    }

    // Natural stop mark: Start date cannot be after end date if already chosen
    DateTime lastDate = DateTime(2035);
    if (parsedEnd != null && !parsedEnd.isBefore(firstDate)) {
      lastDate = parsedEnd;
    }

    DateTime initialDate = firstDate;
    if (parsedStart != null) {
      if (parsedStart.isBefore(firstDate)) {
        initialDate = firstDate;
      } else if (parsedStart.isAfter(lastDate)) {
        initialDate = lastDate;
      } else {
        initialDate = parsedStart;
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      startDateController.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";

      if (parsedEnd != null && picked.isAtSameMomentAs(parsedEnd)) {
        _validateTimesIfSameDay();
      }
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final today = _stripTime(DateTime.now());
    final parsedStart = _parseDate(startDateController.text);
    final parsedEnd = _parseDate(endDateController.text);

    if (parsedStart == null) {
      customToastMessage(
        "Notice",
        "Please select a start date first.",
        isError: false,
      );
      _selectStartDate(context);
      return;
    }

    // Natural stop mark: End date cannot be before start date
    DateTime firstDate = parsedStart.isBefore(today) ? today : parsedStart;
    DateTime lastDate = DateTime(2035);

    DateTime initialDate = firstDate;
    if (parsedEnd != null) {
      if (parsedEnd.isBefore(firstDate)) {
        initialDate = firstDate;
      } else if (parsedEnd.isAfter(lastDate)) {
        initialDate = lastDate;
      } else {
        initialDate = parsedEnd;
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      endDateController.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";

      if (parsedStart.isAtSameMomentAs(picked)) {
        _validateTimesIfSameDay();
      }
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _parseTime(startTimeController.text) ?? TimeOfDay.now(),
    );
    if (time != null && context.mounted) {
      final start = _parseDate(startDateController.text);
      final end = _parseDate(endDateController.text);
      final eTime = _parseTime(endTimeController.text);

      if (start != null &&
          end != null &&
          start.isAtSameMomentAs(end) &&
          eTime != null) {
        final startMinutes = time.hour * 60 + time.minute;
        final endMinutes = eTime.hour * 60 + eTime.minute;
        if (startMinutes >= endMinutes) {
          customToastMessage(
            "Invalid Time",
            "Start time must be before end time on the same date.",
            isError: true,
          );
          return;
        }
      }
      startTimeController.text = time.format(context);
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _parseTime(endTimeController.text) ?? TimeOfDay.now(),
    );
    if (time != null && context.mounted) {
      final start = _parseDate(startDateController.text);
      final end = _parseDate(endDateController.text);
      final sTime = _parseTime(startTimeController.text);

      if (start != null &&
          end != null &&
          start.isAtSameMomentAs(end) &&
          sTime != null) {
        final startMinutes = sTime.hour * 60 + sTime.minute;
        final endMinutes = time.hour * 60 + time.minute;
        if (endMinutes <= startMinutes) {
          customToastMessage(
            "Invalid Time",
            "End time must be after start time on the same date.",
            isError: true,
          );
          return;
        }
      }
      endTimeController.text = time.format(context);
    }
  }

  void _validateTimesIfSameDay() {
    final sTime = _parseTime(startTimeController.text);
    final eTime = _parseTime(endTimeController.text);
    if (sTime != null && eTime != null) {
      final startMinutes = sTime.hour * 60 + sTime.minute;
      final endMinutes = eTime.hour * 60 + eTime.minute;
      if (endMinutes <= startMinutes) {
        endTimeController.clear();
        customToastMessage(
          "Notice",
          "End time reset because it must be after start time on the same date.",
          isError: false,
        );
      }
    }
  }

  Widget _buildDateField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required VoidCallback onTap,
    String? Function(String?)? validator,
    VoidCallback? onCleared,
  }) {
    return _buildGradientInputWrapper(
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        validator: validator ??
            (value) => value == null || value.isEmpty ? "Required" : null,
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
            Icons.calendar_today_outlined,
            color: Colors.white.withValues(alpha: 0.4),
            size: 16.w,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 16.sp,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                onPressed: () {
                  controller.clear();
                  onCleared?.call();
                },
              );
            },
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

  Widget _buildTimeField(
    BuildContext context, {
    required TextEditingController controller,
    required String hint,
    required VoidCallback onTap,
    String? Function(String?)? validator,
    VoidCallback? onCleared,
  }) {
    return _buildGradientInputWrapper(
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        validator: validator ??
            (value) => value == null || value.isEmpty ? "Required" : null,
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
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.clear,
                  size: 16.sp,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                onPressed: () {
                  controller.clear();
                  onCleared?.call();
                },
              );
            },
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

  void _handleContinue() {
    final start = _parseDate(startDateController.text);
    final end = _parseDate(endDateController.text);

    if (start != null && end != null) {
      if (start.isAfter(end)) {
        customToastMessage(
          "Invalid Date",
          "Start date must be set before end date.",
          isError: true,
        );
        return;
      }
      if (start.isAtSameMomentAs(end)) {
        final sTime = _parseTime(startTimeController.text);
        final eTime = _parseTime(endTimeController.text);
        if (sTime != null && eTime != null) {
          final startMinutes = sTime.hour * 60 + sTime.minute;
          final endMinutes = eTime.hour * 60 + eTime.minute;
          if (endMinutes <= startMinutes) {
            customToastMessage(
              "Invalid Time",
              "End time must be after start time on the same date.",
              isError: true,
            );
            return;
          }
        }
      }
    }
    onNextStep();
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
                    onTap: () => _selectStartDate(context),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required";
                      }
                      final start = _parseDate(value);
                      final end = _parseDate(endDateController.text);
                      if (start != null && end != null && start.isAfter(end)) {
                        return "Must be before end date";
                      }
                      return null;
                    },
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
                    onTap: () => _selectStartTime(context),
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
                    onTap: () => _selectEndDate(context),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required";
                      }
                      final start = _parseDate(startDateController.text);
                      final end = _parseDate(value);
                      if (start != null && end != null && end.isBefore(start)) {
                        return "Must be after start date";
                      }
                      return null;
                    },
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
                    onTap: () => _selectEndTime(context),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required";
                      }
                      final start = _parseDate(startDateController.text);
                      final end = _parseDate(endDateController.text);
                      if (start != null &&
                          end != null &&
                          start.isAtSameMomentAs(end)) {
                        final sTime = _parseTime(startTimeController.text);
                        final eTime = _parseTime(value);
                        if (sTime != null && eTime != null) {
                          if ((eTime.hour * 60 + eTime.minute) <=
                              (sTime.hour * 60 + sTime.minute)) {
                            return "Must be after start time";
                          }
                        }
                      }
                      return null;
                    },
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
        _buildContinueButton(_handleContinue),
        UIHelper.verticalSpace(30),
      ],
    );
  }
}
