import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import '../../auth/widget/custom_selector_field.dart';
import '../../auth/widget/document_upload_widget.dart';
import '../model/event_model.dart';

class WizardStepTwo extends StatelessWidget {
  final TextEditingController startDateController;
  final TextEditingController startTimeController;
  final TextEditingController endDateController;
  final TextEditingController endTimeController;
  final TextEditingController priceController;
  final TextEditingController capacityController;
  final List<PriceCategoryFormModel> priceCategories;
  final VoidCallback onAddPriceCategory;
  final ValueChanged<int> onRemovePriceCategory;
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
    required this.priceCategories,
    required this.onAddPriceCategory,
    required this.onRemovePriceCategory,
    required this.eventPhotoPaths,
    required this.onAddPhotos,
    required this.onRemovePhoto,
    required this.selectedAgeRestriction,
    required this.onAgeRestrictionTap,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    int totalTierTickets = 0;
    for (var cat in priceCategories) {
      final stock = int.tryParse(cat.stockController.text.trim()) ?? 0;
      totalTierTickets += stock;
    }
    final int enteredCapacity =
        int.tryParse(capacityController.text.trim()) ?? 0;
    final bool isCapacityExceeded =
        priceCategories.isNotEmpty &&
        enteredCapacity > 0 &&
        totalTierTickets > enteredCapacity;

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
                    hint: "YYYY-MM-DD",
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
                    hint: "YYYY-MM-DD",
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

        // ── Ticket Price & Categories ───────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Ticket Price & Categories"),
                  Text(
                    "Configure ticket tiers, price and seat allocations",
                    style: TextStyle(
                      fontFamily: "SF Pro",
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (priceCategories.isNotEmpty) ...[
              UIHelper.horizontalSpace(8),
              _buildAddTierButton(onAddPriceCategory),
            ],
          ],
        ),
        UIHelper.verticalSpace(12),

        // If no price categories yet, display "+Add ticket Tier" as the primary button
        if (priceCategories.isEmpty) ...[
          _buildEmptyAddTierButton(onAddPriceCategory),
          UIHelper.verticalSpace(16),
        ] else ...[
          // List of Price Category Cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: priceCategories.length,
            separatorBuilder: (context, index) => UIHelper.verticalSpace(12),
            itemBuilder: (context, index) {
              final category = priceCategories[index];
              return _buildPriceCategoryCard(
                category: category,
                index: index,
                totalCount: priceCategories.length,
                onRemove: () => onRemovePriceCategory(index),
              );
            },
          ),
          UIHelper.verticalSpace(12),
          _buildAddTierSecondaryButton(onAddPriceCategory),
          UIHelper.verticalSpace(16),
        ],

        // Max Venue Capacity
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel("Max Venue capacity"),
                UIHelper.horizontalSpace(6),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: GestureDetector(
                    onTap: () => _showVenueCapacityInfoDialog(context),
                    child: Tooltip(
                      message:
                          "The max venue capacity details are necessary to ensure that we are able to distribute the correct amount of tickets to meet your specifications",
                      triggerMode: TooltipTriggerMode.tap,
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 15.sp,
                          color: AppColors.primaryColorSecond,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (priceCategories.isNotEmpty && totalTierTickets > 0)
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: isCapacityExceeded
                          ? Colors.redAccent.withValues(alpha: 0.15)
                          : AppColors.primaryColorSecond.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6.r),
                      border: isCapacityExceeded
                          ? Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.4),
                              width: 1.w,
                            )
                          : null,
                    ),
                    child: Text(
                      isCapacityExceeded
                          ? "Tier tickets: $totalTierTickets (Exceeds Limit)"
                          : "Tier tickets: $totalTierTickets",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isCapacityExceeded
                            ? Colors.redAccent
                            : AppColors.primaryColorSecond,
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
          ],
        ),
        _buildTextField(
          controller: capacityController,
          hint: "e.g. 40",
          keyboardType: TextInputType.number,
          prefixIcon: Icon(
            Icons.people_outline_rounded,
            size: 20.sp,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "This field is required";
            }
            final venueCapacity = int.tryParse(value.trim());
            if (venueCapacity == null || venueCapacity <= 0) {
              return "Please enter a valid capacity";
            }
            if (priceCategories.isNotEmpty &&
                totalTierTickets > venueCapacity) {
              return "max limit $venueCapacity";
            }
            return null;
          },
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
                        child: path.startsWith('http')
                            ? Image.network(
                                path,
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
                              )
                            : Image.file(
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

  Widget _buildPriceCategoryCard({
    required PriceCategoryFormModel category,
    required int index,
    required int totalCount,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF191D26),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColorSecond.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.confirmation_number_outlined,
                        size: 16.sp,
                        color: AppColors.primaryColorSecond,
                      ),
                    ),
                    UIHelper.horizontalSpace(8),
                    Flexible(
                      child: Text(
                        category.nameController.text.isNotEmpty
                            ? "${category.nameController.text} Ticket"
                            : "Category ${index + 1}",
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (totalCount > 1) ...[
                UIHelper.horizontalSpace(8),
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 20.sp,
                      color: Colors.redAccent.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ],
            ],
          ),
          UIHelper.verticalSpace(12),
          _buildLabel("Category Name"),
          _buildTextField(
            controller: category.nameController,
            hint: "e.g. VIP, General, Early Bird",
          ),
          UIHelper.verticalSpace(12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Price (\$)"),
                    _buildTextField(
                      controller: category.priceController,
                      hint: "e.g. 200",
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 14.w, right: 8.w),
                        child: Text(
                          "\$",
                          style: TextStyle(
                            fontFamily: "SF Pro Rounded",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColorSecond,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              UIHelper.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Maximum capacity"),
                    _buildTextField(
                      controller: category.stockController,
                      hint: "e.g. 20",
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(
                        Icons.people_outline_rounded,
                        size: 18.sp,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddTierButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColorSecond.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.primaryColorSecond.withValues(alpha: 0.4),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_rounded,
              size: 16.sp,
              color: AppColors.primaryColorSecond,
            ),
            UIHelper.horizontalSpace(4),
            Text(
              "+Add ticket Tier",
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColorSecond,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAddTierButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF191D26),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.primaryColorSecond.withValues(alpha: 0.35),
            width: 1.2.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              size: 18.sp,
              color: AppColors.primaryColorSecond,
            ),
            UIHelper.horizontalSpace(8),
            Text(
              "+Add ticket Tier",
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColorSecond,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTierSecondaryButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColorSecond.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primaryColorSecond.withValues(alpha: 0.25),
            width: 1.w,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              size: 16.sp,
              color: AppColors.primaryColorSecond,
            ),
            UIHelper.horizontalSpace(6),
            Text(
              "+Add ticket Tier",
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColorSecond,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVenueCapacityInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E222B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.w,
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: AppColors.primaryColorSecond,
              size: 22.sp,
            ),
            UIHelper.horizontalSpace(8),
            Text(
              "Max Venue Capacity",
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        content: Text(
          "The max venue capacity details are necessary to ensure that we are able to distribute the correct amount of tickets to meet your specifications",
          style: TextStyle(
            fontFamily: "SF Pro",
            fontSize: 13.sp,
            color: Colors.white.withValues(alpha: 0.8),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Got it",
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColorFirst,
              ),
            ),
          ),
        ],
      ),
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
    String? Function(String?)? validator,
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
      validator: validator ??
          (value) {
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
        prefixIconConstraints: BoxConstraints(minWidth: 36.w, minHeight: 0),
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
            controller.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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
            controller.text = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
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
