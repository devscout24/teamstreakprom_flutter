import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/custom_textform_field.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/auth_progress_indicator.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/custom_selector_field.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/helpers/di.dart';
import 'package:teamstreakpromo/constants/app_constants.dart';
import 'package:teamstreakpromo/features/auth/presentation/choose_account_type_screen.dart';

class BusinessDetailsScreen extends StatefulWidget {
  const BusinessDetailsScreen({super.key});

  @override
  State<BusinessDetailsScreen> createState() => _BusinessDetailsScreenState();
}

class _BusinessDetailsScreenState extends State<BusinessDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessDescController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _einNumberController = TextEditingController();

  String? _selectedCategory;
  String? _selectedSubcategory;
  bool _showEinField = false;
  bool _isHost = false;

  @override
  void initState() {
    super.initState();
    String? storedType = appData.read(kAccountType);

    if (storedType == AccountType.host.name ||
        storedType == AccountType.host.toString() ||
        storedType == "AccountType.host") {
      _isHost = true;
    }

    if (storedType == AccountType.businessPartner.name ||
        storedType == AccountType.businessPartner.toString() ||
        storedType == "AccountType.businessPartner") {
      _showEinField = true;
    }
  }

  final List<String> _categories = [
    "Music",
    "Comedy",
    "Sports",
    "Arts & Theatre",
    "Festivals",
    "Others",
  ];

  final List<String> _subcategories = [
    "Concert",
    "Stand-up Comedy",
    "Tournament",
    "Exhibition",
    "Food Festival",
    "Others",
  ];

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessDescController.dispose();
    _locationController.dispose();
    _einNumberController.dispose();
    super.dispose();
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Event Category",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              UIHelper.verticalSpace(16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1.h,
                  ),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        cat,
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 15.sp,
                          color: isSelected
                              ? AppColors.primaryColorSecond
                              : Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_outline,
                              color: AppColors.primaryColorSecond,
                              size: 20.w,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSubcategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Event Subcategory",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              UIHelper.verticalSpace(16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _subcategories.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1.h,
                  ),
                  itemBuilder: (context, index) {
                    final sub = _subcategories[index];
                    final isSelected = _selectedSubcategory == sub;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        sub,
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 15.sp,
                          color: isSelected
                              ? AppColors.primaryColorSecond
                              : Colors.white,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_outline,
                              color: AppColors.primaryColorSecond,
                              size: 20.w,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedSubcategory = sub;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, route to Step 3
      debugPrint("Business Name: ${_businessNameController.text}");
      if (_showEinField) {
        debugPrint("EIN Number: ${_einNumberController.text}");
      }
      debugPrint("Business Description: ${_businessDescController.text}");
      debugPrint("Location: ${_locationController.text}");
      debugPrint("Category: $_selectedCategory");
      debugPrint("Subcategory: $_selectedSubcategory");

      NavigationService.navigateTo(Routes.verifyIdentityScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpace(16),
                      // Back Button
                      const CustomBackButton(),
                      UIHelper.verticalSpace(32),

                      // Title
                      Text(
                        "Business Details",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SF Pro Rounded",
                            ),
                      ),
                      UIHelper.verticalSpace(8),

                      // Subtitle
                      Text(
                        "Setup your public profile page shown to customers on the app.",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: AppColors.cFFFFFF.withValues(alpha: 0.6),
                              fontFamily: "SF Pro",
                            ),
                      ),
                      UIHelper.verticalSpace(24),

                      // Progress Indicator (Step 2 of 4)
                      const AuthProgressIndicator(
                        currentStep: 2,
                        totalSteps: 4,
                      ),
                      UIHelper.verticalSpace(36),

                      // Fields
                      CustomTextFormField(
                        controller: _businessNameController,
                        hintText: "Business Name",
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Business name is required";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(16),

                      CustomTextFormField(
                        maxLines: 5,
                        borderRadius: BorderRadius.circular(20),
                        controller: _businessDescController,
                        hintText: "Business Description",

                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Business description is required";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(16),
                      if (_showEinField) ...[
                        CustomTextFormField(
                          controller: _einNumberController,
                          hintText: "EIN Number",
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "EIN Number is required";
                            }
                            return null;
                          },
                        ),
                        UIHelper.verticalSpace(16),
                      ],

                      CustomTextFormField(
                        controller: _locationController,
                        hintText: "Location",
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Location is required";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(16),

                      CustomSelectorField(
                        value: _selectedCategory,
                        hintText: _isHost ? "Event Category" : "Category",
                        onTap: _showCategoryBottomSheet,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select category";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(16),

                      CustomSelectorField(
                        value: _selectedSubcategory,
                        hintText: _isHost ? "Event Subcategory" : "Subcategory",
                        onTap: _showSubcategoryBottomSheet,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select subcategory";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(40),
                    ],
                  ),
                ),
              ),
            ),
            // Floating bottom Continue button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: CustomGradientButton(
                onPressed: _submitForm,
                title: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
