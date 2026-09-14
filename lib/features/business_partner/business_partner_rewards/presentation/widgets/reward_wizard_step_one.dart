import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_rewards/data/rx_get_reward_categories/rx.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_rewards/model/reward_category_model.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_rewards/data/rx_get_reward_subcategories/rx.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_rewards/model/reward_subcategory_model.dart';
import '../../../../../gen/colors.gen.dart';
import '../../../../../helpers/ui_helpers.dart';
import '../../../../../constants/text_font_style.dart';
import '../../../../../common_widgets/custom_textform_field.dart';
import '../../../../../common_widgets/custom_gradient_button.dart';
import 'package:shimmer/shimmer.dart';

class RewardWizardStepOne extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final VoidCallback onNextStep;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onSubcategoryChanged;
  final void Function(String? id, String? name)? onCategorySelected;
  final void Function(String? id, String? name)? onSubcategorySelected;
  final String? initialCategoryId;
  final String? initialSubcategoryId;

  const RewardWizardStepOne({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    required this.onNextStep,
    required this.onCategoryChanged,
    required this.onSubcategoryChanged,
    this.onCategorySelected,
    this.onSubcategorySelected,
    this.initialCategoryId,
    this.initialSubcategoryId,
  });

  @override
  State<RewardWizardStepOne> createState() => _RewardWizardStepOneState();
}

class _RewardWizardStepOneState extends State<RewardWizardStepOne> {
  String? _selectedCategory;
  String? _selectedSubcategory;
  bool _isCategorySelected = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategoryId;
    _selectedSubcategory = widget.initialSubcategoryId;
    _isCategorySelected =
        widget.initialCategoryId != null && widget.initialCategoryId!.isNotEmpty;
    if (_isCategorySelected && widget.initialCategoryId != null) {
      getRewardSubcategoriesRx
          .getRewardSubcategories(widget.initialCategoryId!);
    }
  }

  @override
  void didUpdateWidget(covariant RewardWizardStepOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategoryId != oldWidget.initialCategoryId) {
      _selectedCategory = widget.initialCategoryId;
      _isCategorySelected = widget.initialCategoryId != null &&
          widget.initialCategoryId!.isNotEmpty;
      if (_isCategorySelected && widget.initialCategoryId != null) {
        getRewardSubcategoriesRx
            .getRewardSubcategories(widget.initialCategoryId!);
      }
    }
    if (widget.initialSubcategoryId != oldWidget.initialSubcategoryId) {
      _selectedSubcategory = widget.initialSubcategoryId;
    }
  }

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
          controller: widget.titleController,
          hintText: "Kimberly Gilbert",
          validator: (value) => value == null || value.isEmpty ? "Required" : null,
        ),
        UIHelper.verticalSpace(20.h),

        // Reward Description
        _buildLabel("Reward Description"),
        CustomTextFormField(
          controller: widget.descriptionController,
          hintText: "Tell attendees about this event ...",
          borderRadius: BorderRadius.circular(20.r),
          maxLines: 5,
          validator: (value) => value == null || value.isEmpty ? "Required" : null,
        ),
        UIHelper.verticalSpace(20.h),

        // Reward Category
        _buildLabel("Reward Category"),
        StreamBuilder<RewardCategoryResponse>(
          stream: getRewardCategoriesRx.getRewardCategoriesData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return Shimmer.fromColors(
                baseColor: const Color(0xFF1E222B),
                highlightColor: Colors.white.withValues(alpha: 0.05),
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              );
            }
            List<RewardCategoryModel> categories = [];
            if (snapshot.hasData && snapshot.data?.data != null) {
              categories = snapshot.data!.data!;
            }
            return DropdownButtonFormField<String>(
              initialValue: categories.any((c) => c.id == _selectedCategory)
                  ? _selectedCategory
                  : null,
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
              items: categories.map((RewardCategoryModel category) {
                return DropdownMenuItem<String>(
                  value: category.id,
                  child: Text(category.name ?? ""),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                    _isCategorySelected = true;
                    _selectedSubcategory = null;
                  });
                  getRewardSubcategoriesRx.getRewardSubcategories(newValue);
                  final selectedCategory =
                      categories.where((c) => c.id == newValue).firstOrNull;
                  widget.onCategoryChanged(newValue);
                  widget.onCategorySelected?.call(newValue, selectedCategory?.name);
                  widget.onSubcategoryChanged(null);
                  widget.onSubcategorySelected?.call(null, null);
                }
              },
              validator: (value) => value == null || value.isEmpty ? "Required" : null,
            );
          },
        ),
        UIHelper.verticalSpace(20.h),

        if (_isCategorySelected) ...[
          // Reward Subcategory
          _buildLabel("Reward Subcategory"),
          StreamBuilder<RewardSubcategoryResponse>(
          stream: getRewardSubcategoriesRx.getRewardSubcategoriesData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return Shimmer.fromColors(
                baseColor: const Color(0xFF1E222B),
                highlightColor: Colors.white.withValues(alpha: 0.05),
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E222B),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              );
            }
            List<RewardSubcategoryModel> subcategories = [];
            if (snapshot.hasData && snapshot.data?.data != null) {
              subcategories = snapshot.data!.data!;
            }
            return DropdownButtonFormField<String>(
              initialValue: subcategories.any((s) => s.id == _selectedSubcategory)
                  ? _selectedSubcategory
                  : null,
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
              items: subcategories.map((RewardSubcategoryModel subcategory) {
                return DropdownMenuItem<String>(
                  value: subcategory.id,
                  child: Text(subcategory.name ?? ""),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedSubcategory = newValue;
                });
                final selectedSub =
                    subcategories.where((s) => s.id == newValue).firstOrNull;
                widget.onSubcategoryChanged(newValue);
                widget.onSubcategorySelected?.call(newValue, selectedSub?.name);
              },
              // Subcategory is optional, so no validator required
            );
          },
        ),
        UIHelper.verticalSpace(20.h),
        ],

        // Location
        _buildLabel("Location"),
        CustomTextFormField(
          controller: widget.locationController,
          hintText: "New York, US",
          prefixIcon: Icons.location_on_outlined,
          validator: (value) => value == null || value.isEmpty ? "Required" : null,
        ),
        UIHelper.verticalSpace(32.h),

        // Continue Button
        CustomGradientButton(
          onPressed: widget.onNextStep,
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
